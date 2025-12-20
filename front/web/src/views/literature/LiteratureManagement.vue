<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="文献名称" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入文献名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="发表时间" style="width: 308px">
        <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD HH:mm:ss" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" :disabled="multiple" @click="handleBatchDownload">批量下载</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="literatureList" @selection-change="handleSelectionChange" @sort-change="handleSortChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="文献名称" align="center" prop="title" v-if="columns[0].visible" :show-overflow-tooltip="true">
        <template #default="scope">
          <span>{{ scope.row.title }}</span>
        </template>
      </el-table-column>
      <el-table-column label="作者" align="center" prop="authors" v-if="columns[1].visible" width="150" :show-overflow-tooltip="true" />
      <el-table-column label="来源" align="center" prop="journal" v-if="columns[2].visible" width="150" :show-overflow-tooltip="true" />
      <el-table-column label="发表时间" align="center" prop="publishTime" v-if="columns[3].visible" width="160" :sortable="true">
        <template #default="scope">
          <span>{{ parseTime(scope.row.publishTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="下载数" align="center" prop="downloadCount" v-if="columns[4].visible" width="100" :sortable="true" />
      <el-table-column label="评分" align="center" prop="finalScore" v-if="columns[5].visible" width="100" :sortable="true">
        <template #default="scope">
          <span>{{ scope.row.finalScore }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-tooltip content="详情" placement="top">
            <el-button link type="primary" icon="Document" @click="handleDetail(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="评分" placement="top">
            <el-button link type="primary" icon="Star" @click="handleScore(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="下载" placement="top">
            <el-button link type="primary" icon="Download" @click="handleDownload(scope.row)"></el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 评分对话框 -->
    <el-dialog :title="'评分文献：' + scoreForm.title" v-model="scoreOpen" width="400px" append-to-body>
      <el-form :model="scoreForm" :rules="scoreRules" ref="scoreRef" label-width="80px">
        <el-form-item label="评分" prop="score">
          <el-rate v-model="scoreForm.score" :max="10" show-score />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitScore">确 定</el-button>
          <el-button @click="cancelScore">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="LiteratureManagement">
import { listLiterature, getLiteratureDetail, downloadLiterature, batchDownloadLiterature, scoreLiterature } from "@/api/experiment/literature"
import { parseTime } from "@/utils/ruoyi"
import { useRouter } from "vue-router"
import { ref, reactive, toRefs, onMounted } from "vue"
import { getCurrentInstance } from "vue"

const router = useRouter()
const { proxy } = getCurrentInstance()

const literatureList = ref([])
const open = ref(false)
const scoreOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const dateRange = ref([])

// 列显隐信息
const columns = ref([
  { key: 0, label: `文献名称`, visible: true },
  { key: 1, label: `作者`, visible: true },
  { key: 2, label: `来源`, visible: true },
  { key: 3, label: `发表时间`, visible: true },
  { key: 4, label: `下载数`, visible: true },
  { key: 5, label: `评分`, visible: true }
])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    title: undefined,
    sortField: undefined,
    sortOrder: undefined
  },
  scoreForm: {
    id: undefined,
    title: undefined,
    score: undefined
  },
  scoreRules: {
    score: [{ required: true, message: "请输入评分", trigger: "change" }]
  }
})

const { queryParams, scoreForm, scoreRules } = toRefs(data)

/** 查询文献列表 */
function getList() {
  loading.value = true
  const params = { ...queryParams.value };
    if (dateRange.value && dateRange.value.length === 2) {
      params.publishTimeStart = dateRange.value[0];
      params.publishTimeEnd = dateRange.value[1];
    }
  listLiterature(params).then(res => {
    loading.value = false
    literatureList.value = res.rows
    total.value = res.total
  })
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 选择条数  */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 详情按钮操作 */
function handleDetail(row) {
  router.push(`/literature/detail/${row.id}`)
}

/** 评分按钮操作 */
function handleScore(row) {
  scoreForm.value.id = row.id
  scoreForm.value.title = row.title
  scoreForm.value.score = row.score !== null ? row.score : undefined
  scoreOpen.value = true
}

/** 提交评分 */
function submitScore() {
  proxy.$refs["scoreRef"].validate((valid) => {
    if (valid) {
      scoreLiterature({
        literatureId: scoreForm.value.id,
        score: scoreForm.value.score
      }).then(() => {
        scoreOpen.value = false
        proxy.$modal.msgSuccess("评分成功")
        getList()
      })
    }
  })
}

/** 取消评分 */
function cancelScore() {
  scoreOpen.value = false
  scoreForm.value.score = undefined
}

/** 下载按钮操作 */
function handleDownload(row) {
  downloadLiterature(row.id).then(res => {
    if (res.code === 200) {
      proxy.download(res.msg, {}, `${row.title}.pdf`)
    } else {
      proxy.$modal.msgError("下载失败")
    }
  })
}

/** 批量下载按钮操作 */
function handleBatchDownload() {
  proxy.$modal.confirm('是否确认批量下载选中的数据项？').then(function () {
    return batchDownloadLiterature(ids.value)
  }).then(() => {
    proxy.$modal.msgSuccess("批量下载成功")
  }).catch(() => {})
}

/** 监听表格排序 */
function handleSortChange({ column, prop, order }) {
  queryParams.value.sortField = prop
  queryParams.value.sortOrder = order
  getList()
}

/** 初始化 */
onMounted(() => {
  getList()
})
</script>

<style scoped>

</style>

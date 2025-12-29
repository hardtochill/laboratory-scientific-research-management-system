<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="关键词名称" prop="keywordName">
        <el-input v-model="queryParams.keywordName" placeholder="请输入关键词名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Plus" @click="handleAdd">新增关键词</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleBatchDelete">批量删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="keywordList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="关键词名称" align="center" prop="keywordName" v-if="columns[0].visible" :show-overflow-tooltip="true" />
      <el-table-column label="关键词描述" align="center" prop="description" v-if="columns[1].visible" :show-overflow-tooltip="true" />
      <el-table-column label="使用次数" align="center" prop="usageCount" v-if="columns[2].visible" width="120" />
      <el-table-column label="创建时间" align="center" prop="createTime" v-if="columns[3].visible" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-tooltip content="修改" placement="top">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="删除" placement="top">
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"></el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 添加或修改关键词对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form :model="form" :rules="rules" ref="keywordRef" label-width="100px">
        <el-form-item label="关键词名称" prop="keywordName">
          <el-input v-model="form.keywordName" placeholder="请输入关键词名称" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="关键词描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入关键词描述" maxlength="500" show-word-limit :rows="4" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="KeywordManagement">
import { listKeyword, addKeyword, updateKeyword, deleteKeywords } from "@/api/keyword/keyword"
import { parseTime } from "@/utils/ruoyi"
import { getCurrentInstance } from "vue"

const { proxy } = getCurrentInstance()

const keywordList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")

// 列显隐信息
const columns = ref([
  { key: 0, label: `关键词名称`, visible: true },
  { key: 1, label: `关键词描述`, visible: true },
  { key: 2, label: `使用次数`, visible: true },
  { key: 3, label: `创建时间`, visible: true }
])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    keywordName: undefined
  },
  form: {
    id: undefined,
    keywordName: undefined,
    description: undefined
  },
  rules: {
    keywordName: [{ required: true, message: "关键词名称不能为空", trigger: "blur" }]
  }
})

const { queryParams, form, rules } = toRefs(data)

/** 查询关键词列表 */
function getList() {
  loading.value = true
  listKeyword(queryParams.value).then(res => {
    loading.value = false
    keywordList.value = res.rows
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
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 选择条数  */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 新增按钮操作 */
function handleAdd() {
  reset()
  open.value = true
  title.value = "添加关键词"
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset()
  const keyword = keywordList.value.find(item => item.id === row.id)
  if (keyword) {
    form.value.id = keyword.id
    form.value.keywordName = keyword.keywordName
    form.value.description = keyword.description
  }
  open.value = true
  title.value = "修改关键词"
}

/** 删除按钮操作 */
function handleDelete(row) {
  proxy.$modal.confirm('是否确认删除关键词"' + row.keywordName + '"？').then(function () {
    return deleteKeywords([row.id])
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  }).catch(() => {})
}

/** 批量删除按钮操作 */
function handleBatchDelete() {
  proxy.$modal.confirm('是否确认删除选中的' + ids.value.length + '个关键词？').then(function () {
    return deleteKeywords(ids.value)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("批量删除成功")
  }).catch(() => {})
}

/** 表单重置 */
function reset() {
  form.value = {
    id: undefined,
    keywordName: undefined,
    description: undefined
  }
  proxy.resetForm("keywordRef")
}

/** 取消按钮 */
function cancel() {
  open.value = false
  reset()
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["keywordRef"].validate((valid) => {
    if (valid) {
      if (form.value.id != undefined) {
        updateKeyword(form.value).then(() => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addKeyword(form.value).then(() => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

/** 初始化 */
onMounted(() => {
  getList()
})
</script>

<style scoped>

</style>
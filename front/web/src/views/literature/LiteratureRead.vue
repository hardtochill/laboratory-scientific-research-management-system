<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="文献名称" prop="literatureId">
        <el-select 
        v-model="queryParams.literatureId" 
        filterable 
        remote 
        placeholder="输入并选择文献名称" 
        :remote-method="remoteSearchLiterature" 
        :loading="literatureLoading" 
        style="width: 240px" 
        clearable >
          <el-option 
          v-for="item in literatureOptions" 
          :key="item.id" 
          :label="item.title" 
          :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="关键词" prop="keywordIds">
        <el-select 
        v-model="queryParams.keywordIds" 
        multiple 
        filterable 
        remote 
        placeholder="请选择关键词" 
        :remote-method="remoteSearchKeyword" 
        :loading="keywordLoading" 
        style="width: 240px"
        clearable >
          <el-option v-for="item in keywordOptions" :key="item.id" :label="item.keywordName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="时间范围" prop="dateRange">
        <el-segmented class="time-range-segmented" v-model="selectedTimeRange" :options="timeRangeOptions" @change="handleTimeRangeChange" style="margin-right: 20px"/>
        <el-date-picker
          v-model="dateRange"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD HH:mm:ss"
          @change="handleDateChange"
          style="width: 400px;"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 表格数据展示 -->
    <el-table v-loading="loading" :data="readList" @sort-change="handleSortChange">
      <el-table-column type="index" width="50" align="center" />
      <el-table-column label="文献名称" align="center" prop="title" min-width="200" :show-overflow-tooltip="true">
        <template #default="scope">
          <span>{{ scope.row.title }}</span>
        </template>
      </el-table-column>
      <el-table-column label="关键词" align="center" min-width="200" :show-overflow-tooltip="true">
        <template #default="scope">
          <span>{{ scope.row.keywords }}</span>
        </template>
      </el-table-column>
      <el-table-column label="阅读次数" align="center" prop="readCount" width="120" sortable />
      <el-table-column label="最后阅读时间" align="center" prop="lastReadTime" min-width="180" sortable>
        <template #default="scope">
          <span>{{ parseTime(scope.row.lastReadTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" align="center" width="150" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" size="small" @click="handleDetail(scope.row)">查看文献</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="handleQuery" />
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { listLiteratureRead } from '@/api/read/read'
import { getSelectableLiteratures } from '@/api/literature/literature'
import { listKeyword } from '@/api/keyword/keyword'
import { parseTime } from '@/utils/ruoyi'
import pagination from '@/components/Pagination'
import { ElMessage } from 'element-plus'

// 路由
const router = useRouter()

// 表格数据
const readList = ref([])
const total = ref(0)
const loading = ref(false)

// 查询表单
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  literatureId: undefined,
  keywordIds: [],
  startTime: undefined,
  endTime: undefined
})

// 搜索条件
const showSearch = ref(true)

// 文献搜索
const literatureOptions = ref([])
const literatureLoading = ref(false)

// 关键词搜索
const keywordOptions = ref([])
const keywordLoading = ref(false)

// 时间范围
const dateRange = ref([])
const selectedTimeRange = ref('all')
const timeRangeOptions = ref([
  { label: '今天', value: 'today' },
  { label: '本周', value: 'week' },
  { label: '本月', value: 'month' },
  { label: '本季度', value: 'quarter' },
  { label: '本年', value: 'year' }
])

/** 初始化页面 */
onMounted(() => {
  getDefaultDateRange()
  getList()
})

function getDefaultDateRange() {
  const end = new Date()
  end.setHours(23, 59, 59, 999)
  const start = new Date()
  start.setTime(start.getTime() - 7 * 24 * 60 * 60 * 1000)
  const startStr = parseTime(start, '{y}-{m}-{d} {h}:{i}:{s}')
  const endStr = parseTime(end, '{y}-{m}-{d} {h}:{i}:{s}')
  dateRange.value = [startStr, endStr]
  queryParams.startTime = startStr
  queryParams.endTime = endStr
  selectedTimeRange.value = 'week'
}

/** 获取阅读记录列表 */
async function getList() {
  loading.value = true
  try {
    const res = await listLiteratureRead(queryParams)
    readList.value = res.rows
    total.value = res.total
  } catch (error) {
    ElMessage.error('获取阅读记录失败')
  } finally {
    loading.value = false
  }
}

/** 搜索文献 */
async function remoteSearchLiterature(query) {
  literatureLoading.value = true
  try {
    const res = await getSelectableLiteratures({ literatureTitle: query })
    literatureOptions.value = res.data || []
  } catch (error) {
    ElMessage.error('搜索文献失败')
  } finally {
    literatureLoading.value = false
  }
}

/** 搜索关键词 */
async function remoteSearchKeyword(query) {
  keywordLoading.value = true
  try {
    const res = await listKeyword({ keywordName: query })
    keywordOptions.value = res.rows
  } catch (error) {
    ElMessage.error('搜索关键词失败')
    keywordOptions.value = []
  } finally {
    keywordLoading.value = false
  }
}

/** 处理时间范围选择 */
function handleTimeRangeChange(val) {
  const end = new Date()
  end.setHours(23, 59, 59, 999)
  const start = new Date()

  switch (val) {
    case 'today':
      start.setHours(0, 0, 0, 0)
      break
    case 'week':
      start.setTime(start.getTime() - 7 * 24 * 60 * 60 * 1000)
      break
    case 'month':
      start.setTime(start.getTime() - 30 * 24 * 60 * 60 * 1000)
      break
    case 'quarter':
      start.setTime(start.getTime() - 90 * 24 * 60 * 60 * 1000)
      break
    case 'year':
      start.setTime(start.getTime() - 365 * 24 * 60 * 60 * 1000)
      break
  }

  const startStr = parseTime(start, '{y}-{m}-{d} {h}:{i}:{s}')
  const endStr = parseTime(end, '{y}-{m}-{d} {h}:{i}:{s}')
  dateRange.value = [startStr, endStr]
  queryParams.startTime = startStr
  queryParams.endTime = endStr
  handleQuery()
}

/** 处理日期范围变化 */
function handleDateChange(value) {
    selectedTimeRange.value = ''
  if (value && value.length === 2) {
    queryParams.startTime = value[0]
    queryParams.endTime = value[1]
  } else {
    queryParams.startTime = null
    queryParams.endTime = null
  }
  handleQuery()
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  // 重置表单
  queryParams.literatureId = undefined
  queryParams.keywordIds = []
  queryParams.startTime = undefined
  queryParams.endTime = undefined
  
  // 重置时间范围
  dateRange.value = []
  selectedTimeRange.value = ''
  
  // 重置选项
  literatureOptions.value = []
  keywordOptions.value = []
  
  // 重置页码
  queryParams.pageNum = 1
  getList()
}

/** 表格排序 */
function handleSortChange(column) {
  queryParams.sortBy = column.prop
  queryParams.isAsc = column.order === 'ascending'
  getList()
}

/** 查看文献详情 */
function handleDetail(row) {
  router.push(`/literature/detail/${row.literatureId}`)
}
</script>

<style scoped lang="scss">
.time-range-segmented {
  margin-right: 20px;
}
</style>
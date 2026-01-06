<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="时间范围" prop="dateRange">
        <el-date-picker
          v-model="dateRange"
          type="datetimerange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD HH:mm:ss"
          :disabled-date="disabledDate"
          :shortcuts="timeShortcuts"
          @change="handleDateChange"
          style="width: 400px"
        ></el-date-picker>
      </el-form-item>
      <el-form-item v-if="activeTab === 'student'" label="学生昵称" prop="searchKey">
        <el-input v-model="queryParams.searchKey" placeholder="请输入学生昵称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item v-if="activeTab === 'literature'" label="文献名称" prop="searchKey">
        <el-input v-model="queryParams.searchKey" placeholder="请输入文献名称" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="success" plain icon="Download" @click="handleExport">导出统计</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="handleQuery"></right-toolbar>
    </el-row>

    <el-tabs v-model="activeTab" @tab-change="handleTabChange">
      <el-tab-pane label="按学生统计" name="student">
        <el-table v-loading="loading" :data="studentList" @expand-change="handleStudentExpand" row-key="userId" :default-expand-all="false">
          <el-table-column type="expand">
            <template #default="{ row }">
              <div v-if="expandedStudentIds.includes(row.userId)" class="student-detail">
                <el-table :data="studentLiteratureMap[row.userId]" border size="small">
                  <el-table-column prop="title" label="文献名称" min-width="200" :show-overflow-tooltip="true" />
                  <el-table-column prop="keywords" label="关键词" width="200" :show-overflow-tooltip="true" />
                  <el-table-column prop="readCount" label="阅读次数" width="100" align="center" />
                  <el-table-column prop="lastReadTime" label="最后阅读时间" width="160" align="center">
                    <template #default="{ row: detail }">
                      <span>{{ parseTime(detail.lastReadTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="操作" width="80" align="center">
                    <template #default="{ row: detail }">
                      <el-button link type="primary" size="small" @click="goToLiteratureDetail(detail.literatureId)">查看详情</el-button>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="userNickName" label="学生昵称" width="150" align="center" />
          <el-table-column prop="literatureCount" label="阅读文献数量" width="150" align="center" sortable />
        </el-table>
        <pagination v-show="studentTotal > 0" :total="studentTotal" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getStudentList" />
      </el-tab-pane>

      <el-tab-pane label="按文献统计" name="literature">
        <el-table v-loading="loading" :data="literatureList" @expand-change="handleLiteratureExpand" row-key="literatureId" :default-expand-all="false">
          <el-table-column type="expand">
            <template #default="{ row }">
              <div v-if="expandedLiteratureIds.includes(row.literatureId)" class="literature-detail">
                <el-table :data="literatureStudentMap[row.literatureId]" border size="small">
                  <el-table-column prop="userNickName" label="学生昵称" width="150" align="center" />
                  <el-table-column prop="readCount" label="阅读次数" width="100" align="center" />
                  <el-table-column prop="lastReadTime" label="最后阅读时间" width="160" align="center">
                    <template #default="{ row: detail }">
                      <span>{{ parseTime(detail.lastReadTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="文献名称" min-width="200" :show-overflow-tooltip="true" />
          <el-table-column prop="keywords" label="关键词" width="200" :show-overflow-tooltip="true" />
          <el-table-column prop="studentCount" label="阅读学生数量" width="150" align="center" sortable />
        </el-table>
        <pagination v-show="literatureTotal > 0" :total="literatureTotal" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getLiteratureList" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup name="LiteratureStatistic">
import { listStudentStatistics, listLiteratureStatistics, getStudentReadingDetail, getLiteratureReadingDetail, exportStatistics } from "@/api/statistic/statistic"
import { parseTime } from "@/utils/ruoyi"
import { useRouter } from "vue-router"
import { ref, reactive, toRefs, onMounted } from "vue"
import { getCurrentInstance } from "vue"

const router = useRouter()
const { proxy } = getCurrentInstance()

const loading = ref(false)
const showSearch = ref(true)
const activeTab = ref('student')
const dateRange = ref([])
const studentList = ref([])
const literatureList = ref([])
const studentTotal = ref(0)
const literatureTotal = ref(0)
const expandedStudentIds = ref([])
const expandedLiteratureIds = ref([])
const studentLiteratureMap = ref({})
const literatureStudentMap = ref({})

const timeShortcuts = [
  { text: '今天', value: () => {
    const end = new Date()
    end.setHours(23, 59, 59, 999)
    const start = new Date()
    start.setHours(0, 0, 0, 0)
    return [start, end]
  }},
  { text: '最近一周', value: () => {
    const end = new Date()
    end.setHours(23, 59, 59, 999)
    const start = new Date()
    start.setTime(start.getTime() - 7 * 24 * 60 * 60 * 1000)
    return [start, end]
  }},
  { text: '最近一个月', value: () => {
    const end = new Date()
    end.setHours(23, 59, 59, 999)
    const start = new Date()
    start.setTime(start.getTime() - 30 * 24 * 60 * 60 * 1000)
    return [start, end]
  }},
  { text: '最近三个月', value: () => {
    const end = new Date()
    end.setHours(23, 59, 59, 999)
    const start = new Date()
    start.setTime(start.getTime() - 90 * 24 * 60 * 60 * 1000)
    return [start, end]
  }}
]

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    startTime: undefined,
    endTime: undefined,
    searchKey: undefined,
    sortField: undefined,
    sortOrder: undefined
  }
})

const { queryParams } = toRefs(data)

function getDefaultDateRange() {
  const end = new Date()
  end.setHours(23, 59, 59, 999)
  const start = new Date()
  start.setTime(start.getTime() - 30 * 24 * 60 * 60 * 1000)
  dateRange.value = [start, end]
  handleDateChange([start, end])
}

function handleDateChange(val) {
  if (val && val.length === 2) {
    queryParams.value.startTime = val[0]
    queryParams.value.endTime = val[1]
  } else {
    queryParams.value.startTime = undefined
    queryParams.value.endTime = undefined
  }
}

function disabledDate(time) {
  const now = new Date()
  const oneYearAgo = new Date()
  oneYearAgo.setFullYear(now.getFullYear() - 1)
  return time.getTime() > now.getTime() || time.getTime() < oneYearAgo.getTime()
}

function handleQuery() {
  queryParams.value.pageNum = 1
  if (activeTab.value === 'student') {
    getStudentList()
  } else {
    getLiteratureList()
  }
}

function resetQuery() {
  dateRange.value = []
  queryParams.value.searchKey = undefined
  proxy.resetForm("queryRef")
  getDefaultDateRange()
}

function handleTabChange(tab) {
  queryParams.value.pageNum = 1
  queryParams.value.searchKey = undefined
  expandedStudentIds.value = []
  expandedLiteratureIds.value = []
  studentLiteratureMap.value = {}
  literatureStudentMap.value = {}
  if (tab === 'student') {
    getStudentList()
  } else {
    getLiteratureList()
  }
}

async function getStudentList() {
  loading.value = true
  try {
    const params = {
      pageNum: queryParams.value.pageNum,
      pageSize: queryParams.value.pageSize,
      startTime: queryParams.value.startTime,
      endTime: queryParams.value.endTime,
      searchKey: queryParams.value.searchKey,
      sortField: queryParams.value.sortField,
      sortOrder: queryParams.value.sortOrder
    }
    const res = await listStudentStatistics(params)
    loading.value = false
    studentList.value = res.rows
    studentTotal.value = res.total
  } catch (error) {
    loading.value = false
    proxy.$modal.msgError("获取学生统计失败")
  }
}

async function getLiteratureList() {
  loading.value = true
  try {
    const params = {
      pageNum: queryParams.value.pageNum,
      pageSize: queryParams.value.pageSize,
      startTime: queryParams.value.startTime,
      endTime: queryParams.value.endTime,
      searchKey: queryParams.value.searchKey,
      sortField: queryParams.value.sortField,
      sortOrder: queryParams.value.sortOrder
    }
    const res = await listLiteratureStatistics(params)
    loading.value = false
    literatureList.value = res.rows
    literatureTotal.value = res.total
  } catch (error) {
    loading.value = false
    proxy.$modal.msgError("获取文献统计失败")
  }
}

async function handleStudentExpand(row, expanded) {
  const userId = row.userId
  if (expanded) {
    if (!studentLiteratureMap.value[userId]) {
      try {
        const res = await getStudentReadingDetail(userId, queryParams.value.startTime, queryParams.value.endTime)
        studentLiteratureMap.value[userId] = res.data
      } catch (error) {
        proxy.$modal.msgError("获取学生阅读详情失败")
      }
    }
    if (!expandedStudentIds.value.includes(userId)) {
      expandedStudentIds.value.push(userId)
    }
  } else {
    expandedStudentIds.value = expandedStudentIds.value.filter(id => id !== userId)
  }
}

async function handleLiteratureExpand(row, expanded) {
  const literatureId = row.literatureId
  if (expanded) {
    if (!literatureStudentMap.value[literatureId]) {
      try {
        const res = await getLiteratureReadingDetail(literatureId, queryParams.value.startTime, queryParams.value.endTime)
        literatureStudentMap.value[literatureId] = res.data
      } catch (error) {
        proxy.$modal.msgError("获取文献阅读详情失败")
      }
    }
    if (!expandedLiteratureIds.value.includes(literatureId)) {
      expandedLiteratureIds.value.push(literatureId)
    }
  } else {
    expandedLiteratureIds.value = expandedLiteratureIds.value.filter(id => id !== literatureId)
  }
}

function goToLiteratureDetail(literatureId) {
  router.push(`/literature/detail/${literatureId}`)
}

async function handleExport() {
  if (!queryParams.value.startTime || !queryParams.value.endTime) {
    proxy.$modal.msgWarning("请先选择时间范围")
    return
  }

  try {
    const res = await exportStatistics(
      queryParams.value.startTime,
      queryParams.value.endTime,
      queryParams.value.searchKey
    )
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
    const link = document.createElement('a')
    link.href = window.URL.createObjectURL(blob)
    const fileName = `文献阅读统计_${parseTime(queryParams.value.startTime, '{y}{m}{d}')}-${parseTime(queryParams.value.endTime, '{y}{m}{d}')}_${parseTime(new Date(), '{y}{m}{d}{h}{i}{s}')}.xlsx`
    link.download = fileName
    link.click()
    proxy.$modal.msgSuccess("导出成功")
  } catch (error) {
    proxy.$modal.msgError("导出失败")
  }
}

onMounted(() => {
  getDefaultDateRange()
})
</script>

<style scoped>
.student-detail,
.literature-detail {
  padding: 10px 20px;
}

:deep(.el-table .el-table__expand-icon) {
  font-size: 16px;
}

:deep(.el-table .el-table__expand-icon .el-icon) {
  font-size: 16px;
}
</style>

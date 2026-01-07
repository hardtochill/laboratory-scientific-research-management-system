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
      <el-form-item v-if="activeTab === 'student'" label="学生昵称" prop="userId">
        <el-select
          v-model="queryParams.userId"
          filterable
          remote
          reserve-keyword
          placeholder="请输入学生昵称"
          :remote-method="remoteSearchUser"
          :loading="userLoading"
          style="width: 240px"
          @change="handleSelectUser"
          @clear="handleClearUser"
          clearable
        >
          <el-option
            v-for="item in userOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item v-if="activeTab === 'literature'" label="文献名称" prop="literatureId">
        <el-select
          v-model="queryParams.literatureId"
          filterable
          remote
          reserve-keyword
          placeholder="请输入文献名称"
          :remote-method="remoteSearchLiterature"
          :loading="literatureLoading"
          style="width: 240px"
          @change="handleSelectLiterature"
          @clear="handleClearLiterature"
          clearable
        >
          <el-option
            v-for="item in literatureOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
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
        <el-table v-loading="loading" :data="studentList" @expand-change="handleStudentExpand" row-key="userId" :default-expand-all="false" :key="studentTableKey" fit>
          <el-table-column type="expand" width="50">
            <template #default="{ row }">
              <div v-if="expandedStudentIds.includes(row.userId)" class="student-detail">
                <el-table :data="studentLiteratureMap[row.userId]" border size="small">
                  <el-table-column prop="title" label="文献名称" min-width="180" :show-overflow-tooltip="true" align="center" />
                  <el-table-column prop="keywords" label="关键词" min-width="180" :show-overflow-tooltip="true" align="center" />
                  <el-table-column prop="readCount" label="阅读次数" min-width="150" align="center" sortable />
                  <el-table-column prop="lastReadTime" label="最后阅读时间" min-width="250" align="center">
                    <template #default="{ row: detail }">
                      <span>{{ parseTime(detail.lastReadTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="操作" width="150" align="center">
                    <template #default="{ row: detail }">
                      <el-button link type="primary" size="small" @click="goToLiteratureDetail(detail.literatureId)">查看文献</el-button>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="userNickName" label="学生昵称" min-width="150" align="center" />
          <el-table-column prop="literatureCount" label="阅读文献数量" width="150" align="center" sortable />
          <el-table-column prop="lastReadTime" label="最后阅读时间" min-width="150" align="center" />
        </el-table>
        <pagination v-show="studentTotal > 0" :total="studentTotal" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getStudentList" />
      </el-tab-pane>

      <el-tab-pane label="按文献统计" name="literature">
        <el-table v-loading="loading" :data="literatureList" @expand-change="handleLiteratureExpand" row-key="literatureId" :default-expand-all="false" :key="literatureTableKey" fit>
          <el-table-column type="expand" width="50">
            <template #default="{ row }">
              <div v-if="expandedLiteratureIds.includes(row.literatureId)" class="literature-detail">
                <el-table :data="literatureStudentMap[row.literatureId]" border size="small">
                  <el-table-column prop="userNickName" label="学生昵称" min-width="150" align="center" />
                  <el-table-column prop="readCount" label="阅读次数" min-width="150" align="center" sortable />
                  <el-table-column prop="lastReadTime" label="最后阅读时间" min-width="200" align="center">
                    <template #default="{ row: detail }">
                      <span>{{ parseTime(detail.lastReadTime, '{y}-{m}-{d} {h}:{i}:{s}') }}</span>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="title" label="文献名称" min-width="180" :show-overflow-tooltip="true" align="center" />
          <el-table-column prop="keywords" label="关键词" min-width="180" :show-overflow-tooltip="true" align="center" />
          <el-table-column prop="studentCount" label="阅读学生数量" width="180" align="center" sortable />
        </el-table>
        <pagination v-show="literatureTotal > 0" :total="literatureTotal" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getLiteratureList" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup name="LiteratureStatistic">
import { listStudentStatistics, listLiteratureStatistics, getStudentReadingDetail, getLiteratureReadingDetail, exportStatistics } from "@/api/statistic/statistic"
import { getSelectableUsers } from "@/api/system/user"
import { getSelectableLiteratures } from "@/api/literature/literature"
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
const userOptions = ref([])
const userLoading = ref(false)
const selectedUserNickName = ref('')
const literatureOptions = ref([])
const literatureLoading = ref(false)
const selectedLiteratureName = ref('')

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
    userId: undefined,
    literatureId: undefined,
  },
  studentTableKey: 0,
  literatureTableKey: 0,
})

const { queryParams, studentTableKey, literatureTableKey } = toRefs(data)

function getDefaultDateRange() {
  const end = new Date()
  end.setHours(23, 59, 59, 999)
  const start = new Date()
  start.setTime(start.getTime() - 7 * 24 * 60 * 60 * 1000)
  const startStr = parseTime(start, '{y}-{m}-{d} {h}:{i}:{s}')
  const endStr = parseTime(end, '{y}-{m}-{d} {h}:{i}:{s}')
  dateRange.value = [startStr, endStr]
  queryParams.value.startTime = startStr
  queryParams.value.endTime = endStr
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
  queryParams.value.userId = undefined
  queryParams.value.literatureId = undefined
  selectedUserNickName.value = ''
  selectedLiteratureName.value = ''
  proxy.resetForm("queryRef")
  getDefaultDateRange()
}

function handleTabChange(tab) {
  queryParams.value.pageNum = 1
  if (tab === 'student') {
    expandedLiteratureIds.value = []
    literatureStudentMap.value = {}
    literatureTableKey.value++
    getStudentList()
  } else {
    expandedStudentIds.value = []
    studentLiteratureMap.value = {}
    studentTableKey.value++
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
      userId: queryParams.value.userId,
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
      literatureId: queryParams.value.literatureId,
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
      queryParams.value.userId,
      queryParams.value.literatureId
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

async function remoteSearchUser(query) {
  userLoading.value = true
  try {
    const res = await getSelectableUsers({ nickName: query || '' })
    userOptions.value = res.data.map(user => ({
      value: user.userId,
      label: `${user.nickName}(${user.userName})`
    }))
  } catch (error) {
    proxy.$modal.msgError("搜索用户失败")
  } finally {
    userLoading.value = false
  }
}

function handleSelectUser(user) {
  const found = userOptions.value.find(item => item.value === user)
  if (found) {
    selectedUserNickName.value = found.label
  }
}

function handleClearUser() {
  queryParams.value.userId = undefined
  selectedUserNickName.value = ''
  userOptions.value = []
}

async function remoteSearchLiterature(query) {
  literatureLoading.value = true
  try {
    const res = await getSelectableLiteratures({ literatureTitle: query || '' })
    literatureOptions.value = res.data.map(lit => ({
      value: lit.id,
      label: lit.title
    }))
  } catch (error) {
    proxy.$modal.msgError("搜索文献失败")
  } finally {
    literatureLoading.value = false
  }
}

function handleSelectLiterature(literature) {
  const found = literatureOptions.value.find(item => item.value === literature)
  if (found) {
    selectedLiteratureName.value = found.label
  }
}

function handleClearLiterature() {
  queryParams.value.literatureId = undefined
  selectedLiteratureName.value = ''
  literatureOptions.value = []
}

onMounted(() => {
  getDefaultDateRange()
  getStudentList()
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

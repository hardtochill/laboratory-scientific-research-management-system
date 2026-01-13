<template>
  <div class="review-management">
    <!-- 标签页切换 -->
    <el-tabs v-model="activeTab" class="review-tabs">
      <!-- 我要审核 -->
      <el-tab-pane label="我要审核" name="toReview">
        <!-- 查询表单 -->
        <el-form :model="toReviewQueryParams" ref="toReviewQueryRef" :inline="true" label-width="80px" class="query-form">
          <el-form-item label="投稿计划" prop="planId">
            <el-select v-model="toReviewQueryParams.planId" placeholder="请选择投稿计划" filterable remote
              :remote-method="querySelectableSubmissionPlans" :loading="submissionPlanLoading"
              clearable style="width: 240px" @change="handleToReviewQuery">
              <el-option v-for="plan in selectableSubmissionPlans" :key="plan.id" :label="plan.name" :value="plan.id" />
            </el-select>
          </el-form-item>
          <el-form-item label="审核状态" prop="status">
            <el-select v-model="toReviewQueryParams.status" placeholder="请选择审核状态" clearable style="width: 240px">
              <el-option label="待审核" :value="1" />
            </el-select>
          </el-form-item>
          <el-form-item label="申请人" prop="reviewedUserId">
            <el-select v-model="toReviewQueryParams.reviewedUserId" placeholder="请选择申请人" filterable remote
              :remote-method="querySelectableApplicants" :loading="applicantLoading"
              clearable style="width: 240px" @change="handleToReviewQuery">
              <el-option v-for="user in selectableApplicants" :key="user.userId" :label="user.nickName" :value="user.userId" />
            </el-select>
          </el-form-item>
          <el-form-item label="发起时间" prop="dateRange">
            <el-segmented v-model="selectedTimeRange" :options="timeRangeOptions" @change="handleTimeRangeChange" style="margin-right: 20px;" />
            <el-date-picker
              v-model="dateRange"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="YYYY-MM-DD HH:mm:ss"
              @change="handleDateChange"
              style="width: 400px;"
              clearable
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="Search" @click="handleToReviewQuery">搜索</el-button>
            <el-button icon="Refresh" @click="resetToReviewQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-card>
          <template #header>
            <div class="card-header">
              <span>待审核任务列表</span>
            </div>
          </template>
          <!-- 待审核任务列表 -->
          <el-table :data="toReviewList" stripe style="width: 100%" v-loading="toReviewLoading" table-layout="fixed">
            <el-table-column prop="id" label="编号" width="80" align="center" />
            <el-table-column prop="planName" label="投稿计划" min-width="200" align="center" />
            <el-table-column prop="processName" label="投稿流程" min-width="150" align="center" />
            <el-table-column prop="reviewedUserNickName" label="申请人" width="150" align="center" />
            <el-table-column prop="reviewCreateTime" label="发起时间" sortable width="200" :formatter="formatDate" align="center" />
            <el-table-column prop="status" label="审核状态" width="150" align="center">
              <template #default="{ row }">
                <el-tag :type="getReviewStatusType(row.status)">
                  {{ getReviewStatusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" min-width="230" fixed="right" align="center">
              <template #default="{ row }">
                <el-button link type="primary" @click="showReviewDetail(row)" :icon="Document">详情</el-button>
                <el-button link type="success" @click="handleApproveReview(row)" :icon="Check" v-if="row.status === 1">通过</el-button>
                <el-button link type="danger" @click="handleRejectReview(row)" :icon="CircleClose" v-if="row.status === 1">拒绝</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页控件 -->
          <div class="pagination-container">
            <el-pagination v-model:current-page="toReviewQueryParams.pageNum" v-model:page-size="toReviewQueryParams.pageSize"
              :page-sizes="[5, 10, 20, 50]" layout="total, sizes, prev, pager, next, jumper" :total="toReviewTotal"
              @size-change="handleToReviewSizeChange" @current-change="handleToReviewCurrentChange" />
          </div>
        </el-card>
      </el-tab-pane>

      <!-- 审核记录 -->
      <el-tab-pane label="审核记录" name="reviewed">
        <!-- 查询表单 -->
        <el-form :model="reviewedQueryParams" ref="reviewedQueryRef" :inline="true" label-width="80px" class="query-form">
          <el-form-item label="投稿计划" prop="planId">
            <el-select v-model="reviewedQueryParams.planId" placeholder="请选择投稿计划" filterable remote
              :remote-method="querySelectableSubmissionPlans" :loading="submissionPlanLoading"
              clearable style="width: 240px" @change="handleReviewedQuery">
              <el-option v-for="plan in selectableSubmissionPlans" :key="plan.id" :label="plan.name" :value="plan.id" />
            </el-select>
          </el-form-item>
          <el-form-item label="审核状态" prop="status">
            <el-select v-model="reviewedQueryParams.status" placeholder="请选择审核状态" clearable style="width: 240px">
              <el-option label="全部" :value="0" />
              <el-option label="审核通过" :value="2" />
              <el-option label="审核不通过" :value="3" />
            </el-select>
          </el-form-item>
          <el-form-item label="申请人" prop="reviewedUserId">
            <el-select v-model="reviewedQueryParams.reviewedUserId" placeholder="请选择申请人" filterable remote
              :remote-method="querySelectableApplicants" :loading="applicantLoading"
              clearable style="width: 240px" @change="handleReviewedQuery">
              <el-option v-for="user in selectableApplicants" :key="user.userId" :label="user.nickName" :value="user.userId" />
            </el-select>
          </el-form-item>
          <el-form-item label="发起时间" prop="dateRange">
            <el-segmented v-model="selectedTimeRange" :options="timeRangeOptions" @change="handleTimeRangeChange" style="margin-right: 20px;" />
            <el-date-picker
              v-model="dateRange"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="YYYY-MM-DD HH:mm:ss"
              @change="handleDateChange"
              style="width: 400px;"
              clearable
            ></el-date-picker>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="Search" @click="handleReviewedQuery">搜索</el-button>
            <el-button icon="Refresh" @click="resetReviewedQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-card>
          <template #header>
            <div class="card-header">
              <span>审核历史记录</span>
            </div>
          </template>
          <!-- 审核历史记录列表 -->
          <el-table :data="reviewedList" stripe style="width: 100%" v-loading="reviewedLoading">
            <el-table-column prop="id" label="编号" width="80" align="center" />
            <el-table-column prop="planName" label="投稿计划" min-width="200" align="center" />
            <el-table-column prop="processName" label="投稿流程" min-width="150" align="center" />
            <el-table-column prop="reviewedUserNickName" label="申请人" width="120" align="center" />
            <el-table-column prop="reviewerUserNickName" label="审核人" width="120" align="center" />
            <el-table-column prop="reviewCreateTime" label="发起时间" width="160" :formatter="formatDate" align="center" />
            <el-table-column prop="reviewFinishTime" label="审核时间" width="160" :formatter="formatDate" align="center" />
            <el-table-column prop="status" label="审核状态" width="100" align="center">
              <template #default="{ row }">
                <el-tag :type="getReviewStatusType(row.status)">
                  {{ getReviewStatusText(row.status) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" fixed="right" align="center">
              <template #default="{ row }">
                <el-button link type="primary" @click="showReviewDetail(row)" :icon="Document">详情</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页控件 -->
          <div class="pagination-container">
            <el-pagination v-model:current-page="reviewedQueryParams.pageNum" v-model:page-size="reviewedQueryParams.pageSize"
              :page-sizes="[5, 10, 20, 50]" layout="total, sizes, prev, pager, next, jumper" :total="reviewedTotal"
              @size-change="handleReviewedSizeChange" @current-change="handleReviewedCurrentChange" />
          </div>
        </el-card>
      </el-tab-pane>
    </el-tabs>

    <!-- 审核详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="detailDialogTitle" width="600px" :before-close="handleDetailDialogClose">
      <div v-if="currentReview" class="review-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="审核ID">
            {{ currentReview.id }}
          </el-descriptions-item>
          <el-descriptions-item label="投稿计划">
            {{ currentReview.planName }}
          </el-descriptions-item>
          <el-descriptions-item label="投稿流程">
            {{ currentReview.processName }}
          </el-descriptions-item>
          <el-descriptions-item label="申请人">
            {{ currentReview.reviewedUserNickName }}
          </el-descriptions-item>
          <el-descriptions-item label="审核人">
            {{ currentReview.reviewerUserNickName }}
          </el-descriptions-item>
          <el-descriptions-item label="审核状态">
            <el-tag :type="getReviewStatusType(currentReview.status)">
              {{ getReviewStatusText(currentReview.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="审核申请备注">
            {{ currentReview.reviewedRemark || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="审核备注">
            {{ currentReview.reviewerRemark || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="发起时间">
            {{ parseTime(currentReview.reviewCreateTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="审核时间">
            {{ parseTime(currentReview.reviewFinishTime) || '-' }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- 关联文件列表 -->
        <div class="related-files" v-if="currentReviewFiles.length > 0">
          <h4>关联文件</h4>
          <el-table :data="currentReviewFiles" stripe style="width: 100%">
            <el-table-column prop="fileName" label="文件名" min-width="200" align="center" />
            <el-table-column prop="filePath" label="文件路径" width="300" align="center">
              <template #default="{ row }">
                {{ row.filePath || '-' }}
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="上传时间" width="160" :formatter="formatDate" align="center" />
          </el-table>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleDetailDialogClose">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 审核操作对话框 -->
    <el-dialog v-model="reviewDialogVisible" :title="reviewDialogTitle" width="400px" :before-close="handleReviewDialogClose">
      <el-form :model="reviewForm" ref="reviewFormRef" label-width="100px">
        <el-form-item label="审核备注" prop="reviewerRemark">
          <el-input v-model="reviewForm.reviewerRemark" type="textarea" placeholder="请输入审核备注（非必填）" :rows="4" maxlength="255" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleReviewDialogClose">取消</el-button>
          <el-button type="primary" @click="handleReviewConfirm">{{ reviewDialogTitle }}</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, toRefs, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listReviews, getReview, approveReview, rejectReview,getSelectableReviewedUsers } from '@/api/review/review'
import { listSubmissionPlansForSelect } from '@/api/submission/submissionPlan'
import { parseTime } from '@/utils/ruoyi'
import { Document, Check, CircleClose } from '@element-plus/icons-vue'

// 审核状态枚举
const REVIEW_STATUS = {
  ALL: 0,
  PENDING: 1,
  PASSED: 2,
  FAILED: 3
}

// 获取审核状态类型
const getReviewStatusType = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case REVIEW_STATUS.PENDING:
      return 'warning'
    case REVIEW_STATUS.PASSED:
      return 'success'
    case REVIEW_STATUS.FAILED:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取审核状态文本
const getReviewStatusText = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case REVIEW_STATUS.PENDING:
      return '待审核'
    case REVIEW_STATUS.PASSED:
      return '审核通过'
    case REVIEW_STATUS.FAILED:
      return '审核不通过'
    default:
      return '未知状态'
  }
}

// 标签页
const activeTab = ref('toReview')

// 投稿计划相关
const selectableSubmissionPlans = ref([])
const submissionPlanLoading = ref(false)

// 申请人相关
const selectableApplicants = ref([])
const applicantLoading = ref(false)

// 时间范围相关
const dateRange = ref([])
const timeRangeOptions = ref([
  { label: '今天', value: 'today' },
  { label: '本周', value: 'week' },
  { label: '本月', value: 'month' },
  { label: '本季度', value: 'quarter' },
  { label: '本年', value: 'year' }
])
const selectedTimeRange = ref('')

// 我要审核 - 数据和分页
const toReviewList = ref([])
const toReviewLoading = ref(true)
const toReviewData = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    planId: undefined,
    processName: undefined,
    reviewedUserId: undefined,
    reviewCreateTimeStart: undefined,
    reviewCreateTimeEnd: undefined,
    status: REVIEW_STATUS.PENDING
  },
  total: 0
})

const { queryParams: toReviewQueryParams, total: toReviewTotal } = toRefs(toReviewData)

// 审核记录 - 数据和分页
const reviewedList = ref([])
const reviewedLoading = ref(true)
const reviewedData = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    planId: undefined,
    processName: undefined,
    reviewedUserId: undefined,
    reviewCreateTimeStart: undefined,
    reviewCreateTimeEnd: undefined,
    status: REVIEW_STATUS.ALL
  },
  total: 0
})

const { queryParams: reviewedQueryParams, total: reviewedTotal } = toRefs(reviewedData)

// 查询可选投稿计划
const querySelectableSubmissionPlans = async (query) => {
  submissionPlanLoading.value = true
  try {
    const response = await listSubmissionPlansForSelect({ name: query })
    selectableSubmissionPlans.value = response.data || []
  } catch (error) {
    console.error('获取投稿计划列表失败:', error)
  } finally {
    submissionPlanLoading.value = false
  }
}

// 查询可选申请人
const querySelectableApplicants = async (query) => {
  applicantLoading.value = true
  try {
    const response = await getSelectableReviewedUsers({ nickName: query })
    selectableApplicants.value = response.data || []
  } catch (error) {
    console.error('获取申请人列表失败:', error)
  } finally {
    applicantLoading.value = false
  }
}

// 时间范围变化处理
const handleTimeRangeChange = () => {
  const now = new Date()
  let startDate = new Date()
  let endDate = new Date()
  
  switch (selectedTimeRange.value) {
    case 'today':
      // 今天
      startDate.setHours(0, 0, 0, 0)
      endDate.setHours(23, 59, 59, 999)
      break
    case 'week':
      // 本周（周一到周日）
      const dayOfWeek = now.getDay() || 7 // 将周日(0)转为7
      startDate.setDate(now.getDate() - dayOfWeek + 1)
      startDate.setHours(0, 0, 0, 0)
      endDate.setDate(now.getDate() + (7 - dayOfWeek))
      endDate.setHours(23, 59, 59, 999)
      break
    case 'month':
      // 本月
      startDate.setDate(1)
      startDate.setHours(0, 0, 0, 0)
      endDate.setMonth(now.getMonth() + 1)
      endDate.setDate(0)
      endDate.setHours(23, 59, 59, 999)
      break
    case 'quarter':
      // 本季度
      const quarter = Math.floor(now.getMonth() / 3)
      startDate.setMonth(quarter * 3)
      startDate.setDate(1)
      startDate.setHours(0, 0, 0, 0)
      endDate.setMonth((quarter + 1) * 3)
      endDate.setDate(0)
      endDate.setHours(23, 59, 59, 999)
      break
    case 'year':
      // 本年
      startDate.setMonth(0)
      startDate.setDate(1)
      startDate.setHours(0, 0, 0, 0)
      endDate.setMonth(11)
      endDate.setDate(31)
      endDate.setHours(23, 59, 59, 999)
      break
    default:
      return
  }
  
  // 格式化日期时间为本地时间字符串（YYYY-MM-DD HH:mm:ss）
  const formatDateTime = (date) => {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')
    const seconds = String(date.getSeconds()).padStart(2, '0')
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  }
  
  dateRange.value = [
    formatDateTime(startDate),
    formatDateTime(endDate)
  ]
  
  // 更新当前标签页的查询参数
  if (activeTab.value === 'toReview') {
    toReviewQueryParams.value.reviewCreateTimeStart = dateRange.value[0]
    toReviewQueryParams.value.reviewCreateTimeEnd = dateRange.value[1]
  } else {
    reviewedQueryParams.value.reviewCreateTimeStart = dateRange.value[0]
    reviewedQueryParams.value.reviewCreateTimeEnd = dateRange.value[1]
  }
}

// 日期选择变化处理
const handleDateChange = () => {
  selectedTimeRange.value = ''
  
  if (dateRange.value && dateRange.value.length === 2) {
    if (activeTab.value === 'toReview') {
      toReviewQueryParams.value.reviewCreateTimeStart = dateRange.value[0]
      toReviewQueryParams.value.reviewCreateTimeEnd = dateRange.value[1]
    } else {
      reviewedQueryParams.value.reviewCreateTimeStart = dateRange.value[0]
      reviewedQueryParams.value.reviewCreateTimeEnd = dateRange.value[1]
    }
  } else {
    if (activeTab.value === 'toReview') {
      toReviewQueryParams.value.reviewCreateTimeStart = undefined
      toReviewQueryParams.value.reviewCreateTimeEnd = undefined
    } else {
      reviewedQueryParams.value.reviewCreateTimeStart = undefined
      reviewedQueryParams.value.reviewCreateTimeEnd = undefined
    }
  }
}

// 详情对话框
const detailDialogVisible = ref(false)
const detailDialogTitle = ref('审核详情')
const currentReview = ref(null)
const currentReviewFiles = ref([])

// 审核操作对话框
const reviewDialogVisible = ref(false)
const reviewDialogTitle = ref('审核通过')
const currentReviewForAction = ref(null)
const reviewForm = reactive({
  reviewerRemark: ''
})

// 加载待审核列表
const loadToReviewList = async () => {
  toReviewLoading.value = true
  try {
    // 使用listReviews接口，添加status=1参数查询待审核记录
    const query = {
      ...toReviewQueryParams.value,
      status: REVIEW_STATUS.PENDING
    }
    const response = await listReviews(query)
    toReviewList.value = response.rows || []
    toReviewTotal.value = response.total || 0
  } catch (error) {
    ElMessage.error('加载待审核列表失败')
    console.error('加载待审核列表失败:', error)
  } finally {
    toReviewLoading.value = false
  }
}

// 加载审核记录列表
const loadReviewedList = async () => {
  reviewedLoading.value = true
  try {
    // 使用listReviews接口查询已审核记录
    const response = await listReviews(reviewedQueryParams.value)
    reviewedList.value = response.rows || []
    reviewedTotal.value = response.total || 0
  } catch (error) {
    ElMessage.error('加载审核记录列表失败')
    console.error('加载审核记录列表失败:', error)
  } finally {
    reviewedLoading.value = false
  }
}

// 查询待审核
const handleToReviewQuery = () => {
  toReviewQueryParams.value.pageNum = 1
  loadToReviewList()
}

// 重置待审核查询
const resetToReviewQuery = () => {
  toReviewQueryParams.value = {
    pageNum: 1,
    pageSize: 10,
    planId: undefined,
    processName: undefined,
    reviewedUserId: undefined,
    reviewCreateTimeStart: undefined,
    reviewCreateTimeEnd: undefined,
    status: REVIEW_STATUS.PENDING
  }
  // 重置时间范围相关状态
  dateRange.value = []
  selectedTimeRange.value = ''
  handleToReviewQuery()
}

// 分页变化
const handleToReviewSizeChange = (newSize) => {
  toReviewQueryParams.value.pageSize = newSize
  loadToReviewList()
}

const handleToReviewCurrentChange = (newNum) => {
  toReviewQueryParams.value.pageNum = newNum
  loadToReviewList()
}

// 查询审核记录
const handleReviewedQuery = () => {
  
  reviewedQueryParams.value.pageNum = 1
  loadReviewedList()
}

// 重置审核记录查询
const resetReviewedQuery = () => {
  reviewedQueryParams.value = {
    pageNum: 1,
    pageSize: 10,
    planId: undefined,
    processName: undefined,
    reviewedUserId: undefined,
    reviewCreateTimeStart: undefined,
    reviewCreateTimeEnd: undefined,
    status: REVIEW_STATUS.ALL
  }
  // 重置时间范围相关状态
  dateRange.value = []
  selectedTimeRange.value = ''
  handleReviewedQuery()
}

// 分页变化
const handleReviewedSizeChange = (newSize) => {
  reviewedQueryParams.value.pageSize = newSize
  loadReviewedList()
}

const handleReviewedCurrentChange = (newNum) => {
  reviewedQueryParams.value.pageNum = newNum
  loadReviewedList()
}

// 显示审核详情
const showReviewDetail = async (review) => {
  try {
    // 获取审核详情
    const response = await getReview(review.id)
    currentReview.value = response.data
    
    // 暂时不加载关联文件，因为API中没有提供相关接口
    currentReviewFiles.value = []
    
    detailDialogVisible.value = true
    detailDialogTitle.value = '审核详情'
  } catch (error) {
    ElMessage.error('加载审核详情失败')
    console.error('加载审核详情失败:', error)
  }
}

// 审核通过
const handleApproveReview = (review) => {
  currentReviewForAction.value = review
  reviewForm.reviewerRemark = ''
  reviewDialogVisible.value = true
  reviewDialogTitle.value = '审核通过'
}

// 审核拒绝
const handleRejectReview = (review) => {
  currentReviewForAction.value = review
  reviewForm.reviewerRemark = ''
  reviewDialogVisible.value = true
  reviewDialogTitle.value = '审核拒绝'
}

// 确认审核操作
const handleReviewConfirm = async () => {
  try {
    if (reviewDialogTitle.value === '审核通过') {
      await approveReview(currentReviewForAction.value.id, reviewForm.reviewerRemark)
      ElMessage.success('审核通过成功')
    } else {
      await rejectReview(currentReviewForAction.value.id, reviewForm.reviewerRemark)
      ElMessage.success('审核拒绝成功')
    }
    
    reviewDialogVisible.value = false
    
    // 根据当前激活的标签页重新加载数据
    if (activeTab.value === 'toReview') {
      loadToReviewList()
    } else {
      loadReviewedList()
    }
  } catch (error) {
    ElMessage.error('审核操作失败')
    console.error('审核操作失败:', error)
  }
}

// 关闭审核操作对话框
const handleReviewDialogClose = () => {
  reviewDialogVisible.value = false
  currentReviewForAction.value = null
  reviewForm.reviewerRemark = ''
}

// 关闭详情对话框
const handleDetailDialogClose = () => {
  detailDialogVisible.value = false
  currentReview.value = null
  currentReviewFiles.value = []
}

// 格式化日期
const formatDate = (row, column, cellValue) => {
  return parseTime(cellValue)
}

// 监听标签页变化
watch(activeTab, (newVal) => {
  // 重置时间范围相关状态
  dateRange.value = []
  selectedTimeRange.value = ''
  
  // 根据标签页设置默认时间范围
  if (newVal === 'toReview') {
    selectedTimeRange.value = 'today' // 我要审核默认今天
    handleTimeRangeChange()
    loadToReviewList()
  } else {
    selectedTimeRange.value = 'week' // 审核记录默认本周
    handleTimeRangeChange()
    loadReviewedList()
  }
})

// 页面加载时初始化数据
onMounted(async () => {
  // 设置默认时间范围
  selectedTimeRange.value = 'today' // 初始标签页是我要审核，默认今天
  handleTimeRangeChange()
  await loadToReviewList()
})
</script>

<style scoped>
.review-management {
  padding: 20px;
}

.review-tabs {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.review-detail {
  padding: 10px 0;
}

.related-files {
  margin-top: 20px;
}

.related-files h4 {
  margin-bottom: 10px;
  color: #303133;
  font-weight: 600;
}
</style>
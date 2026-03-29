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
            <el-table-column type="index" label="编号" width="80" align="center" />
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
            <el-table-column label="操作" min-width="280" fixed="right" align="center">
              <template #default="{ row }">
                <div class="action-buttons">
                  <el-button link type="primary" @click="showReviewDetail(row)" :icon="Document">详情</el-button>
                  <el-button link type="success" @click="handleApproveReview(row)" :icon="Check" v-if="row.status === 1">通过</el-button>
                  <el-button link type="danger" @click="handleRejectReview(row)" :icon="CircleClose" v-if="row.status === 1">拒绝</el-button>
                  <el-button link type="warning" @click="handleDeleteReview(row)" :icon="Delete">删除</el-button>
                </div>
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
            <el-select v-model="reviewedQueryParams.status" placeholder="请选择审核状态" clearable style="width: 240px" @change="handleReviewedQuery">
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
            <el-table-column type="index" label="编号" width="80" align="center" />
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
            <el-table-column label="操作" width="150" fixed="right" align="center">
              <template #default="{ row }">
                <div class="action-buttons">
                  <el-button link type="primary" @click="showReviewDetail(row)" :icon="Document">详情</el-button>
                  <el-button link type="warning" @click="handleDeleteReview(row)" :icon="Delete">删除</el-button>
                </div>
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
    <el-dialog v-model="detailDialogVisible" :title="detailDialogTitle" width="700px" :before-close="handleDetailDialogClose" class="review-detail-dialog">
      <div v-if="currentReview" class="review-detail-container">
        <el-scrollbar max-height="600px">
          <div class="review-detail">
            <el-descriptions :column="1" border label-width="120px">
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
            
            <!-- 投稿详情卡片 -->
            <div class="submission-detail-card">
              <div class="card-header">
                <span>投稿详情</span>
              </div>
              <div v-if="!submissionPlanDetail || !submissionProcessDetail" class="submission-detail-empty">
                <el-empty description="关联的投稿计划或投稿流程已被删除" />
              </div>
              <el-tabs v-else v-model="submissionDetailTab" class="submission-detail-tabs">
                <el-tab-pane label="投稿计划" name="plan" v-if="submissionPlanDetail">
                  <div class="submission-plan-detail">
                    <el-scrollbar>
                      <el-descriptions :column="1" border label-width="80px">
                        <el-descriptions-item label="投稿类型">
                          {{ getSubmissionTypeText(submissionPlanDetail.type) }}
                        </el-descriptions-item>
                        <el-descriptions-item label="计划名称">
                          {{ submissionPlanDetail.name }}
                        </el-descriptions-item>
                        <el-descriptions-item label="投稿期刊">
                          {{ submissionPlanDetail.journal || '-' }}
                        </el-descriptions-item>
                        <el-descriptions-item label="计划状态">
                          <el-tag :type="getPlanStatusType(submissionPlanDetail.status)">
                            {{ getPlanStatusText(submissionPlanDetail.status) }}
                          </el-tag>
                        </el-descriptions-item>
                        <el-descriptions-item label="创建人">
                          {{ submissionPlanDetail.createUserNickName || '-' }}
                        </el-descriptions-item>
                        <el-descriptions-item label="创建时间">
                          {{ parseTime(submissionPlanDetail.submissionCreateTime) }}
                        </el-descriptions-item>
                        <el-descriptions-item label="参与用户">
                          {{ submissionPlanDetail.participantUsers?.map(user => `${user.nickName}(${user.userName})`).join(', ') || '-' }}
                        </el-descriptions-item>
                        <el-descriptions-item label="备注">
                          {{ submissionPlanDetail.remark || '-' }}
                        </el-descriptions-item>
                      </el-descriptions>
                    </el-scrollbar>
                  </div>
                </el-tab-pane>
                <el-tab-pane label="投稿流程" name="process" v-if="submissionProcessDetail">
                  <div class="submission-process-detail">
                    <el-descriptions :column="1" border label-width="100px">
                      <el-descriptions-item label="流程名称">
                        {{ submissionProcessDetail.name }}
                      </el-descriptions-item>
                      <el-descriptions-item label="流程状态">
                        <el-tag :type="getProcessStatusType(submissionProcessDetail.status)">
                          {{ getProcessStatusText(submissionProcessDetail.status) }}
                        </el-tag>
                      </el-descriptions-item>
                      <el-descriptions-item label="审核人">
                        {{ submissionProcessDetail.reviewerUserNickName || '-' }}
                      </el-descriptions-item>
                      <el-descriptions-item label="创建时间">
                        {{ parseTime(submissionProcessDetail.processCreateTime) }}
                      </el-descriptions-item>
                      <el-descriptions-item label="备注">
                        {{ submissionProcessDetail.remark || '-' }}
                      </el-descriptions-item>
                      <el-descriptions-item label="关联文件">
                        <div class="related-files">
                          <div v-for="tag in PROCESS_TAG_CONFIG[submissionProcessDetail.name]" :key="tag"
                            class="tag-file-group">
                            <el-row>
                              <div class="tag-label">{{ FILE_TAG_TEXT[tag] }}：</div>
                              <div v-if="getFilesByTag(submissionProcessDetail, tag).length > 0" class="tag-file-list">
                                <el-button v-for="file in getFilesByTag(submissionProcessDetail, tag)" :key="file.id"
                                  type="text" class="file-link"
                                  @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                                  {{ file.fileName }}.{{ file.fileType }}
                                </el-button>
                              </div>
                              <span v-else class="no-files">-</span>
                            </el-row>
                          </div>
                        </div>
                      </el-descriptions-item>
                    </el-descriptions>
                  </div>
                </el-tab-pane>
              </el-tabs>
            </div>
          </div>
        </el-scrollbar>
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
import { ref, onMounted, reactive, toRefs, watch, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listReviews, getReview, approveReview, rejectReview, getSelectableReviewedUsers, deleteReview } from '@/api/review/review'
import { listSubmissionPlansForSelect, getSubmissionPlan } from '@/api/submission/submissionPlan'
import { getSubmissionProcessDetail } from '@/api/submission/submissionProcess'
import { downloadSubmissionProcessFile } from '@/api/submission/submissionProcessFile'
import { parseTime } from '@/utils/ruoyi'
import { Document, Check, CircleClose, Delete } from '@element-plus/icons-vue'

// 审核状态枚举
const REVIEW_STATUS = {
  ALL: 0,
  PENDING: 1,
  PASSED: 2,
  FAILED: 3
}

// 投稿计划状态枚举
const PLAN_STATUS = {
  WAITING_REVIEW: 1,
  UNDER_REVIEW: 2,
  PUBLISHED_SUCCESS: 3,
  PUBLISHED_FAILED: 4
}

// 投稿类型枚举
const SUBMISSION_TYPE = {
  JOURNAL_PAPER: 1,
  CONFERENCE_PAPER: 2,
  INVENTION_PATENT: 3,
  UTILITY_MODEL_PATENT: 4,
  SOFTWARE_COPYRIGHT: 5
}

// 投稿流程状态枚举
const PROCESS_STATUS = {
  WAITING_SUBMIT_REVIEW: 1,
  REVIEWING: 2,
  REVIEW_PASSED: 3,
  REVIEW_FAILED: 4
}

// 投稿流程文件标签枚举
const FILE_TAG = {
  JOURNAL_SUBMISSION: 1, // 提交给期刊的文件
  RAW_DATA_AND_PROGRAM: 2, // 原始数据与程序
  REVIEW_COMMENTS: 3, // 审稿意见
  SUPPLEMENTARY_DATA: 4, // 补充数据
  FINAL_DRAFT: 5 // 最终稿
}

// 流程名称对应的文件标签配置
const PROCESS_TAG_CONFIG = {
  '一审': [FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.RAW_DATA_AND_PROGRAM],
  '二审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '三审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '四审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '五审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '六审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '校稿': [FILE_TAG.FINAL_DRAFT]
}

// 文件标签文本映射
const FILE_TAG_TEXT = {
  [FILE_TAG.JOURNAL_SUBMISSION]: '提交给期刊的文件',
  [FILE_TAG.RAW_DATA_AND_PROGRAM]: '原始数据与程序',
  [FILE_TAG.REVIEW_COMMENTS]: '审稿意见',
  [FILE_TAG.SUPPLEMENTARY_DATA]: '补充数据',
  [FILE_TAG.FINAL_DRAFT]: '最终稿'
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

// 获取投稿计划状态类型
const getPlanStatusType = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PLAN_STATUS.WAITING_REVIEW:
      return 'info'
    case PLAN_STATUS.UNDER_REVIEW:
      return 'warning'
    case PLAN_STATUS.PUBLISHED_SUCCESS:
      return 'success'
    case PLAN_STATUS.PUBLISHED_FAILED:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取投稿计划状态文本
const getPlanStatusText = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PLAN_STATUS.WAITING_REVIEW:
      return '待审核'
    case PLAN_STATUS.UNDER_REVIEW:
      return '审核中'
    case PLAN_STATUS.PUBLISHED_SUCCESS:
      return '发表成功'
    case PLAN_STATUS.PUBLISHED_FAILED:
      return '发表失败'
    default:
      return '未知状态'
  }
}

// 获取投稿类型文本
const getSubmissionTypeText = (type) => {
  const numType = parseInt(type)
  switch (numType) {
    case SUBMISSION_TYPE.JOURNAL_PAPER:
      return '期刊论文'
    case SUBMISSION_TYPE.CONFERENCE_PAPER:
      return '会议论文'
    case SUBMISSION_TYPE.INVENTION_PATENT:
      return '发明专利'
    case SUBMISSION_TYPE.UTILITY_MODEL_PATENT:
      return '实用新型专利'
    case SUBMISSION_TYPE.SOFTWARE_COPYRIGHT:
      return '软件著作权'
    default:
      return '未知类型'
  }
}

// 获取投稿流程状态类型
const getProcessStatusType = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PROCESS_STATUS.WAITING_SUBMIT_REVIEW:
      return 'info'
    case PROCESS_STATUS.REVIEWING:
      return 'warning'
    case PROCESS_STATUS.REVIEW_PASSED:
      return 'success'
    case PROCESS_STATUS.REVIEW_FAILED:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取投稿流程状态文本
const getProcessStatusText = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PROCESS_STATUS.WAITING_SUBMIT_REVIEW:
      return '待审核'
    case PROCESS_STATUS.REVIEWING:
      return '审核中'
    case PROCESS_STATUS.REVIEW_PASSED:
      return '审核通过'
    case PROCESS_STATUS.REVIEW_FAILED:
      return '审核不通过'
    default:
      return '未知状态'
  }
}

// 根据tag获取文件列表
const getFilesByTag = (process, tag) => {
  // 优先从后端返回的分类文件列表中获取
  if (process.journalSubmissionFiles && tag === FILE_TAG.JOURNAL_SUBMISSION) {
    return process.journalSubmissionFiles
  } else if (process.rawDataAndProgramFiles && tag === FILE_TAG.RAW_DATA_AND_PROGRAM) {
    return process.rawDataAndProgramFiles
  } else if (process.reviewCommentsFiles && tag === FILE_TAG.REVIEW_COMMENTS) {
    return process.reviewCommentsFiles
  } else if (process.supplementaryDataFiles && tag === FILE_TAG.SUPPLEMENTARY_DATA) {
    return process.supplementaryDataFiles
  } else if (process.finalDraftFiles && tag === FILE_TAG.FINAL_DRAFT) {
    return process.finalDraftFiles
  }
  // 兼容旧的files数组
  return process.files?.filter(file => file.tag === tag) || []
}

// 下载投稿流程文件
const downloadFile = async (fileId, fileName) => {
  try {
    // 显示正在后台下载的提示
    ElMessage.info('正在后台下载文件，请稍候...')
    
    const response = await downloadSubmissionProcessFile(fileId)
    // 创建下载链接并触发下载
    const blob = new Blob([response])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = fileName
    document.body.appendChild(link)
    link.click()
    // 清理
    window.URL.revokeObjectURL(url)
    document.body.removeChild(link)
    ElMessage.success('文件下载成功')
  } catch (error) {
    ElMessage.error('文件下载失败')
    console.error('文件下载失败:', error)
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
    handleToReviewQuery()
  } else {
    reviewedQueryParams.value.reviewCreateTimeStart = dateRange.value[0]
    reviewedQueryParams.value.reviewCreateTimeEnd = dateRange.value[1]
    handleReviewedQuery()
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
  if (activeTab.value === 'toReview') {
    handleToReviewQuery()
  } else {
    handleReviewedQuery()
  }
}

// 详情对话框
const detailDialogVisible = ref(false)
const detailDialogTitle = ref('审核详情')
const currentReview = ref(null)

// 投稿详情相关
const submissionDetailTab = ref('plan')
const submissionPlanDetail = ref(null)
const submissionProcessDetail = ref(null)

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
  reviewedQueryParams.value.status = reviewedQueryParams.value.status || REVIEW_STATUS.ALL
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
    
    // 重置投稿详情标签页
    submissionDetailTab.value = 'plan'
    submissionPlanDetail.value = null
    submissionProcessDetail.value = null
    
    // 获取投稿计划详情
    if (currentReview.value.planId) {
      try {
        const planResponse = await getSubmissionPlan(currentReview.value.planId)
        submissionPlanDetail.value = planResponse.data || null
      } catch (error) {
        console.error('获取投稿计划详情失败:', error)
        submissionPlanDetail.value = null
      }
    }
    
    // 获取投稿流程详情
    if (currentReview.value.processId) {
      try {
        const processResponse = await getSubmissionProcessDetail(currentReview.value.processId)
        submissionProcessDetail.value = processResponse.data || null
      } catch (error) {
        console.error('获取投稿流程详情失败:', error)
        submissionProcessDetail.value = null
      }
    }
    
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

// 删除审核
const handleDeleteReview = async (review) => {
  try {
    // 检查投稿计划是否被删除
    let planDeleted = false
    if (review.planId) {
      try {
        const planResponse = await getSubmissionPlan(review.planId)
        if (!planResponse.data) {
          planDeleted = true
        }
      } catch (error) {
        planDeleted = true
      }
    }
    
    // 检查投稿流程是否被删除
    let processDeleted = false
    if (review.processId) {
      try {
        const processResponse = await getSubmissionProcessDetail(review.processId)
        if (!processResponse.data) {
          processDeleted = true
        }
      } catch (error) {
        processDeleted = true
      }
    }
    
    // 只有当投稿计划或投稿流程被删除时，才允许删除审核
    if (planDeleted || processDeleted) {
      await ElMessageBox.confirm(
        '确定要删除该审核记录吗？删除后将无法恢复。',
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      )
      
      await deleteReview(review.id)
      ElMessage.success('删除成功')
      
      // 根据当前激活的标签页重新加载数据
      if (activeTab.value === 'toReview') {
        loadToReviewList()
      } else {
        loadReviewedList()
      }
    } else {
      ElMessage.warning('只有当审核关联的投稿计划或投稿流程被删除时，才能删除该审核记录')
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除失败:', error)
    }
  }
}

// 关闭详情对话框
const handleDetailDialogClose = () => {
  detailDialogVisible.value = false
  currentReview.value = null
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

.review-detail-container {
  max-height: 600px;
}

.submission-detail-card {
  margin-top: 20px;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  overflow: hidden;
}

.submission-detail-card .card-header {
  padding: 12px 20px;
  background-color: #f5f7fa;
  border-bottom: 1px solid #ebeef5;
  font-weight: 600;
  color: #303133;
}

.review-detail-dialog .el-dialog__body {
  padding: 20px;
}

.review-detail-container {
  width: 100%;
}

.review-detail {
  width: 100%;
}

.review-detail .el-descriptions {
  width: 100%;
  overflow-x: auto;
}

.review-detail .el-descriptions__label {
  white-space: nowrap;
  min-width: 70px;
}

.submission-detail-card {
  margin-top: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  overflow: hidden;
}

.card-header {
  background-color: #f5f7fa;
  padding: 12px 20px;
  border-bottom: 1px solid #e4e7ed;
  font-weight: 500;
  font-size: 14px;
}

.submission-detail-tabs {
  padding: 20px;
}

.submission-plan-detail, .submission-process-detail {
  padding: 10px 0;
  width: 100%;
}

.submission-plan-detail .el-scrollbar, .submission-process-detail .el-scrollbar {
  width: 100%;
  overflow-x: auto;
}

.submission-plan-detail .el-scrollbar__wrap, .submission-process-detail .el-scrollbar__wrap {
  overflow-x: auto;
  overflow-y: hidden;
  width: 100%;
}

.submission-plan-detail .el-descriptions, .submission-process-detail .el-descriptions {
  width: 100%;
}

.submission-plan-detail .el-descriptions__label, .submission-process-detail .el-descriptions__label {
  white-space: nowrap;
  min-width: 60px;
}

.submission-detail-empty {
  padding: 40px 20px;
  text-align: center;
}

.loading-text {
  text-align: center;
  padding: 40px 0;
  color: #909399;
}

.related-files {
  margin-top: 20px;
}

.tag-file-group {
  margin-bottom: 16px;
}

.tag-file-group .el-row {
  display: block;
}

.tag-label {
  font-size: 15px;
  color: #606266;
  margin-bottom: 8px;
  font-weight: 500;
}

.tag-file-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding-left: 0;
}

.file-link {
  word-break: break-all;
  white-space: normal;
  text-align: left;
  max-width: 100%;
  display: block;
  padding: 2px 0;
  margin: 0;
  font-size: 14px;
  height: auto;
  line-height: 1.5;
}

/* 覆盖 Element Plus el-button 的默认样式，防止长文件名重叠 */
.file-link:deep(.el-button) {
  display: block;
  width: 100%;
  height: auto;
  line-height: 1.5;
  padding: 2px 0;
  margin: 0;
  white-space: normal;
  word-break: break-all;
  text-align: left;
}

.file-link:deep(.el-button > span) {
  white-space: normal;
  word-break: break-all;
}

.no-files {
  text-align: center;
  color: #909399;
  font-style: italic;
}

.action-buttons {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.action-buttons .el-button {
  margin: 0;
}
</style>
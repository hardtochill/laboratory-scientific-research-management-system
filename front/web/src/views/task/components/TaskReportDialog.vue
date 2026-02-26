<template>
  <el-dialog v-model="dialogVisible" title="任务汇报" width="700px" :before-close="handleClose">
    <div class="report-dialog-content">
      <!-- 任务信息 -->
      <div class="task-info-section">
        <h4 class="section-title">任务信息</h4>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="任务名称">{{ task?.taskName }}</el-descriptions-item>
          <el-descriptions-item label="任务状态">
            <el-tag :type="getStatusType(task?.taskStatus)">
              {{ getStatusText(task?.taskStatus) }}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 查询条件 -->
      <div class="report-query-section">
        <div class="query-row">
          <span class="query-label">时间范围：</span>
          <el-date-picker v-model="reportQuery.dateRange" type="daterange" range-separator="至"
            start-placeholder="开始日期" end-placeholder="结束日期" value-format="YYYY-MM-DD HH:mm:ss"
            :default-time="['00:00:00', '23:59:59']" />
          <el-button type="primary" @click="loadTaskReports" style="margin-left: 10px;">查询</el-button>
        </div>
        <div class="quick-query-row">
          <span class="quick-query-label">快捷查询：</span>
          <el-segmented v-model="selectedDateRange" :options="dateSegmentOptions"
            @change="handleDateSegmentChange" size="small" />
        </div>
      </div>

      <!-- 添加汇报按钮 -->
      <div class="add-report-section">
        <el-button type="primary" @click="showAddReportInput" :icon="Plus">添加汇报</el-button>
      </div>

      <!-- 添加汇报输入框 -->
      <div v-if="showAddReportForm" class="add-report-form">
        <el-input v-model="newReportContent" type="textarea" :rows="4" placeholder="请输入汇报内容..." maxlength="500"
          show-word-limit />
        <div class="add-report-actions">
          <el-button @click="cancelAddReport">取消</el-button>
          <el-button type="primary" @click="submitReport" :loading="submittingReport">提交</el-button>
        </div>
      </div>

      <!-- 汇报记录时间线 -->
      <div class="report-timeline-section">
        <h4 class="section-title">汇报记录</h4>
        <div v-if="reportLoading" class="report-loading">
          <el-skeleton :rows="3" animated />
        </div>
        <div v-else-if="reportList.length === 0" class="no-reports">
          <el-empty description="暂无汇报记录" />
        </div>
        <div v-else class="report-timeline-container">
          <el-timeline class="report-timeline">
            <el-timeline-item v-for="report in reportList" :key="report.id" :timestamp="report.reportTime"
              placement="top" type="primary">
              <el-card class="report-card" shadow="hover">
                <div class="report-header">
                  <span class="report-user">{{ report.userNickName }}</span>
                  <el-button link type="danger" size="small" :icon="Delete"
                    @click="handleDeleteReport(report)">删除</el-button>
                </div>
                <div class="report-content-wrapper">
                  <p class="report-content" :class="{ 'expanded': report.expanded }"
                    @click="toggleReportExpand(report)">
                    {{ report.expanded ? report.reportContent : truncateContent(report.reportContent) }}
                  </p>
                  <el-link v-if="report.reportContent && report.reportContent.length > 30" type="primary"
                    :underline="false" @click="toggleReportExpand(report)" class="expand-link">
                    {{ report.expanded ? '收起' : '展开' }}
                  </el-link>
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </div>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">关闭</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, watch, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete } from '@element-plus/icons-vue'
import { getTaskReportList, addTaskReport, deleteTaskReport } from '@/api/task/taskReport'
import { parseTime } from '@/utils/ruoyi'

const props = defineProps({
  modelValue: {
    type: Boolean,
    default: false
  },
  task: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['update:modelValue', 'submit-success'])

// 对话框显示状态
const dialogVisible = ref(props.modelValue)

// 监听props变化
watch(() => props.modelValue, (val) => {
  dialogVisible.value = val
  if (val && props.task) {
    // 默认选中"最近4天"
    selectedDateRange.value = 'last4days'
    handleDateSegmentChange('last4days')
  }
})

watch(() => dialogVisible.value, (val) => {
  emit('update:modelValue', val)
})

// 任务状态映射
const TASK_STATUS = {
  PENDING: 1,
  PROCESSING: 2,
  FINISHED: 3,
  SKIPPED: 4
}

// 获取状态类型
const getStatusType = (status) => {
  const typeMap = {
    [TASK_STATUS.PENDING]: 'info',
    [TASK_STATUS.PROCESSING]: 'warning',
    [TASK_STATUS.FINISHED]: 'success',
    [TASK_STATUS.SKIPPED]: 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status) => {
  const textMap = {
    [TASK_STATUS.PENDING]: '未开始',
    [TASK_STATUS.PROCESSING]: '进行中',
    [TASK_STATUS.FINISHED]: '已完成',
    [TASK_STATUS.SKIPPED]: '已跳过'
  }
  return textMap[status] || '未知'
}

// 汇报相关数据
const reportLoading = ref(false)
const reportList = ref([])
const showAddReportForm = ref(false)
const newReportContent = ref('')
const submittingReport = ref(false)
const reportQuery = ref({
  dateRange: []
})

// 日期分段选项
const dateSegmentOptions = [
  { label: '今天', value: 'today' },
  { label: '最近4天', value: 'last4days' },
  { label: '最近1月', value: 'last1month' },
  { label: '最近1年', value: 'last1year' },
  { label: '全部', value: 'all' }
]
const selectedDateRange = ref('last4days')

// 格式化日期时间
const formatDateTime = (date) => {
  if (!date) return ''
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

// 处理日期分段选择变化
const handleDateSegmentChange = (value) => {
  const end = new Date()
  const start = new Date()

  switch (value) {
    case 'today':
      start.setHours(0, 0, 0, 0)
      end.setHours(23, 59, 59, 999)
      reportQuery.value.dateRange = [
        formatDateTime(start),
        formatDateTime(end)
      ]
      break
    case 'last4days':
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 4)
      reportQuery.value.dateRange = [
        formatDateTime(start),
        formatDateTime(end)
      ]
      break
    case 'last1month':
      start.setMonth(start.getMonth() - 1)
      reportQuery.value.dateRange = [
        formatDateTime(start),
        formatDateTime(end)
      ]
      break
    case 'last1year':
      start.setFullYear(start.getFullYear() - 1)
      reportQuery.value.dateRange = [
        formatDateTime(start),
        formatDateTime(end)
      ]
      break
    case 'all':
      reportQuery.value.dateRange = []
      break
    default:
      reportQuery.value.dateRange = []
  }
  loadTaskReports()
}

// 加载任务汇报列表
const loadTaskReports = async () => {
  if (!props.task) return

  reportLoading.value = true
  reportList.value = []

  try {
    const params = {}
    if (reportQuery.value.dateRange && reportQuery.value.dateRange.length === 2) {
      if (reportQuery.value.dateRange[0]) {
        params.startTime = reportQuery.value.dateRange[0]
      }
      if (reportQuery.value.dateRange[1]) {
        params.endTime = reportQuery.value.dateRange[1]
      }
    }
    const response = await getTaskReportList(props.task.taskId, params)
    await nextTick()
    reportList.value = (response.rows || []).map(report => ({
      ...report,
      expanded: false
    }))
  } catch (error) {
    ElMessage.error('加载汇报记录失败')
    console.error('加载汇报记录失败:', error)
  } finally {
    reportLoading.value = false
  }
}

// 显示添加汇报输入框
const showAddReportInput = () => {
  showAddReportForm.value = true
  newReportContent.value = ''
}

// 取消添加汇报
const cancelAddReport = () => {
  showAddReportForm.value = false
  newReportContent.value = ''
}

// 提交汇报
const submitReport = async () => {
  if (!newReportContent.value.trim()) {
    ElMessage.warning('请输入汇报内容')
    return
  }

  if (!props.task) {
    ElMessage.error('任务信息不存在')
    return
  }

  submittingReport.value = true
  try {
    await addTaskReport({
      taskId: props.task.taskId,
      reportContent: newReportContent.value.trim()
    })
    ElMessage.success('汇报提交成功')
    showAddReportForm.value = false
    newReportContent.value = ''
    selectedDateRange.value = 'today'
    await nextTick()
    handleDateSegmentChange('today')
    emit('submit-success')
  } catch (error) {
    ElMessage.error('汇报提交失败')
    console.error('汇报提交失败:', error)
  } finally {
    submittingReport.value = false
  }
}

// 删除汇报
const handleDeleteReport = async (report) => {
  try {
    await ElMessageBox.confirm('确定要删除这条汇报记录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    await deleteTaskReport(report.id)
    ElMessage.success('删除成功')
    await loadTaskReports()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除汇报失败:', error)
    }
  }
}

// 切换汇报内容展开/收起
const toggleReportExpand = (report) => {
  report.expanded = !report.expanded
}

// 截断内容显示
const truncateContent = (content) => {
  if (!content) return ''
  if (content.length <= 30) return content
  return content.substring(0, 30) + '...'
}

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false
  showAddReportForm.value = false
  newReportContent.value = ''
  reportList.value = []
}
</script>

<style scoped>
.report-dialog-content {
  padding: 10px 0;
}

.task-info-section {
  margin-bottom: 20px;
}

.section-title {
  margin-bottom: 12px;
  color: #303133;
  font-weight: 600;
  font-size: 14px;
}

.report-query-section {
  margin-bottom: 20px;
  padding: 16px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.query-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.query-label {
  font-weight: 500;
  color: #606266;
  white-space: nowrap;
}

.quick-query-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px dashed #dcdfe6;
}

.quick-query-label {
  font-weight: 500;
  color: #606266;
  white-space: nowrap;
  font-size: 13px;
}

.add-report-section {
  margin-bottom: 20px;
}

.add-report-form {
  margin-bottom: 20px;
  padding: 16px;
  background-color: #f0f9ff;
  border-radius: 8px;
  border: 1px solid #d9ecff;
}

.add-report-actions {
  margin-top: 12px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.report-timeline-section {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  max-height: 500px;
}

.report-timeline-container {
  max-height: 450px;
  overflow-y: auto;
  padding-right: 10px;
}

.report-timeline-container::-webkit-scrollbar {
  width: 6px;
}

.report-timeline-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.report-timeline-container::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}

.report-timeline-container::-webkit-scrollbar-thumb:hover {
  background: #909399;
}

.report-loading {
  padding: 20px;
}

.no-reports {
  padding: 40px 0;
  text-align: center;
}

.report-timeline {
  padding: 10px 0;
}

.report-card {
  border-radius: 8px;
  transition: all 0.3s;
}

.report-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.report-header {
  margin-bottom: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.report-user {
  font-weight: 600;
  color: #409eff;
  font-size: 14px;
}

.report-content-wrapper {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.report-content {
  color: #606266;
  line-height: 1.6;
  margin: 0;
  cursor: pointer;
  transition: color 0.2s;
}

.report-content:hover {
  color: #409eff;
}

.report-content.expanded {
  white-space: pre-wrap;
  word-break: break-word;
}

.expand-link {
  font-size: 12px;
  align-self: flex-start;
}

:deep(.el-timeline-item__timestamp) {
  color: #909399;
  font-size: 13px;
}

:deep(.el-timeline-item__node) {
  background-color: #409eff;
}
</style>

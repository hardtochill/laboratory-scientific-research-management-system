<template>
  <div class="unreported-task-management">
    <!-- 教师角色查询表单 -->
    <el-form v-if="isHasTeacherRole" :model="queryParams" :inline="true" class="query-form">
      <el-form-item label="任务执行用户">
        <el-select v-model="queryParams.executorUserId" placeholder="请输入任务执行用户" clearable style="width: 240px"
          filterable remote :remote-method="querySelectableStudents" :loading="userLoading"
          @visible-change="handleSelectVisibleChange">
          <el-option v-for="item in selectableStudents" :key="item.userId"
            :label="`${item.nickName}(${item.userName})`" :value="item.userId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 学生角色：第一层Tabs - 任务类型 -->
    <el-tabs v-if="!isHasTeacherRole" v-model="activeTaskTypeTab" @tab-change="handleTaskTypeTabChange">
      <el-tab-pane label="我的待汇报任务" name="to-report">
        <template #label>
          <span class="tab-label">
            我的待汇报任务
          </span>
        </template>
        <!-- 第二层Tabs - 汇报状态 -->
        <el-tabs v-model="activeSubTabForToReport" @tab-change="handleSubTabChangeForToReport">
          <el-tab-pane label="已汇报任务" name="reported">
            <template #label>
              <span class="tab-label">
                已汇报任务
                <span class="task-count">{{ toReportedCount }}</span>
              </span>
            </template>
            <div v-if="toReportedTaskList.length === 0 && !loading" class="empty-tip">
              <el-empty description="暂无已汇报任务" />
            </div>
            <div v-else class="task-list">
              <div v-for="task in toReportedTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
                <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
                  :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
                  @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
              </div>
            </div>
          </el-tab-pane>

          <el-tab-pane label="超时未汇报任务" name="timeout">
            <template #label>
              <span class="tab-label warning">
                超时未汇报任务
                <span class="task-count warning">{{ toTimeoutCount }}</span>
              </span>
            </template>
            <div v-if="toTimeoutTaskList.length === 0 && !loading" class="empty-tip">
              <el-empty description="暂无超时未汇报任务" />
            </div>
            <div v-else class="task-list">
              <div v-for="task in toTimeoutTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
                <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
                  :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
                  @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-tab-pane>

      <el-tab-pane label="我的待接收汇报任务" name="to-receive">
        <template #label>
          <span class="tab-label">
            我的待接收汇报任务
          </span>
        </template>
        <!-- 第二层Tabs - 汇报状态 -->
        <el-tabs v-model="activeSubTabForToReceive" @tab-change="handleSubTabChangeForToReceive">
          <el-tab-pane label="已汇报任务" name="reported">
            <template #label>
              <span class="tab-label">
                已汇报任务
                <span class="task-count">{{ receiveReportedCount }}</span>
              </span>
            </template>
            <div v-if="receiveReportedTaskList.length === 0 && !loading" class="empty-tip">
              <el-empty description="暂无已汇报任务" />
            </div>
            <div v-else class="task-list">
              <div v-for="task in receiveReportedTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
                <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
                  :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
                  @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
              </div>
            </div>
          </el-tab-pane>

          <el-tab-pane label="超时未汇报任务" name="timeout">
            <template #label>
              <span class="tab-label warning">
                超时未汇报任务
                <span class="task-count warning">{{ receiveTimeoutCount }}</span>
              </span>
            </template>
            <div v-if="receiveTimeoutTaskList.length === 0 && !loading" class="empty-tip">
              <el-empty description="暂无超时未汇报任务" />
            </div>
            <div v-else class="task-list">
              <div v-for="task in receiveTimeoutTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
                <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
                  :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
                  @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </el-tab-pane>
    </el-tabs>

    <!-- 教师角色：保持原有Tabs -->
    <el-tabs v-if="isHasTeacherRole" v-model="activeTab" @tab-change="handleTabChange">
      <el-tab-pane label="已汇报任务" name="reported">
        <template #label>
          <span class="tab-label">
            已汇报任务
            <span class="task-count">{{ reportedCount }}</span>
          </span>
        </template>
        <div v-if="reportedTaskList.length === 0 && !loading" class="empty-tip">
          <el-empty description="暂无已汇报任务" />
        </div>
        <div v-else class="task-list">
          <div v-for="task in reportedTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
            <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
              :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
              @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
          </div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="超时未汇报任务" name="timeout">
        <template #label>
          <span class="tab-label warning">
            超时未汇报任务
            <span class="task-count warning">{{ timeoutCount }}</span>
          </span>
        </template>
        <div v-if="timeoutTaskList.length === 0 && !loading" class="empty-tip">
          <el-empty description="暂无超时未汇报任务" />
        </div>
        <div v-else class="task-list">
          <div v-for="task in timeoutTaskList" :key="task.taskId" class="task-item" @click="handleTaskClick(task)">
            <TaskItemCard :task="task" :is-hierarchical="hierarchicalTaskIds.has(task.taskId)"
              :parent-chain="taskParentChainMap.get(task.taskId) || []" @report="handleReportTask"
              @show-hierarchical="handleShowHierarchical" @show-single="handleShowSingle" />
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>

    <!-- 任务汇报对话框 -->
    <TaskReportDialog v-model="reportDialogVisible" :task="currentTaskForReport" @submit-success="handleReportSuccess" />
    
    <!-- 任务详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="任务详情" width="650px" :before-close="handleDetailClose">
      <div v-if="currentDetailTask" class="task-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="任务名称">
            {{ currentDetailTask.taskName }}
          </el-descriptions-item>
          <el-descriptions-item label="任务描述">
            {{ currentDetailTask.taskDescription || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="任务状态">
            <el-tag :type="getStatusType(currentDetailTask.taskStatus)">
              {{ getStatusText(currentDetailTask.taskStatus) }}
            </el-tag>
          </el-descriptions-item>

          <el-descriptions-item label="创建人">
            {{ currentDetailTask.createUserNickName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="执行人">
            {{ currentDetailTask.executorNickName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="定时汇报" label-width="135px">
            <el-tooltip content="开启时，任务执行人需要定时进行任务汇报" placement="top">
              <el-tag :type="currentDetailTask.reportFlag === 1 ? 'success' : 'info'">
                {{ currentDetailTask.reportFlag === 1 ? '开启' : '关闭' }}
              </el-tag>
            </el-tooltip>
          </el-descriptions-item>
          <el-descriptions-item label="定时汇报频率(天)" v-if="currentDetailTask.reportFlag === 1">
            {{ currentDetailTask.reportFrequency || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="参与用户">
            <span v-if="currentDetailTask.participantUsers && currentDetailTask.participantUsers.length > 0">
              {{currentDetailTask.participantUsers.map(user => `${user.nickName}(${user.userName})`).join(', ')}}
            </span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentDetailTask.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="预期完成时间">
            {{ parseTime(currentDetailTask.expectedFinishTime) || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="实际完成时间">
            {{ parseTime(currentDetailTask.actualFinishTime) || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            {{ currentDetailTask.taskRemark || '-' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleDetailClose">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { getUnreportedTaskList, getParentTasks } from '@/api/task/unreportedTask'
import { getSelectableStudents, getTaskDetail } from '@/api/task/task'
import { parseTime } from '@/utils/ruoyi'
import useUserStore from '@/store/modules/user'
import TaskItemCard from './components/TaskItemCard.vue'
import TaskReportDialog from './components/TaskReportDialog.vue'

// 用户store
const userStore = useUserStore()

// 角色权限
const isHasTeacherRole = ref(false)

// 教师角色Tabs
const activeTab = ref('reported')

// 学生角色：第一层Tabs - 任务类型
const activeTaskTypeTab = ref('to-report')

// 学生角色：第二层Tabs - 我的待汇报任务
const activeSubTabForToReport = ref('reported')

// 学生角色：第二层Tabs - 我的待接收汇报任务
const activeSubTabForToReceive = ref('reported')

// 查询参数
const queryParams = reactive({
  executorUserId: null
})

// 用户选择
const selectableStudents = ref([])
const userLoading = ref(false)

// 教师角色任务列表
const reportedTaskList = ref([])
const timeoutTaskList = ref([])
const reportedCount = ref(0)
const timeoutCount = ref(0)

// 学生角色：我的待汇报任务列表
const toReportedTaskList = ref([])
const toTimeoutTaskList = ref([])
const toReportedCount = ref(0)
const toTimeoutCount = ref(0)

// 学生角色：我的待接收汇报任务列表
const receiveReportedTaskList = ref([])
const receiveTimeoutTaskList = ref([])
const receiveReportedCount = ref(0)
const receiveTimeoutCount = ref(0)

const loading = ref(false)

// 层级展示相关
const hierarchicalTaskIds = ref(new Set())
const taskParentChainMap = ref(new Map())

// 汇报对话框
const reportDialogVisible = ref(false)
const currentTaskForReport = ref(null)

// 任务详情对话框
const detailDialogVisible = ref(false)
const currentDetailTask = ref(null)

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

// 查询学生列表
const querySelectableStudents = async (nickName) => {
  userLoading.value = true
  try {
    const response = await getSelectableStudents({ nickName })
    selectableStudents.value = response.data || []
  } catch (error) {
    console.error('查询学生列表失败:', error)
  } finally {
    userLoading.value = false
  }
}

// 加载教师角色所有任务
const loadTeacherTasks = async () => {
  loading.value = true
  try {
    const [reportedResponse, timeoutResponse] = await Promise.all([
      getUnreportedTaskList(1, queryParams.executorUserId),
      getUnreportedTaskList(2, queryParams.executorUserId)
    ])
    
    const reportedList = reportedResponse.data || []
    const timeoutList = timeoutResponse.data || []
    
    reportedCount.value = reportedList.length
    timeoutCount.value = timeoutList.length
    
    if (activeTab.value === 'reported') {
      reportedTaskList.value = reportedList
    } else {
      timeoutTaskList.value = timeoutList
    }
  } catch (error) {
    ElMessage.error('加载任务失败')
    console.error('加载任务失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载学生角色任务
const loadStudentTasks = async () => {
  loading.value = true
  try {
    const [toReportedResponse, toTimeoutResponse, receiveReportedResponse, receiveTimeoutResponse] = await Promise.all([
      getUnreportedTaskList(1, null, 1),
      getUnreportedTaskList(2, null, 1),
      getUnreportedTaskList(1, null, 2),
      getUnreportedTaskList(2, null, 2)
    ])
    
    // 我的待汇报任务
    const toReportedList = toReportedResponse.data || []
    const toTimeoutList = toTimeoutResponse.data || []
    toReportedCount.value = toReportedList.length
    toTimeoutCount.value = toTimeoutList.length
    
    if (activeSubTabForToReport.value === 'reported') {
      toReportedTaskList.value = toReportedList
    } else {
      toTimeoutTaskList.value = toTimeoutList
    }
    
    // 我的待接收汇报任务
    const receiveReportedList = receiveReportedResponse.data || []
    const receiveTimeoutList = receiveTimeoutResponse.data || []
    receiveReportedCount.value = receiveReportedList.length
    receiveTimeoutCount.value = receiveTimeoutList.length
    
    if (activeSubTabForToReceive.value === 'reported') {
      receiveReportedTaskList.value = receiveReportedList
    } else {
      receiveTimeoutTaskList.value = receiveTimeoutList
    }
  } catch (error) {
    ElMessage.error('加载任务失败')
    console.error('加载任务失败:', error)
  } finally {
    loading.value = false
  }
}

// 加载所有任务
const loadTasks = async () => {
  if (isHasTeacherRole.value) {
    await loadTeacherTasks()
  } else {
    await loadStudentTasks()
  }
}

// 教师角色Tab切换
const handleTabChange = () => {
  loadTasks()
}

// 学生角色：任务类型Tab切换
const handleTaskTypeTabChange = () => {
  loadTasks()
}

// 学生角色：我的待汇报任务子Tab切换
const handleSubTabChangeForToReport = () => {
  if (activeSubTabForToReport.value === 'reported') {
    getUnreportedTaskList(1, null, 1).then(response => {
      toReportedTaskList.value = response.data || []
    })
  } else {
    getUnreportedTaskList(2, null, 1).then(response => {
      toTimeoutTaskList.value = response.data || []
    })
  }
}

// 学生角色：我的待接收汇报任务子Tab切换
const handleSubTabChangeForToReceive = () => {
  if (activeSubTabForToReceive.value === 'reported') {
    getUnreportedTaskList(1, null, 2).then(response => {
      receiveReportedTaskList.value = response.data || []
    })
  } else {
    getUnreportedTaskList(2, null, 2).then(response => {
      receiveTimeoutTaskList.value = response.data || []
    })
  }
}

// 查询
const handleQuery = () => {
  loadTasks()
}

// 重置查询
const resetQuery = () => {
  queryParams.executorUserId = null
  loadTasks()
}

// 处理选择框显示变化
const handleSelectVisibleChange = (visible) => {
  if (visible) {
    // 当选择框打开时，如果没有输入内容，自动加载全部学生
    querySelectableStudents('')
  }
}

// 汇报任务
const handleReportTask = (task) => {
  currentTaskForReport.value = task
  reportDialogVisible.value = true
}

// 汇报成功回调
const handleReportSuccess = () => {
  loadTasks()
}

// 以层级方式展示
const handleShowHierarchical = async (task) => {
  try {
    const response = await getParentTasks(task.taskId)
    const parentChain = response.data || []
    taskParentChainMap.value.set(task.taskId, parentChain)
    hierarchicalTaskIds.value.add(task.taskId)
  } catch (error) {
    ElMessage.error('获取父任务列表失败')
    console.error('获取父任务列表失败:', error)
  }
}

// 以单任务方式展示
const handleShowSingle = (task) => {
  hierarchicalTaskIds.value.delete(task.taskId)
  taskParentChainMap.value.delete(task.taskId)
}

// 点击任务
const handleTaskClick = async (task) => {
  try {
    const response = await getTaskDetail(task.taskId)
    currentDetailTask.value = response.data
    detailDialogVisible.value = true
  } catch (error) {
    ElMessage.error('获取任务详情失败')
    console.error('获取任务详情失败:', error)
  }
}

// 关闭详情对话框
const handleDetailClose = () => {
  detailDialogVisible.value = false
  currentDetailTask.value = null
}

// 检查用户角色
const checkUserRole = () => {
  const roles = userStore.roles || []
  isHasTeacherRole.value = roles.includes('teacher') || roles.includes('admin')
}

// 页面加载
onMounted(() => {
  checkUserRole()
  loadTasks()
})
</script>

<style scoped>
.unreported-task-management {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 140px);
}

.query-form {
  margin-bottom: 20px;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.task-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-top: 20px;
}

.task-item {
  width: 100%;
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  transition: all 0.3s ease;
}

.task-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
  cursor: pointer;
}

.empty-tip {
  padding: 40px 0;
  text-align: center;
}

/* 标签样式 */
.tab-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 500;
}

.tab-label.warning {
  color: #e6a23c;
  font-weight: 600;
}

.task-count {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 24px;
  height: 24px;
  padding: 0 8px;
  border-radius: 12px;
  background-color: #409eff;
  color: #ffffff;
  font-size: 13px;
  font-weight: 700;
  line-height: 1;
}

.task-count.warning {
  background-color: #e6a23c;
}

/* 自定义标签样式 */
:deep(.el-tabs__header) {
  margin-bottom: 24px;
}

:deep(.el-tabs__content) {
  padding: 0;
}

:deep(.el-tabs__item) {
  font-size: 14px;
  padding: 0 20px;
  height: 40px;
  line-height: 40px;
}

:deep(.el-tabs__item.is-active) {
  color: #409eff;
  font-weight: 600;
}

:deep(.el-tabs__active-bar) {
  height: 2px;
  background-color: #409eff;
}

/* 双层tabs的第二层样式 */
:deep(.el-tabs .el-tabs) {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 0 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

/* 加载动画 */
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
}
</style>

<template>
  <div class="task-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>任务列表</span>
        </div>
      </template>

      <!-- 任务列表 -->
      <div class="task-list">
        <div
          v-for="task in parentTasks"
          :key="task.taskId"
          class="task-item"
        >
          <!-- 任务行 -->
          <div class="task-row" @click="showTaskDetail(task)">
            <!-- 展开/收起按钮 -->
            <el-button
              type="text"
              @click.stop="toggleSubTasks(task)"
              :icon="task.expanded ? 'el-icon-arrow-down' : 'el-icon-arrow-right'"
              v-if="task.hasSubTasks"
            ></el-button>
            <span v-else class="spacer"></span>

            <!-- 任务名称 -->
            <span class="task-name">{{ task.taskName }}</span>

            <!-- 任务状态 -->
            <el-tag
              :type="getStatusType(task.taskStatus)"
              size="small"
              class="task-status"
            >
              {{ getStatusText(task.taskStatus) }}
            </el-tag>

            <!-- 展开子任务按钮 -->
          <el-button
            type="primary"
            size="small"
            @click.stop="toggleSubTasks(task)"
            v-if="task.hasSubTasks"
          >
            {{ task.expanded ? '收起' : '展开' }}子任务
          </el-button>
        </div>

        <!-- 任务进度条 -->
        <div class="progress-container">
          <el-progress
            :percentage="getProgressPercentage(task)"
            :color="getProgressColor(task)"
            :status="getProgressStatus(task)"
            :stroke-width="8"
          ></el-progress>
        </div>

        <!-- 子任务列表（带动画效果） -->
          <transition name="expand">
            <div v-if="task.expanded" class="sub-tasks">
              <div class="loading" v-if="task.loading">
                <el-skeleton :rows="3" animated />
              </div>
              <div v-else>
                <TaskItem
                  v-for="subTask in task.subTasks"
                  :key="subTask.taskId"
                  :task="subTask"
                  @show-detail="showTaskDetail"
                />
              </div>
            </div>
          </transition>
        </div>
      </div>
    </el-card>

    <!-- 任务详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      title="任务详情"
      width="600px"
      :before-close="handleClose"
    >
      <div v-if="currentTask" class="task-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="任务名称">
            {{ currentTask.taskName }}
          </el-descriptions-item>
          <el-descriptions-item label="任务描述">
            {{ currentTask.taskDescription || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="任务状态">
            <el-tag :type="getStatusType(currentTask.taskStatus)">
              {{ getStatusText(currentTask.taskStatus) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="创建人">
            {{ currentTask.createNickName }}
          </el-descriptions-item>
          <el-descriptions-item label="执行人">
            {{ currentTask.executeNickName }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentTask.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="预期完成时间">
            {{ parseTime(currentTask.expectedFinishTime)|| '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="实际完成时间">
            {{ parseTime(currentTask.actualFinishTime)|| '-'}}
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            {{ currentTask.taskRemark || '-' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleClose">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getParentTasks, getSubTasks, getTaskDetail } from '@/api/task/task'
import TaskItem from './components/TaskItem.vue'
import { parseTime } from '@/utils/ruoyi'

// 任务状态枚举
const TASK_STATUS = {
  PENDING: 0,
  PROCESSING: 1,
  FINISHED: 2,
  SKIPPED: 3
}

// 任务状态类型映射
const getStatusType = (status) => {
  switch (status) {
    case TASK_STATUS.PENDING:
      return 'info'
    case TASK_STATUS.PROCESSING:
      return 'warning'
    case TASK_STATUS.FINISHED:
      return 'success'
    case TASK_STATUS.SKIPPED:
      return 'danger'
    default:
      return 'info'
  }
}

// 任务状态文本映射
const getStatusText = (status) => {
  switch (status) {
    case TASK_STATUS.PENDING:
      return '未开始'
    case TASK_STATUS.PROCESSING:
      return '进行中'
    case TASK_STATUS.FINISHED:
      return '已完成'
    case TASK_STATUS.SKIPPED:
      return '已跳过'
    default:
      return '未知状态'
  }
}

// 使用后端返回的进度百分比
const getProgressPercentage = (task) => {
  // 确保task对象有效
  if (!task) return 0
  
  // 使用后端返回的percentage字段，如果不存在则默认为0%
  return task.percentage !== undefined ? task.percentage : 0
}

// 任务进度颜色
const getProgressColor = (task) => {
  // 确保task对象有效
  if (!task) return '#909399'
  
  // 根据任务状态决定颜色
  switch (task.taskStatus) {
    case TASK_STATUS.PENDING:
      return '#909399'
    case TASK_STATUS.PROCESSING:
      return '#E6A23C'
    case TASK_STATUS.FINISHED:
      return '#67C23A'
    case TASK_STATUS.SKIPPED:
      return '#F56C6C'
    default:
      return '#909399'
  }
}

// 任务进度状态
const getProgressStatus = (task) => {
  // 确保task对象有效
  if (!task) return 'normal'
  
  // 根据任务状态决定进度条状态
  switch (task.taskStatus) {
    case TASK_STATUS.FINISHED:
      return 'success'
    case TASK_STATUS.SKIPPED:
      return 'exception'
    case TASK_STATUS.PROCESSING:
      return 'active'
    default:
      return 'normal'
  }
}

// 父任务列表
const parentTasks = ref([])
// 任务详情对话框可见性
const dialogVisible = ref(false)
// 当前选中的任务
const currentTask = ref(null)

// 加载父任务列表
const loadParentTasks = async () => {
  try {
    const response = await getParentTasks()
    // 为每个任务添加扩展属性，添加空值检查
    parentTasks.value = (response.data || []).map((task) => ({
      ...task,
      expanded: false,
      loading: false,
      // 保留后端返回的hasSubTasks和percentage字段
      hasSubTasks: task.hasSubTasks !== undefined ? task.hasSubTasks : false,
      subTasks: []
    }))
  } catch (error) {
    ElMessage.error('加载任务列表失败')
    console.error('加载任务列表失败:', error)
  }
}

// 切换子任务显示/隐藏
const toggleSubTasks = async (task) => {
  if (!task.expanded) {
    // 加载子任务
    await loadSubTasks(task)
  }
  task.expanded = !task.expanded
}

// 加载子任务
const loadSubTasks = async (parentTask) => {
  if (!parentTask.loading && parentTask.subTasks.length === 0) {
    try {
      parentTask.loading = true
      const response = await getSubTasks(parentTask.taskId)
      parentTask.subTasks = (response.data || []).map((task) => ({
        ...task,
        expanded: false,
        loading: false,
        hasSubTasks: task.hasSubTasks !== undefined ? task.hasSubTasks : false, // 使用后端返回的值，默认false
        subTasks: [],
        parentTaskId: parentTask.taskId
      }))
    } catch (error) {
      ElMessage.error('加载子任务失败')
      console.error('加载子任务失败:', error)
    } finally {
      parentTask.loading = false
    }
  }
}

// 显示任务详情
const showTaskDetail = async (task) => {
  try {
    const response = await getTaskDetail(task.taskId)
    currentTask.value = response.data || null
    dialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载任务详情失败')
    console.error('加载任务详情失败:', error)
  }
}

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false
  currentTask.value = null
}

// 页面加载时初始化数据
onMounted(() => {
  loadParentTasks()
})
</script>

<style scoped>
.task-management {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.task-list {
  margin-top: 20px;
}

.task-item {
  margin-bottom: 10px;
}

.task-row {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background-color: #f9f9f9;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.task-row:hover {
  background-color: #f0f0f0;
}

.task-name {
  flex: 1;
  margin: 0 16px;
  font-weight: 500;
}

.task-status {
  margin-right: 16px;
}

.spacer {
  width: 24px;
}

.progress-container {
  margin: 8px 0 0 40px;
  width: calc(100% - 60px);
  animation: fadeIn 0.5s ease-in;
}

.sub-tasks {
  margin-left: 32px;
  margin-top: 8px;
}

.loading {
  padding: 16px;
}

/* 展开/收起动画 */
.expand-enter-active,
.expand-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.expand-enter-from,
.expand-leave-to {
  max-height: 0;
  opacity: 0;
  transform: translateY(-10px);
}

/* 淡入动画 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.task-detail {
  padding: 10px 0;
}
</style>

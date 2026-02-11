<template>
  <div class="task-item">
    <!-- 任务行 -->
    <div class="task-row" @click.stop="$emit('show-detail', task)">
      <!-- 左侧内容区域 -->
      <div class="left-content">
        <!-- 展开/收起按钮容器 -->
        <div class="expand-btn-container" @click.stop="toggleSubTasks" v-if="task.hasSubTasks">
          <el-button type="text"
            :icon="task.expanded ? CaretBottom : CaretRight"></el-button>
        </div>

        <!-- 子任务序号 -->
        <span v-if="!isFirstLevelTask" class="task-number" style="margin-right: 0px;">{{ taskIndex + 1 }}.</span>
        
        <!-- 任务名称 -->
        <span class="task-name">{{ task.taskName }}</span>

      <!-- 任务状态 -->
      <el-tag :type="getStatusType(task.taskStatus)" size="small" class="task-status">
        {{ getStatusText(task.taskStatus) }}
      </el-tag>

      <!-- 任务进度条 -->
      <div class="progress-container">
        <el-progress :percentage="getProgressPercentage(task)" :color="getProgressColor(task)"
          :status="getProgressStatus(task)" :text-inside="true" style="font-size: 8px;" :stroke-width="11" striped striped-flow :duration="200"></el-progress>
      </div>
      </div>

      <!-- 右侧按钮区域 -->
        <div class="right-buttons" @click.stop>
          <!-- 新增子任务按钮 -->
          <!-- <el-tooltip content="新增子任务" placement="top" v-if="isHasTeacherRole"> -->
          <el-tooltip content="新增子任务" placement="top">
            <el-button link type="primary" @click.stop="handleAddSubTask" :icon="Plus"></el-button>
          </el-tooltip>
          <!-- 任务详情按钮 -->
          <el-tooltip content="任务详情" placement="top">
            <el-button link type="primary" @click.stop="$emit('show-detail', task)" :icon="Document" style="margin-left: 0px;"></el-button>
          </el-tooltip>
          <!-- 文件信息按钮 -->
          <el-tooltip content="文件信息" placement="top">
            <el-button link type="primary" @click.stop="handleShowFiles" :icon="Files" style="margin-left: 0px;"></el-button>
          </el-tooltip>
          <!-- 修改状态下拉菜单 -->
          <!-- <el-tooltip content="更新任务状态" placement="top" v-if="isHasTeacherRole"> -->
          <el-tooltip content="更新任务状态" placement="top">
            <el-dropdown trigger="click" @command="(newStatus) => handleChangeStatus(newStatus)">
              <el-button link type="primary" :icon="Switch"></el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="1">未开始</el-dropdown-item>
                  <el-dropdown-item command="2">进行中</el-dropdown-item>
                  <el-dropdown-item command="3">已完成</el-dropdown-item>
                  <el-dropdown-item command="4">已跳过</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </el-tooltip>
          <!-- 删除任务按钮 -->
          <!-- <el-tooltip content="删除任务" placement="top" v-if="isHasTeacherRole"> -->
          <el-tooltip content="删除任务" placement="top">
            <el-button link type="primary" @click.stop="handleDeleteTask" :icon="Delete"></el-button>
          </el-tooltip>
        </div>
    </div>

    <!-- 子任务列表（带动画效果） -->
    <transition name="expand">
      <div v-if="task.expanded" class="sub-tasks">
        <div class="loading" v-if="task.loading">
          <el-skeleton :rows="3" animated />
        </div>
        <div v-else>
          <TaskItem v-for="(subTask, subTaskIndex) in task.subTasks" :key="subTask.taskId" :task="subTask"
            :task-index="subTaskIndex"
            :is-first-level-task="false"
            :expanded-task-ids="expandedTaskIds"
            :is-has-teacher-role="isHasTeacherRole"
            @show-detail="(...args) => $emit('show-detail', ...args)"
            @add-sub-task="(...args) => $emit('add-sub-task', ...args)"
            @update-expanded="(...args) => $emit('update-expanded', ...args)"
            @change-status="(...args) => $emit('change-status', ...args)"
            @delete-task="(...args) => $emit('delete-task', ...args)"
            @show-files="(...args) => $emit('show-files', ...args)" />
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSubTasks } from '@/api/task/task'
import {CaretRight,CaretBottom,Plus, Files, Switch, Delete, Document } from '@element-plus/icons-vue'

// 组件属性
const props = defineProps({
  task: {
    type: Object,
    required: true
  },
  taskIndex: {
    type: Number,
    default: 0
  },
  isFirstLevelTask: {
    type: Boolean,
    default: true
  },
  expandedTaskIds: {
    type: Object,
    required: true
  },
  isHasTeacherRole: {
    type: Boolean,
    default: false
  }
})

// 组件事件
const emit = defineEmits(['show-detail', 'add-sub-task', 'update-expanded', 'change-status', 'delete-task', 'show-files'])

// 任务状态枚举
const TASK_STATUS = {
  PENDING: 1,
  PROCESSING: 2,
  FINISHED: 3,
  SKIPPED: 4
}

// 任务状态类型映射
const getStatusType = (status) => {
  // 将状态转换为数字类型进行比较
  const numStatus = parseInt(status)
  switch (numStatus) {
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
  // 将状态转换为数字类型进行比较
  const numStatus = parseInt(status)
  switch (numStatus) {
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
  
  // 根据任务状态决定颜色，与统计卡片风格协调
  switch (task.taskStatus) {
    case TASK_STATUS.PENDING:
      return '#5c9ce6'
    case TASK_STATUS.PROCESSING:
      return '#ff9800'
    case TASK_STATUS.FINISHED:
      return '#66bb6a'
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

// 切换子任务显示/隐藏
const toggleSubTasks = async () => {
  if (!props.task.expanded) {
    // 加载子任务
    await loadSubTasks()
  }
  props.task.expanded = !props.task.expanded
  
  // 通知父组件更新展开状态
  emit('update-expanded', {
    taskId: props.task.taskId,
    expanded: props.task.expanded
  })
}

// 新增子任务
const handleAddSubTask = () => {
  emit('add-sub-task', props.task)
}

// 修改状态
const handleChangeStatus = (newStatus) => {
  emit('change-status', props.task, newStatus)
}

// 删除任务
const handleDeleteTask = () => {
  emit('delete-task', props.task)
}

// 显示文件信息
const handleShowFiles = () => {
  emit('show-files', props.task)
}

// 加载子任务
const loadSubTasks = async () => {
  if (!props.task.loading && props.task.subTasks.length === 0) {
    try {
      props.task.loading = true
      const response = await getSubTasks(props.task.taskId)
      props.task.subTasks = (response.data || []).map((task) => ({
        ...task,
        expanded: props.expandedTaskIds.has(task.taskId), // 检查是否在展开集合中
        loading: false,
        hasSubTasks: task.hasSubTasks !== undefined ? task.hasSubTasks : false, // 使用后端返回的值，默认false
        subTasks: [],
        parentTaskId: props.task.taskId
      }))
    } catch (error) {
      ElMessage.error('加载子任务失败')
      console.error('加载子任务失败:', error)
    } finally {
      props.task.loading = false
    }
  }
}
</script>

<style scoped>
.task-item {
  margin-bottom: 12px;
  position: relative;
}

.task-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 3px;
  background: #5c9ce6;
  border-radius: 3px 0 0 3px;
  opacity: 0.5;
  transition: opacity 0.3s;
}

.task-item:hover::before {
  opacity: 0.8;
}

.task-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 18px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(248, 250, 252, 0.9) 100%);
  border-radius: 10px;
  cursor: pointer;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1), background 0.3s cubic-bezier(0.4, 0, 0.2, 1), border-color 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(92, 156, 230, 0.12);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03), 0 1px 2px rgba(0, 0, 0, 0.02);
  backdrop-filter: blur(8px);
  margin-left: 3px;
  will-change: transform, box-shadow;
}

.task-row:hover {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(241, 245, 249, 0.95) 100%);
  border-color: rgba(92, 156, 230, 0.25);
  box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06), 0 3px 6px rgba(0, 0, 0, 0.03);
  transform: translateY(-1px);
}

.left-content {
  display: flex;
  align-items: center;
  flex: 1;
  gap: 6px;
}

.right-buttons {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 3px;
  padding: 3px 6px;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 6px;
  backdrop-filter: blur(3px);
}

.right-buttons :deep(.el-button) {
  transition: all 0.2s;
}

.right-buttons :deep(.el-button:hover) {
  transform: scale(1.1);
}

.task-name {
  flex: 0 1 auto;
  margin: 0 12px 0 6px;
  font-weight: 600;
  font-size: 14px;
  color: #1a202c;
  min-width: 100px;
  max-width: 300px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  letter-spacing: 0.2px;
}

.task-number {
  flex: 0 0 auto;
  margin: 0 6px 0 0;
  font-weight: 600;
  font-size: 13px;
  color: #4a5568;
  min-width: 20px;
  text-align: center;
  font-family: 'Segoe UI', 'Roboto', sans-serif;
}

.task-status {
  margin: 0 12px;
  width: 70px;
  text-align: center;
  flex-shrink: 0;
}

.task-status :deep(.el-tag) {
  border-radius: 5px;
  font-weight: 500;
  padding: 3px 8px;
  letter-spacing: 0.2px;
}

.expand-btn-container {
  width: 26px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 26px;
  border-radius: 5px;
  transition: all 0.2s;
  cursor: pointer;
}

.expand-btn-container:hover {
  background: rgba(92, 156, 230, 0.08);
}

.expand-btn-container :deep(.el-button) {
  padding: 0;
  width: 100%;
  height: 100%;
}

.sub-tasks {
  margin-left: 32px;
  margin-top: 8px;
}

.loading {
  padding: 16px;
}

.progress-container {
  flex: 3.6;
  margin: 0 12px 0 0;
  min-width: 200px;
  max-width: 800px;
  animation: fadeIn 0.5s ease-in;
  flex-shrink: 1;
}

.progress-container :deep(.el-progress) {
  border-radius: 7px;
  overflow: hidden;
  height: 11px;
}

.progress-container :deep(.el-progress__bar) {
  border-radius: 7px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.3s;
  will-change: box-shadow;
}

.progress-container :deep(.el-progress__bar:hover) {
  box-shadow: 0 3px 9px rgba(0, 0, 0, 0.12), 0 2px 4px rgba(0, 0, 0, 0.08);
}

.progress-container :deep(.el-progress__innerText) {
  color: #fff;
  font-weight: 600;
  font-size: 10px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  letter-spacing: 0.2px;
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


</style>
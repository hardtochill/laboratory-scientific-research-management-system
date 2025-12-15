<template>
  <div class="task-item">
    <!-- 任务行 -->
    <div class="task-row">
      <!-- 左侧内容区域 -->
      <div class="left-content">
        <!-- 展开/收起按钮容器 -->
        <div class="expand-btn-container">
          <el-button type="text" @click.stop="toggleSubTasks"
            :icon="task.expanded ? CaretBottom : CaretRight" v-if="task.hasSubTasks"></el-button>
        </div>

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
        <div class="right-buttons">
          <!-- 新增子任务按钮 -->
          <el-tooltip content="新增子任务" placement="top">
            <el-button link type="primary" @click.stop="handleAddSubTask" :icon="Plus"></el-button>
          </el-tooltip>
          <!-- 修改任务按钮 -->
          <el-tooltip content="任务详情" placement="top">
            <el-button link type="primary" @click.stop="$emit('show-detail', task)" :icon="MoreFilled" style="margin-left: 0px;"></el-button>
          </el-tooltip>
          <!-- 修改状态下拉菜单 -->
          <el-tooltip content="更新任务状态" placement="top">
            <el-dropdown trigger="click" @command="(newStatus) => handleChangeStatus(newStatus)">
              <el-button link type="primary" :icon="Switch"></el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="0">未开始</el-dropdown-item>
                  <el-dropdown-item command="1">进行中</el-dropdown-item>
                  <el-dropdown-item command="2">已完成</el-dropdown-item>
                  <el-dropdown-item command="3">已跳过</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
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
          <TaskItem v-for="subTask in task.subTasks" :key="subTask.taskId" :task="subTask"
            :expanded-task-ids="expandedTaskIds"
            @show-detail="$emit('show-detail', $event)"
            @add-sub-task="$emit('add-sub-task', $event)"
            @update-expanded="$emit('update-expanded', $event)"
            @change-status="$emit('change-status', $event)" />
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSubTasks } from '@/api/task/task'
import {CaretRight,CaretBottom,Plus, MoreFilled, Switch } from '@element-plus/icons-vue'

// 组件属性
const props = defineProps({
  task: {
    type: Object,
    required: true
  },
  expandedTaskIds: {
    type: Object,
    required: true
  }
})

// 组件事件
const emit = defineEmits(['show-detail', 'add-sub-task', 'update-expanded', 'change-status'])

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
}

.task-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #f9f9f9;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.left-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.right-buttons {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 8px;
}

.task-row:hover {
  background-color: #f0f0f0;
}

.task-name {
  flex: 0 1 auto;
  margin: 0 16px 0 0;
  font-weight: 600;
  font-size: 16px;
  color: #2c3e50;
  min-width: 100px;
  max-width: 300px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.task-status {
  margin: 0 16px;
  width: 70px;
  text-align: center;
  flex-shrink: 0;
}

.expand-btn-container {
  width: 24px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
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
  margin: 0 16px 0 0;
  min-width: 200px;
  max-width: 850px;
  animation: fadeIn 0.5s ease-in;
  flex-shrink: 1;
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
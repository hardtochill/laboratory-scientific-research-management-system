<template>
  <div class="task-item-card" @click="$emit('click')">
    <!-- 当前任务 -->
    <div class="current-task">
      <div class="task-header">
        <div class="header-left">
          <span class="task-name">{{ task.taskName }}</span>
        </div>
        <div class="header-right">
          <el-button type="primary" size="small" @click.stop="handleReport" class="report-btn">
            <el-icon><ChatDotRound /></el-icon>
            任务汇报
          </el-button>
          <el-button v-if="!isHierarchical" link type="info" size="small" @click.stop="handleShowHierarchical" class="view-btn">
            <el-icon><ArrowDown /></el-icon>
            展开层级
          </el-button>
          <el-button v-else link type="info" size="small" @click.stop="handleShowSingle" class="view-btn">
            <el-icon><ArrowUp /></el-icon>
            收起层级
          </el-button>
        </div>
      </div>
      
      <!-- 父任务链（展开层级时） -->
      <div v-if="isHierarchical && parentChain.length > 0" class="hierarchy-chain">
        <div v-for="(parent, index) in parentChain" :key="parent.taskId" class="hierarchy-item">
          <div class="hierarchy-row">
            <span v-if="index > 0" class="hierarchy-arrow">└─</span>
            <span :class="['hierarchy-name', { 'current-hierarchy': parent.taskId === task.taskId }]">
              {{ parent.taskName }}
            </span>
          </div>
        </div>
      </div>
      
      <div class="task-details">
        <div class="detail-grid">
          <div class="detail-item">
            <div class="detail-label">汇报频率</div>
            <div class="detail-value">{{ task.reportFrequency || '-' }}天</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">最后汇报时间</div>
            <div class="detail-value">{{ formatReportTime(task.lastReportTime) }}</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">创建人</div>
            <div class="detail-value">{{ formatCreator(task.createUserNickName, task.createUserName) }}</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">执行人</div>
            <div class="detail-value">{{ formatCreator(task.executorNickName, task.executorUserName) }}</div>
          </div>
        </div>
        
        <!-- 汇报状态提示 -->
        <div class="report-status" v-if="isOverdue(task)">
          <el-alert
            title="⚠️  该任务已超时未汇报"
            type="warning"
            :closable="false"
            show-icon
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { parseTime } from '@/utils/ruoyi'
import { ChatDotRound, ArrowDown, ArrowUp } from '@element-plus/icons-vue'

const props = defineProps({
  task: {
    type: Object,
    required: true
  },
  isHierarchical: {
    type: Boolean,
    default: false
  },
  parentChain: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['report', 'show-hierarchical', 'show-single', 'click'])

// 格式化汇报时间
const formatReportTime = (time) => {
  if (!time) return '暂无汇报'
  return parseTime(time)
}

// 格式化创建人
const formatCreator = (nickName, userName) => {
  if (!nickName && !userName) return '未知'
  if (nickName && userName) {
    return `${nickName}(${userName})`
  }
  return nickName || userName
}

// 检查是否超时
const isOverdue = (task) => {
  if (!task.lastReportTime || !task.reportFrequency) return false
  
  const lastReportDate = new Date(task.lastReportTime)
  const now = new Date()
  const daysDiff = Math.floor((now - lastReportDate) / (1000 * 60 * 60 * 24))
  
  return daysDiff > (task.reportFrequency || 0)
}

// 汇报任务
const handleReport = () => {
  emit('report', props.task)
}

// 以层级方式展示
const handleShowHierarchical = () => {
  emit('show-hierarchical', props.task)
}

// 以单任务方式展示
const handleShowSingle = () => {
  emit('show-single', props.task)
}
</script>

<style scoped>
.task-item-card {
  background: #fff;
  border: 1px solid #e4e7ed;
  border-radius: 12px;
  padding: 20px;
  transition: all 0.3s;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.task-item-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.parent-chain {
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 1px dashed #dcdfe6;
}

.parent-task {
  margin-bottom: 12px;
  padding: 12px;
  background-color: #f8f9fa;
  border-radius: 8px;
  border-left: 3px solid #409eff;
}

.hierarchy-chain {
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px dashed #dcdfe6;
}

.hierarchy-item {
  padding: 4px 0;
}

.hierarchy-row {
  display: flex;
  align-items: center;
  gap: 4px;
}

.hierarchy-arrow {
  color: #909399;
  font-size: 14px;
}

.hierarchy-name {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

.current-hierarchy {
  font-weight: 600;
  color: #409eff;
  background-color: #ecf5ff;
  padding: 2px 8px;
  border-radius: 4px;
  border-left: 3px solid #409eff;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.parent-task-header {
  margin-bottom: 8px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.task-name {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.parent-task-header .task-name {
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.chain-tag {
  background-color: #e6f7ff;
  color: #409eff;
  border-color: #91d5ff;
}

.current-tag {
  background-color: #f6ffed;
  color: #67c23a;
  border-color: #b3e19d;
}

.report-btn {
  display: flex;
  align-items: center;
  gap: 4px;
}

.view-btn {
  display: flex;
  align-items: center;
  gap: 4px;
}

.task-details {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-row {
  display: flex;
  gap: 20px;
  font-size: 13px;
  color: #606266;
}

.detail-label {
  font-weight: 500;
  color: #909399;
}

.detail-value {
  color: #606266;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
}

.detail-item {
  background-color: #fafafa;
  padding: 12px;
  border-radius: 6px;
  text-align: center;
}

.detail-item .detail-label {
  font-size: 12px;
  margin-bottom: 4px;
  color: #909399;
}

.detail-item .detail-value {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}

.report-status {
  margin-top: 8px;
}

.current-task.has-parent {
  padding-top: 16px;
  border-top: 1px dashed #dcdfe6;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .task-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }
  
  .header-right {
    width: 100%;
    justify-content: space-between;
  }
  
  .detail-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .detail-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .detail-row {
    flex-direction: column;
    gap: 4px;
  }
}
</style>


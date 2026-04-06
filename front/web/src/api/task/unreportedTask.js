import request from '@/utils/request'

// 查询待汇报任务列表
// timeoutFlag: 1-已汇报/未超时，2-超时未汇报
// taskType: 1-我的待汇报任务，2-我的待接收汇报任务（仅学生角色使用）
export function getUnreportedTaskList(timeoutFlag, executorUserId, taskType) {
  return request({
    url: `/unreportedTask/list/${timeoutFlag}`,
    method: 'get',
    params: {
      executorUserId,
      taskType
    }
  })
}

// 查询任务的父任务列表
export function getParentTasks(taskId) {
  return request({
    url: `/unreportedTask/parentTasks/${taskId}`,
    method: 'get'
  })
}

import request from '@/utils/request'

// 查询父任务列表
export function getParentTasks() {
  return request({
    url: '/task/parent-tasks',
    method: 'get'
  })
}

// 查询子任务列表
export function getSubTasks(parentTaskId) {
  return request({
    url: `/task/sub-tasks/${parentTaskId}`,
    method: 'get'
  })
}

// 查询任务详情
export function getTaskDetail(taskId) {
  return request({
    url: `/task/${taskId}`,
    method: 'get'
  })
}

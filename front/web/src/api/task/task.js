import request from '@/utils/request'

// 查询任务列表（带分页和查询条件）
export function getList(params) {
  return request({
    url: '/task/list',
    method: 'get',
    params
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

// 新增或修改任务
export function addOrUpdateTask(data) {
  return request({
    url: '/task/addOrUpdate',
    method: 'post',
    data
  })
}

// 更新任务状态
export function updateTaskStatus(data) {
  return request({
    url: '/task/updateTaskStatus',
    method: 'post',
    data
  })
}

// 删除任务
export function deleteTask(taskId) {
  return request({
    url: `/task/delete/${taskId}`,
    method: 'delete'
  })
}


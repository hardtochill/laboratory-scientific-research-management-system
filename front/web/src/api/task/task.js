import request from '@/utils/request'

// 查询任务列表（带分页和查询条件）
export function getList(params) {
  return request({
    url: '/task/listParents',
    method: 'get',
    params
  })
}

// 查询子任务列表
export function getSubTasks(parentTaskId) {
  return request({
    url: `/task/listSubs/${parentTaskId}`,
    method: 'get'
  })
}

// 查询任务详情
export function getTaskDetail(taskId) {
  return request({
    url: `/task/getDetail/${taskId}`,
    method: 'get'
  })
}

// 新增任务
export function addTask(data) {
  return request({
    url: '/task/add',
    method: 'post',
    data
  })
}
// 修改任务
export function updateTask(data){
  return request({
    url: '/task/update',
    method: 'post',
    data
  })
}

// 更新任务状态
export function updateTaskStatus(taskId,status) {
  return request({
    url: '/task/updateStatus',
    method: 'post',
    params: {
      taskId: taskId,
      status: status
    }
  })
}

// 删除任务
export function deleteTask(taskId) {
  return request({
    url: `/task/delete/${taskId}`,
    method: 'delete'
  })
}

// 获取任务参与用户组
export function getTaskParticipantUsers(taskId) {
  return request({
    url: `/task/getParticipantUsers/${taskId}`,
    method: 'get'
  })
}

// 获取可供选择的用户列表
export function getSelectableUsers(params) {
  return request({
    url: '/task/listUsersForSelect',
    method: 'get',
    params
  })
}

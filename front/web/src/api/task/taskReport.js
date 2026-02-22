import request from '@/utils/request'

// 查询任务汇报列表
export function getTaskReportList(taskId, query) {
  return request({
    url: '/taskReport/list/' + taskId,
    method: 'get',
    params: query
  })
}

// 新增任务汇报
export function addTaskReport(data) {
  return request({
    url: '/taskReport',
    method: 'post',
    data: data
  })
}

// 删除任务汇报
export function deleteTaskReport(reportId) {
  return request({
    url: '/taskReport/' + reportId,
    method: 'delete'
  })
}

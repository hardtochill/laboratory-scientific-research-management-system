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
export function addTaskReport(taskId, reportContent, fileList) {
  const formData = new FormData()
  formData.append('taskId', taskId)
  formData.append('reportContent', reportContent)
  
  if (fileList && fileList.length > 0) {
    fileList.forEach(file => {
      if (file.raw) {
        formData.append('fileList', file.raw)
      } else {
        formData.append('fileList', file)
      }
    })
  }
  
  return request({
    url: '/taskReport',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除任务汇报
export function deleteTaskReport(reportId) {
  return request({
    url: '/taskReport/' + reportId,
    method: 'delete'
  })
}

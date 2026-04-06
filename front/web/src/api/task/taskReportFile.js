import request from '@/utils/request'

export function listTaskReportFiles(taskReportId) {
  return request({
    url: `/taskReportFile/list/${taskReportId}`,
    method: 'get'
  })
}

export function downloadTaskReportFile(fileId) {
  return request({
    url: `/taskReportFile/download/${fileId}`,
    method: 'get',
    responseType: 'blob'
  })
}

import request from '@/utils/request'

// 获取任务关联的文件列表
export function getTaskFileList(taskId) {
  return request({
    url: `/taskFile/list/${taskId}`,
    method: 'get'
  })
}

// 上传文件
export function uploadTaskFile(taskId, formData) {
  return request({
    url: `/taskFile/upload/${taskId}`,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 下载文件
export function downloadTaskFile(fileId) {
  return request({
    url: `/taskFile/download/${fileId}`,
    method: 'get',
    responseType: 'blob'
  })
}

// 删除文件
export function deleteTaskFile(fileId) {
  return request({
    url: `/taskFile/delete/${fileId}`,
    method: 'delete'
  })
}
import request from '@/utils/request'

// 上传投稿流程文件
export function uploadSubmissionProcessFile(processId, file,tag) {
  const formData = new FormData()
  formData.append('processId', processId)
  formData.append('file', file.raw || file)
  formData.append('tag', tag)
  return request({
    url: '/submissionProcessFile/upload',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 下载投稿流程文件
export function downloadSubmissionProcessFile(fileId) {
  return request({
    url: `/submissionProcessFile/download/${fileId}`,
    method: 'post',
    responseType: 'blob'
  })
}

// 删除投稿流程文件
export function deleteSubmissionProcessFile(id) {
  return request({
    url: `/submissionProcessFile/${id}`,
    method: 'delete'
  })
}

// 获取投稿流程的所有关联文件
export function getSubmissionProcessFiles(processId) {
  return request({
    url: `/submissionProcessFile/list/${processId}`,
    method: 'get'
  })
}
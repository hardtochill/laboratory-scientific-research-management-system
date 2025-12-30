import request from '@/utils/request'

// 获取评论关联的文件列表
export function getCommentFiles(commentId) {
  return request({
    url: `/commentFile/list/${commentId}`,
    method: 'get'
  })
}

// 下载文件
export function downloadFile(fileId) {
  return request({
    url: `/commentFile/download/${fileId}`,
    method: 'post',
    responseType: 'blob'
  })
}

// 上传文件
export function uploadFile(commentId, file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: `/commentFile/upload/${commentId}`,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除文件
export function deleteFile(fileId) {
  return request({
    url: `/commentFile/delete/${fileId}`,
    method: 'delete'
  })
}
import request from '@/utils/request'

// 查询父评论列表
export function listParentComments(literatureId, sortField, sortOrder, pageNum, pageSize) {
  return request({
    url: '/comment/listParent',
    method: 'get',
    params: {
      literatureId: literatureId,
      sortField: sortField,
      sortOrder: sortOrder,
      pageNum: pageNum,
      pageSize: pageSize
    }
  })
}

// 查询子评论列表
export function listChildComments(parentId) {
  return request({
    url: '/comment/listChild',
    method: 'get',
    params: {
      parentId: parentId
    }
  })
}

// 切换评论点赞状态
export function toggleLike(commentId) {
  return request({
    url: `/comment/toggleLike/${commentId}`,
    method: 'post'
  })
}

// 删除评论
export function deleteComment(commentId) {
  return request({
    url: `/comment/delete/${commentId}`,
    method: 'delete'
  })
}

// 发表评论
export function addComment(parentId, literatureId, commentContent, visibleType, fileList) {
  const formData = new FormData()
  formData.append('parentId', parentId)
  formData.append('literatureId', literatureId)
  formData.append('commentContent', commentContent)
  formData.append('visibleType', visibleType)
  
  // 添加文件
  if (fileList && fileList.length > 0) {
    fileList.forEach(file => {
      formData.append('fileList', file)
    })
  }
  
  return request({
    url: '/comment/add',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}
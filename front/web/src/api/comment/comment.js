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

// 发表评论
export function addComment(parentId, literatureId, commentContent, visibleType, fileList, receiveUserId = null, receiveUserNickName = null) {
  const formData = new FormData()
  formData.append('parentId', parentId)
  formData.append('literatureId', literatureId)
  formData.append('commentContent', commentContent)
  formData.append('visibleType', visibleType)
  
  // 添加接收用户ID（用于回复评论时指定被回复的用户）
  formData.append('receiveUserId', receiveUserId !== null && receiveUserId !== undefined ? receiveUserId : '')
  
  // 添加接收用户昵称（用于回复评论时显示@用户）
  formData.append('receiveUserNickName', receiveUserNickName !== null && receiveUserNickName !== undefined ? receiveUserNickName : '')
  
  // 添加文件 - 从Element Plus文件对象中提取原始File对象
  if (fileList && fileList.length > 0) {
    fileList.forEach(file => {
      // Element Plus文件对象中，原始File对象存储在raw属性中
      if (file.raw) {
        formData.append('fileList', file.raw)
      } else {
        // 如果没有raw属性，直接使用file对象
        formData.append('fileList', file)
      }
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

// 获取评论用户详情
export function getCommentUserDetail(userId) {
  return request({
    url: `/comment/getCommentUserDetail/${userId}`,
    method: 'get',
  })
}

// 删除评论
export function deleteComment(commentId) {
  return request({
    url: `/comment/delete/${commentId}`,
    method: 'delete'
  })
}

// 更改评论可见状态
export function changeVisibleType(commentId, visibleType) {
  return request({
    url: '/comment/changeVisibleType',
    method: 'post',
    params: {
      commentId: commentId,
      visibleType: visibleType
    }
  })
}
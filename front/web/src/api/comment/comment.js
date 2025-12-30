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
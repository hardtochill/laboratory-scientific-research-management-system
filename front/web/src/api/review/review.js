import request from '@/utils/request'

// 查询审核列表
export function listReviews(query) {
  return request({
    url: '/review/list',
    method: 'get',
    params: query
  })
}

// 查询审核详情
export function getReview(id) {
  return request({
    url: `/review/${id}`,
    method: 'get'
  })
}

// 审核通过
export function approveReview(id, reviewerRemark = '') {
  return request({
    url: `/review/approve/${id}`,
    method: 'post',
    params: {
      reviewerRemark: reviewerRemark
    }
  })
}

// 审核不通过
export function rejectReview(id, reviewerRemark = '') {
  return request({
    url: `/review/reject/${id}`,
    method: 'post',
    params: {
      reviewerRemark: reviewerRemark
    }
  })
}

// 获取可供选择的用户列表
export function getSelectableReviewedUsers(params) {
  return request({
    url: '/review/listReviewedUsersForSelect',
    method: 'get',
    params
  })
}
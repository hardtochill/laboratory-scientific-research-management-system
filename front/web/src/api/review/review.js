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

// 审核相关接口已精简，仅保留后端提供的接口

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
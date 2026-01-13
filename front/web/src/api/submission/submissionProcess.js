import request from '@/utils/request'

// 查询投稿计划的所有流程
export function listSubmissionProcessesByPlanId(planId) {
  return request({
    url: `/submissionProcess/plan/${planId}`,
    method: 'get'
  })
}

// 创建投稿流程
export function createSubmissionProcess(data) {
  return request({
    url: '/submissionProcess/add',
    method: 'post',
    data: data
  })
}

// 更新投稿流程
export function updateSubmissionProcess(data) {
  return request({
    url: '/submissionProcess/update',
    method: 'post',
    data: data
  })
}

// 删除投稿流程
export function deleteSubmissionProcess(id) {
  return request({
    url: `/submissionProcess/${id}`,
    method: 'delete'
  })
}

// 发起内部审核
export function submitForReview(processId, reviewedRemark = '') {
  return request({
    url: '/submissionProcess/submitReview',
    method: 'post',
    params: {
      processId: processId,
      reviewedRemark: reviewedRemark
    }
  })
}

// 获取投稿流程详情
export function getSubmissionProcessDetail(id) {
  return request({
    url: `/submissionProcess/detail/${id}`,
    method: 'get'
  })
}

// 获取可供选择的审核人用户列表
export function getSelectableReviewerUsers(params) {
  return request({
    url: '/submissionProcess/listReviewerUsersForSelect',
    method: 'get',
    params
  })
}
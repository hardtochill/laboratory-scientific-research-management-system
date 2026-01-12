import request from '@/utils/request'

// 查询投稿计划列表
export function listSubmissionPlans(query) {
  return request({
    url: '/submissionPlan/list',
    method: 'get',
    params: query
  })
}

// 查询投稿计划详情
export function getSubmissionPlan(id) {
  return request({
    url: `/submissionPlan/${id}`,
    method: 'get'
  })
}

// 创建投稿计划
export function createSubmissionPlan(data) {
  return request({
    url: '/submissionPlan/add',
    method: 'post',
    data: data
  })
}

// 更新投稿计划
export function updateSubmissionPlan(data) {
  return request({
    url: '/submissionPlan/update',
    method: 'post',
    data: data
  })
}

// 删除投稿计划
export function deleteSubmissionPlan(id) {
  return request({
    url: `/submissionPlan/${id}`,
    method: 'delete'
  })
}

// 查询投稿计划名称列表（用于下拉选择）
export function listSubmissionPlansForSelect(query) {
  return request({
    url: '/submissionPlan/listForSelect',
    method: 'get',
    params: query
  })
}
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

// 执行审核
export function doReview(data) {
  return request({
    url: '/review/doReview',
    method: 'post',
    data: data
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

// 获取学生审核人列表
export function getStudentReviewersForSelect(params) {
  return request({
    url: '/review/listStudentReviewersForSelect',
    method: 'get',
    params
  })
}

// 获取教师审核人列表
export function getTeacherReviewersForSelect(params) {
  return request({
    url: '/review/listTeacherReviewersForSelect',
    method: 'get',
    params
  })
}

// 删除审核
export function deleteReview(id) {
  return request({
    url: `/review/${id}`,
    method: 'delete'
  })
}
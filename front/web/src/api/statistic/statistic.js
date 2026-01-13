import request from '@/utils/request'

export function listStudentStatistics(query) {
  return request({
    url: '/statistic/list',
    method: 'get',
    params: query
  })
}

export function listLiteratureStatistics(query) {
  return request({
    url: '/statistic/literature/list',
    method: 'get',
    params: query
  })
}

export function getStudentReadingDetail(studentId, startTime, endTime) {
  return request({
    url: `/statistic/student/${studentId}`,
    method: 'get',
    params: { startTime, endTime }
  })
}

export function getLiteratureReadingDetail(literatureId, startTime, endTime) {
  return request({
    url: `/statistic/literature/${literatureId}`,
    method: 'get',
    params: { startTime, endTime }
  })
}

export function exportStatistics(startTime, endTime, userId, literatureId) {
  return request({
    url: '/statistic/export',
    method: 'get',
    params: { startTime, endTime, userId, literatureId },
    responseType: 'blob'
  })
}

// 获取可供选择的用户列表
export function getSelectableUsers(params) {
  return request({
    url: '/statistic/listUsersForSelect',
    method: 'get',
    params
  })
}

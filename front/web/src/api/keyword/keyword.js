import request from '@/utils/request'

// 查询关键词列表
export function listKeyword(query) {
  return request({
    url: '/keyword/list',
    method: 'get',
    params: query
  })
}

// 新增关键词
export function addKeyword(data) {
  return request({
    url: '/keyword/add',
    method: 'post',
    data: data
  })
}

// 修改关键词
export function updateKeyword(data) {
  return request({
    url: '/keyword/update',
    method: 'post',
    data: data
  })
}

// 删除关键词（单个或批量）
export function deleteKeywords(keywordIds) {
  // Handle both single ID (string/number) and array of IDs
  const ids = Array.isArray(keywordIds) ? keywordIds.join(',') : keywordIds
  return request({
    url: `/keyword/delete/${ids}`,
    method: 'delete'
  })
}
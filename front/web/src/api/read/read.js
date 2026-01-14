import request from '@/utils/request'

// 查询阅读记录列表
export function listLiteratureRead(query) {
  return request({
    url: '/literatureRead/list',
    method: 'get',
    params: query
  })
}

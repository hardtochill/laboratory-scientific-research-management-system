import request from '@/utils/request'

// 查询文献列表
export function listLiterature(query) {
  return request({
    url: '/experiment/literature/list',
    method: 'get',
    params: query
  })
}

// 查询文献详情
export function getLiteratureDetail(id) {
  return request({
    url: `/experiment/literature/detail/${id}`,
    method: 'get'
  })
}

// 下载文献
export function downloadLiterature(id) {
  return request({
    url: `/experiment/literature/download/${id}`,
    method: 'get'
  })
}

// 批量下载文献
export function batchDownloadLiterature(ids) {
  return request({
    url: '/experiment/literature/batchDownload',
    method: 'get',
    params: { ids: ids }
  })
}

// 评分文献
export function scoreLiterature(scoreDTO) {
  return request({
    url: '/experiment/literature/score',
    method: 'post',
    data: scoreDTO
  })
}

// 获取用户对文献的评分
export function getUserLiteratureScore(literatureId) {
  return request({
    url: `/experiment/literature/getUserScore/${literatureId}`,
    method: 'get'
  })
}
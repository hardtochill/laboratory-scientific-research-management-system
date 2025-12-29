import request from '@/utils/request'

// 查询文献列表
export function listLiterature(query) {
  return request({
    url: '/literature/list',
    method: 'get',
    params: query
  })
}

// 查询文献详情
export function getLiteratureDetail(id) {
  return request({
    url: `/literature/detail/${id}`,
    method: 'get'
  })
}

// 下载文献
export function downloadLiterature(id) {
  return request({
    url: `/literature/download/${id}`,
    method: 'get'
  })
}

// 评分文献
export function scoreLiterature(scoreDTO) {
  return request({
    url: '/literature/score',
    method: 'post',
    data: scoreDTO
  })
}

// 添加文献（包含文件上传）
export function addLiterature(formData) {
  return request({
    url: '/literature/add',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 更新文献信息
export function updateLiterature(literatureDTO) {
  return request({
    url: '/literature/update',
    method: 'post',
    data: literatureDTO
  })
}
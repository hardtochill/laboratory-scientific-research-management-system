import request from '@/utils/request'

// 获取文献详情
export function getDetail(id) {
  return request({
    url: `/experiment/literature/detail/${id}`,
    method: 'get'
  })
}

// 获取文献心得列表
export function getNoteList(params) {
  return request({
    url: '/experiment/note/list',
    method: 'get',
    params
  })
}

// 下载文献
export function downloadLiterature(id) {
  return request({
    url: `/experiment/literature/download/${id}`,
    method: 'post',
    responseType: 'blob'
  })
}

// 评分文献
export function scoreLiterature(data) {
  return request({
    url: '/experiment/literature/score',
    method: 'post',
    data
  })
}
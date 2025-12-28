import request from '@/utils/request'

// 获取文献详情
export function getDetail(id) {
  return request({
    url: `/literature/detail/${id}`,
    method: 'get'
  })
}

// 获取文献心得列表
export function getNoteList(params) {
  return request({
    url: '/note/list',
    method: 'get',
    params
  })
}

// 下载文献
export function downloadLiterature(id) {
  return request({
    url: `/literature/download/${id}`,
    method: 'post',
    responseType: 'blob'
  })
}

// 评分文献
export function scoreLiterature(data) {
  return request({
    url: '/literature/score',
    method: 'post',
    data
  })
}

// 切换心得点赞状态
export function toggleNoteLike(noteId) {
  return request({
    url: `/note/toggle-like/${noteId}`,
    method: 'post'
  })
}
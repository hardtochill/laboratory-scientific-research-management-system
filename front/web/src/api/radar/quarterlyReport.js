import request from '@/utils/request'

export function listQuarterlyReport(query) {
    return request({
        url: '/quarterlyReport/list',
        method: 'get',
        params: query
    })
}

export function getQuarterlyReport(id) {
    return request({
        url: '/quarterlyReport/' + id,
        method: 'get'
    })
}
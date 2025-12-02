import request from '@/utils/request'

export function listMonthlyReport(query) {
    return request({
        url: '/monthlyReport/list',
        method: 'get',
        params: query
    })
}

export function getMonthlyReport(id) {
    return request({
        url: '/monthlyReport/' + id,
        method: 'get'
    })
}
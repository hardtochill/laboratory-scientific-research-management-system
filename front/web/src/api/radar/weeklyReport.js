import request from '@/utils/request'

export function listWeeklyReport(query) {
    return request({
        url: '/weeklyReport/list',
        method: 'get',
        params: query
    })
}

export function getWeeklyReport(id) {
    return request({
        url: '/weeklyReport/' + id,
        method: 'get'
    })
}

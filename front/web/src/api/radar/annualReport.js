import request from '@/utils/request'

export function listAnnualReport(query) {
    return request({
        url: '/annualReport/list',
        method: 'get',
        params: query
    })
}

export function getAnnualReport(id) {
    return request({
        url: '/annualReport/' + id,
        method: 'get'
    })
}
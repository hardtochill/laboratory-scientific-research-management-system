import request from '@/utils/request'

export function listTargetInfo(query) {
    return request({
        url: '/targetInfo/list',
        method: 'get',
        params: query
    })
}

export function getTargetInfo(id) {
    return request({
        url: '/targetInfo/' + id,
        method: 'get'
    })
}

export function delVideoByUrl(params) {
    return request({
        url: '/targetInfo/delVideoOnUrl',
        method: 'delete',
        params,
    })
}

export function delVideoByTimePeriod(params) {
    return request({
        url: '/targetInfo/delVideoByTimePeriod',
        method: 'delete',
        params,
    })
}

export function getTargets() {
    return request({
        url: '/targetInfo/getTargets',
        method: 'get',
    })
}

export function getRadarAddress() {
    return request({
        url: '/targetInfo/getRadarAddress',
        method: 'get',
    })
}
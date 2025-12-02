import request from '@/utils/request'

export function listThreatLevel(query) {
    return request({
        url: '/threatLevel/list',
        method: 'get',
        params: query
    })
}

export function getThreatLevel(id) {
    return request({
        url: '/threatLevel/' + id,
        method: 'get'
    })
}

export function addThreatLevel(data) {
    return request({
        url: '/threatLevel',
        method: 'post',
        data: data
    })
}

export function updateThreatLevel(data) {
    return request({
        url: '/threatLevel',
        method: 'put',
        data: data
    })
}

export function delThreatLevel(id) {
    return request({
        url: '/threatLevel/' + id,
        method: 'delete'
    })
}
import request from '@/utils/request'

export function getTargetTypePY() {
    return request({
        url: '/camera/getTargetTypePY',
        method: 'get',
    })
}

export function followTarget(query) {
    return request({
        url: '/camera/followTarget',
        method: 'get',
        params: query
    })
}

export function getAbsoluteZoom() {
    return request({
        url: '/camera/getAbsoluteZoom',
        method: 'get',
    })
}

export function absoluteZoom(query) {
    return request({
        url: '/camera/absoluteZoom',
        method: 'get',
        params: query
    })
}
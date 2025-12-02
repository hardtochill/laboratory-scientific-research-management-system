import request from '@/utils/request'

export function getDeviceStatus() {
    return request({
        url: '/hourReport/getDeviceStatus',
        method: 'get',
    })
}

export function getTodayTargetInfo() {
    return request({
        url: '/hourReport/getTodayTargetInfo',
        method: 'get',
    })
}

export function getTodayTargetCount() {
    return request({
        url: '/hourReport/getTodayTargetCount',
        method: 'get',
    })
}

export function getHourTargetInfo() {
    return request({
        url: '/hourReport/getHourTargetInfo',
        method: 'get',
    })
}

export function getThreatCount(query) {
    return request({
        url: '/hourReport/getThreatCount',
        method: 'get',
        params: query
    })
}

export function getNowTargetInfo() {
    return request({
        url: '/hourReport/getNowTargetInfo',
        method: 'get',
    })
}

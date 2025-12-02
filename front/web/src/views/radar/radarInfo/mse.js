export function videoPlay(videoEl, url) {
    const mseQueue = []
    let mseSourceBuffer
    let mseStreamingStarted = false
    let ws;
    // 用于检测缓冲区时间戳卡死
    let lastBufferedEnd = 0
    let lastCurrentTime = 0

    function startPlay() {
        lastBufferedEnd = 0
        lastCurrentTime = 0
        const mse = new MediaSource()
        videoEl.src = window.URL.createObjectURL(mse) // 将MediaSource塞给video元素
        mse.addEventListener('sourceopen', function () { // 当 MediaSource 可以使用
            if (ws != null) {
                ws.close()
            }
            ws = new WebSocket(url)
            ws.binaryType = 'arraybuffer' // 将收到的数据设置为二进制数组格式
            ws.onopen = function (event) {
                console.log('连接到ws')
            }
            ws.onmessage = function (event) {
                const data = new Uint8Array(event.data)
                if (data[0] === 9) { // 如果数据首字节为 9，说明这是初始化的 codec 信息（而不是视频流数据）
                    let mimeCodec
                    const decodedArr = data.slice(1)
                    if (window.TextDecoder) { // 解析出 codec 信息
                        mimeCodec = new TextDecoder('utf-8').decode(decodedArr)
                    } else {
                        mimeCodec = Utf8ArrayToStr(decodedArr)
                    }
                    mseSourceBuffer = mse.addSourceBuffer('video/mp4; codecs="' + mimeCodec + '"')
                    mseSourceBuffer.mode = 'segments'
                    mseSourceBuffer.addEventListener('updateend', pushPacket) // 每次 appendBuffer 结束后触发 pushPacket，继续处理下一段数据
                } else {
                    readPacket(event.data) // 如果不是 codec 信息（即为视频流数据），则调用 readPacket 处理
                }
            }
            ws.onerror = function (err) {
                console.error('WebSocket错误:', err)
            }
        }, false)
    }

    function pushPacket() {
        let packet
        if (!mseSourceBuffer.updating) {
            if (mseQueue.length > 0) {
                packet = mseQueue.shift()
                mseSourceBuffer.appendBuffer(packet)
            } else {
                mseStreamingStarted = false
            }
        }
        if (videoEl.buffered.length > 0) {
            if (typeof document.hidden !== 'undefined' && document.hidden) {
                // no sound, browser paused video without sound in background
                videoEl.currentTime = videoEl.buffered.end((videoEl.buffered.length - 1)) - 0.5
            }
        }
    }

    function readPacket(packet) {
        if (!mseStreamingStarted) {
            if (videoEl.buffered.length) {
                const end = videoEl.buffered.end(videoEl.buffered.length - 1)
                const nowTime = videoEl.currentTime
                //console.log(`[调试] currentTime=${videoEl.currentTime.toFixed(2)} bufferedEnd=${end.toFixed(2)} queueLen=${mseQueue.length} updating=${mseSourceBuffer.updating}`)
                if (Math.abs(lastBufferedEnd - end) > 10 || Math.abs(lastCurrentTime - nowTime) > 10) {
                    console.warn("时间戳异常帧丢弃")
                    startPlay()
                    return
                }
                lastBufferedEnd = end
                lastCurrentTime = nowTime
            }
            mseSourceBuffer.appendBuffer(packet)
            mseStreamingStarted = true
            return
        }
        mseQueue.push(packet)
        if (!mseSourceBuffer.updating) {
            pushPacket()
        }
    }
    startPlay()
}

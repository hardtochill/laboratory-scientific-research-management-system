export class VideoPlayer {
    constructor(videoEl, url) {
        this.videoEl = videoEl
        this.url = url
        this.mseQueue = []
        this.mseSourceBuffer = null
        this.mseStreamingStarted = false
        this.ws = null
        this.lastBufferedEnd = 0
        this.lastCurrentTime = 0
        this.mse = null
    }

    startPlay() {
        this.lastBufferedEnd = 0
        this.lastCurrentTime = 0
        this.mseQueue = []
        this.mseStreamingStarted = false

        this.mse = new MediaSource()
        this.videoEl.src = window.URL.createObjectURL(this.mse)

        this.mse.addEventListener('sourceopen', () => {
            if (this.ws != null) {
                this.ws.close()
            }

            this.ws = new WebSocket(this.url)
            this.ws.binaryType = 'arraybuffer'

            this.ws.onopen = () => {
                console.log('连接到ws')
            }

            this.ws.onmessage = (event) => {
                const data = new Uint8Array(event.data)
                if (data[0] === 9) {
                    let mimeCodec
                    const decodedArr = data.slice(1)
                    if (window.TextDecoder) {
                        mimeCodec = new TextDecoder('utf-8').decode(decodedArr)
                    } else {
                        mimeCodec = Utf8ArrayToStr(decodedArr)
                    }
                    this.mseSourceBuffer = this.mse.addSourceBuffer('video/mp4; codecs="' + mimeCodec + '"')
                    this.mseSourceBuffer.mode = 'segments'
                    this.mseSourceBuffer.addEventListener('updateend', this.pushPacket.bind(this))
                } else {
                    this.readPacket(event.data)
                }
            }

            this.ws.onerror = (err) => {
                console.error('WebSocket错误:', err)
            }
        }, false)
    }

    pushPacket() {
        if (!this.mseSourceBuffer) return
        if (!this.mseSourceBuffer.updating) {
            if (this.mseQueue.length > 0) {
                const packet = this.mseQueue.shift()
                this.mseSourceBuffer.appendBuffer(packet)
            } else {
                this.mseStreamingStarted = false
            }
        }
        if (this.videoEl.buffered.length > 0) {
            if (typeof document.hidden !== 'undefined' && document.hidden) {
                this.videoEl.currentTime = this.videoEl.buffered.end(this.videoEl.buffered.length - 1) - 0.5
            }
        }
    }

    readPacket(packet) {
        if (!this.mseSourceBuffer) return
        if (!this.mseStreamingStarted) {
            if (this.videoEl.buffered.length) {
                const end = this.videoEl.buffered.end(this.videoEl.buffered.length - 1)
                const nowTime = this.videoEl.currentTime
                if (Math.abs(this.lastBufferedEnd - end) > 10 || Math.abs(this.lastCurrentTime - nowTime) > 10) {
                    console.warn("时间戳异常帧丢弃")
                    this.startPlay()
                    return
                }
                this.lastBufferedEnd = end
                this.lastCurrentTime = nowTime
            }
            this.mseSourceBuffer.appendBuffer(packet)
            this.mseStreamingStarted = true
            return
        }
        this.mseQueue.push(packet)
        if (!this.mseSourceBuffer.updating) {
            this.pushPacket()
        }
    }

    close() {
        if (this.ws) {
            this.ws.close()
            this.ws = null
        }
        if (this.mse) {
            try {
                this.mse.endOfStream()
            } catch (e) {
                console.warn('结束MediaSource失败:', e)
            }
            this.mse = null
        }
        this.videoEl.src = '' // 清空video源
        console.log('播放器已关闭')
    }
}
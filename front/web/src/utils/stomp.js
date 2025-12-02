// utils/websocket.js
import SockJS from 'sockjs-client';
import Stomp from 'stompjs';

let stompClient = null;

export function connect(callback) {
    // 建立连接
    //const socket = new SockJS(import.meta.env.VITE_APP_BASE_API + '/ws'); // 后端 WebSocket 端点
    const socket = new SockJS(import.meta.env.VITE_APP_BASE_API + '/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({
    }, frame => {
        console.log('✅ WebSocket 已连接:', frame);
        // 订阅广播消息
        stompClient.subscribe('/topic/radarInfo', msg => {
            const body = JSON.parse(msg.body);
            callback(body); // 把消息交给外部处理
        });
    }, error => {
        console.error('❌ WebSocket 连接失败:', error);
    });
    stompClient.debug = null;
}

export function sendMessage(from, content) {
    if (stompClient && stompClient.connected) {
        stompClient.send('/app/send', {}, JSON.stringify({from, content}));
    } else {
        console.warn('🚫 stompClient 尚未连接');
    }
}

export function disconnect() {
    if (stompClient !== null) {
        stompClient.disconnect(() => {
            console.log("🛑 WebSocket 已断开");
        });
    }
}
<template>
  <div class="app-container home">
    <div class="box cc">
      <div style="display: flex;align-items: center;font-size: 1.3rem">
        <el-icon style="color: #FFAA22">
          <CaretRight/>
        </el-icon>
        <span>雷达扫描图</span>
      </div>
      <div style="width: 100%;height: 90%;display: flex;justify-content: center;padding-top: 2%">
        <canvas ref="myCanvas" class="myCanvas"></canvas>
      </div>
    </div>
    <div class="box cc">
      <div style="display: flex;align-items: center;font-size: 1.3rem">
        <el-icon style="color: #FFAA22">
          <CaretRight/>
        </el-icon>
        <span>光电预览</span>
      </div>
      <div style="width: 100%;height: 90%;padding-top: 2%">
        <video
            ref="videoRef"
            autoplay
            muted
            style="width: 100%;"
        ></video>
        <el-descriptions
            border
            style="margin-top: 5px"
        >
          <el-descriptions-item align="center">
            <template #label>
              视觉分析类型
            </template>
            <dict-tag :options="target_type" :value="targetTypePY"/>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <!--      <el-button @click="fullScreen">全屏</el-button>-->
    </div>
    <div class="cc" style="width: 100%;height: 30%">
      <div style="display: flex;align-items: center;font-size: 1.3rem">
        <el-icon style="color: #FFAA22">
          <CaretRight/>
        </el-icon>
        <span>选中目标信息</span>
        <el-button type="primary" round :icon="Position" style="margin-left: 5px" size="small" @click="follow">
          跟随目标
        </el-button>
      </div>
      <el-descriptions
          :column="4"
          border
          style="margin-top: 5px"
      >
        <el-descriptions-item align="center">
          <template #label>
            雷达推测类型
          </template>
          <dict-tag :options="target_type" :value="detailsData.targetType"/>
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            威胁等级
          </template>
          <dict-tag :options="threat_level" :value="detailsData.threatLevel"/>
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            水平距离(m)
          </template>
          {{ detailsData.horizontalDistance }}
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            轴向距离(m)
          </template>
          {{ detailsData.axialDistance }}
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            速度
          </template>
          {{ detailsData.speed }}
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            rcs(m²)
          </template>
          {{ detailsData.rcs }}
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            方位角(°)
          </template>
          {{ detailsData.azimuthAngle }}
        </el-descriptions-item>
        <el-descriptions-item align="center">
          <template #label>
            俯仰角(°)
          </template>
          {{ detailsData.pitchAngle }}
        </el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>
<script setup>
import {connect} from '@/utils/stomp';
import {videoPlay} from "@/views/radar/radarInfo/mse.js";
import {Position} from '@element-plus/icons-vue'
import {followTarget, getTargetTypePY} from "@/api/camera/camera.js";
import {ElMessage} from "element-plus";

const {proxy} = getCurrentInstance()
const {threat_level, target_type} = proxy.useDict("threat_level", "target_type")
const detailsData = ref({})
const videoRef = ref()
const canvasWidth = ref(0)
const points = new Map()
const radraInfo = ref({});
const myCanvas = ref()
const targetTypePY = ref(0)
let intervalId;
onMounted(() => {
  // 播放光电预览
  videoPlay(videoRef.value, import.meta.env.VITE_CAMERA_BASE_API)
  // 连接stomp获取雷达数据
  connect(radraInfoCallback)
  const canvas = myCanvas.value;
  const rect = canvas.getBoundingClientRect(); // 获取视觉尺寸（比如 500×300）
  // 设置实际坐标系尺寸一致，避免模糊/错位
  let w = rect.width > rect.height ? rect.height : rect.width
  canvas.width = w;
  canvas.height = w;
  canvas.style.width = w + "px";  // 设置 CSS 尺寸
  canvas.style.height = w + "px";
  canvasWidth.value = w;
  drawRadarCanvas()
  myCanvas.value.addEventListener('click', (e) => {
    const rect = myCanvas.value.getBoundingClientRect();
    const clickX = e.clientX - rect.left - canvasWidth.value / 2;
    const clickY = e.clientY - rect.top - canvasWidth.value / 2;
    for (const [key, value] of points) {
      const dx = clickX - value.x;
      const dy = clickY - value.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      if (distance < 4) {
        detailsData.value = value
        console.log(detailsData.value)
        break
      }
    }
  });
  getTargetTypePY1()
  intervalId = window.setInterval(() => {
    getTargetTypePY1()
  }, 1000)
})
onBeforeUnmount(() => {
  clearInterval(intervalId)
})
const follow = () => {
  console.log(detailsData.value)
  if (detailsData.value.targetId) {
    proxy.$modal.confirm('是否跟随该目标?').then(function () {
      return followTarget({targetId: detailsData.value.targetId})
    })
  } else {
    ElMessage({message: '跟随失败', type: 'error', duration: 5 * 1000})
  }
}
const getTargetTypePY1 = () => {
  getTargetTypePY().then((res) => {
    targetTypePY.value = res.data;
  })
}
const drawRadarCanvas = () => {
  const ctx = myCanvas.value.getContext('2d');
  // 使 canvas 宽度和高度一致
  const width = ctx.canvas.width;
  const height = ctx.canvas.height;
  //myCanvas.value.height = width + 0;
  ctx.fillStyle = 'white'; // 背景色
  ctx.fillRect(0, 0, width, myCanvas.value.height); // 填充整个画布
  // 绘制圆形
  const radius = width / 2;
  ctx.beginPath();
  ctx.arc(radius, radius, radius, 0, Math.PI * 2);
  ctx.fillStyle = 'rgba(0, 0, 0, 0.8)'; // 背景色
  ctx.fill();
  ctx.closePath();

  const gridCount = 5; // 网格数量
  const gridGap = radius / gridCount; // 网格间距

  // 绘制圆圈
  for (let i = 1; i <= gridCount; i++) {
    const gridRadius = gridGap * i; // 网格半径
    ctx.beginPath();
    ctx.arc(radius, radius, gridRadius, 0, Math.PI * 2, true);
    ctx.strokeStyle = '#2EB74E'; // 网格颜色
    ctx.stroke();
    ctx.closePath();
  }
  // 绘制十字刻度
  const tickCount = 4; // 刻度数量
  const tickGap = (Math.PI * 2) / tickCount; // 刻度间距
  for (let i = 0; i < tickCount; i++) {
    const angle = tickGap * i; // 刻度角度
    ctx.beginPath();
    ctx.moveTo(radius, radius);
    ctx.lineTo(
        radius + Math.cos(angle) * radius,
        radius + Math.sin(angle) * radius
    );
    ctx.strokeStyle = '#2EB74E'; // 刻度颜色
    ctx.stroke();
    ctx.closePath();
  }
}
const drawPoints = () => {
  const ctx = myCanvas.value.getContext('2d')
  const width = ctx.canvas.width
  const middle = width / 2
  const now = new Date();
  const tenSecondsAgo = new Date(now.getTime() - 3000); // 当前时间减去 10 秒
  for (const [key, value] of points) {
    const targetTime = new Date(value.scanTime);
    if (targetTime < tenSecondsAgo) {
      points.delete(key);
    } else {
      const {
        x,
        y,
        radius = "4",
        isSelected,
        isScanShow = true,
      } = value;
      ctx.beginPath();
      ctx.arc(middle + x, middle + y, radius, 0, Math.PI * 2, true); // 绘制圆形
      ctx.fillStyle = isSelected ? 'red' : 'green'; // 填充颜色
      ctx.fill(); // 填充圆形
      ctx.closePath(); // 关闭路径
    }
  }
}
const drawScan = (startingAngle) => {
  startingAngle -= 90
  const speed = Math.PI; // 每秒 π 弧度，2秒转一圈
  let lastTime = null;
  let angle = startingAngle * (Math.PI / 180);
  const ctx = myCanvas.value.getContext('2d')
  const width = ctx.canvas.width
  const radius = width / 2
  const scanAnimation = (t) => {
    if (lastTime != null) {
      const delta = (t - lastTime) / 1000; // 单位：秒
      angle += speed * delta;
      angle %= 2 * Math.PI;
    }
    lastTime = t;

    ctx.clearRect(0, 0, width, width) // 清除画布
    drawRadarCanvas(); // 重新绘制背景
    ctx.beginPath();
    ctx.moveTo(radius, radius); // 移动到圆心
    const scanSpeed = 0.01
    ctx.arc(
        radius,
        radius,
        radius,
        angle,
        angle + Math.PI / (180 / 16),
        false
    ); // 绘制扇形区域
    // 填充渐变色且半透明
    const gradient = ctx.createLinearGradient(
        radius,
        radius,
        radius + Math.cos(angle) * radius,
        radius + Math.sin(angle) * radius
    );
    gradient.addColorStop(0, 'rgba(46, 183, 78, 0.5)'); // 起始颜色
    gradient.addColorStop(1, 'rgba(46, 183, 78, 0.1)'); // 结束颜色
    ctx.fillStyle = gradient; // 填充渐变色
    ctx.fill(); // 填充扇形区域
    ctx.closePath(); // 关闭路径
    drawPoints()
    requestAnimationFrame(scanAnimation); // 递归调用
  }
  scanAnimation(); // 开始扫描动画
}
let startDrawFlag = false;
const radraInfoCallback = (res) => {
  radraInfo.value = res
  if (radraInfo.value.flightPathItems && radraInfo.value.flightPathItems.length > 0) {
    radraInfo.value.flightPathItems.forEach((flightPathItem) => {
      let {x, y} = polarToXY(flightPathItem.azimuthAngle, flightPathItem.horizontalDistance);
      flightPathItem.x = x
      flightPathItem.y = y
      flightPathItem.scanTime = radraInfo.value.uploadTime
      points.set(flightPathItem.targetId, flightPathItem);
    })
  }
  if (!startDrawFlag) {
    startDrawFlag = true;
    drawScan(radraInfo.value.startingAngle, radraInfo.value.endAngle)
  }
}
const polarToXY = (angleFromNorthDeg, distance) => {
  const theta = (90 - angleFromNorthDeg + 360) % 360;  // 转换为数学坐标角度
  const rad = theta * Math.PI / 180;
  const x = (Math.cos(rad) * distance / 15000) * (canvasWidth.value / 2);
  const y = (Math.sin(rad) * distance / 15000) * (canvasWidth.value / 2);
  return {x, y};
}
</script>
<style scoped lang="scss">
.myCanvas {
  width: 70%; /* canvas 宽度占父元素的 80% */
  height: auto; /* 高度根据宽度自适应 */
  max-width: 100%; /* 防止 canvas 超出父元素的范围 */
}

.box {
  display: inline-block;
  margin: 4px 5px;
  width: calc((100% - 20px) / 2);
  height: calc(80% - 16px);
  overflow: hidden;
}

.home {
  height: calc(100vh - 84px);
  background: #F5F9FF;
  width: 100%;
}

.cc {
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); /* 柔和阴影 */
  padding: 5px;
  font-weight: 500;
  font-size: 18px;
}
</style>
<template>
  <div class="app-container home">
    <div class="box " style="overflow: hidden">
      <div class="left1 cc">
        <div style="display: flex;align-items: center;flex: 1;">
          <el-icon style="color: #FFAA22">
            <CaretRight/>
          </el-icon>
          <span>今日鸟情概览</span>
        </div>
        <div style="flex:9;width: 100%;height: 100%" ref="todayTargetRef">
        </div>
      </div>
      <div class="left1 cc">
        <div style="display: flex;align-items: center;flex: 1;">
          <el-icon style="color: #FFAA22">
            <CaretRight/>
          </el-icon>
          <span>今日预警概览</span>
        </div>
        <div style="flex:9;width: 100%;height: 100%" ref="todayThreatRef"/>
      </div>
    </div>
    <div class="box" style="overflow: hidden">
      <div style="width: 100%;height: 100%;display: flex;flex-wrap: wrap;align-content: space-between;">
        <div class="top cc">
          <div style="display: flex;align-items: center;flex: 2;">
            <el-icon style="color: #FFAA22">
              <CaretRight/>
            </el-icon>
            <span>设备运行状态</span>
          </div>
          <div class="top-inner">
            <div>
              <span style="margin-right: 10px">雷达:</span>
              <span v-if="deviceStatus.radar === true" style="color:green;">正常</span>
              <span v-if="deviceStatus.radar === false" style="color:red;">断开</span>
            </div>
            <div>
              <span style="margin-right: 10px">光电:</span>
              <span v-if="deviceStatus.video === true" style="color:green;">正常</span>
              <span v-if="deviceStatus.video === false" style="color:red;">断开</span>
            </div>
          </div>
        </div>
        <div class="bottom cc">
          <div style="display: flex;align-items: center;margin-top: 1%">
            <el-icon style="color: #FFAA22">
              <CaretRight/>
            </el-icon>
            <span>现存目标信息</span>
          </div>
          <div style="width: 100%;height: 90%;display: flex;flex-direction: column;padding: 10px;color: #fff">
            <div style="flex: 3;width: 100%;padding: 5px">
              <div
                  style="width: 100%;height: 100%;background: #2288ff; border-radius: 5px;display: flex;justify-content: center;align-items: center">
                <div class="f2" style="margin: 0 5px">
                  目标总数
                </div>
                <div class="f1">
                  {{ nowTargetInfo.count }}
                </div>
              </div>
            </div>
            <div style="flex: 3;width: 100%;padding: 5px;display: flex;gap: 10px">
              <div
                  style="flex: 1;height: 100%;background: #0ccbcc; border-radius: 5px;display: flex;justify-content: center;align-items: center">
                <div class="f2" style="margin: 0 5px">
                  鸟
                </div>
                <div class="f1">
                  {{ nowTargetInfo.birdCount }}
                </div>
              </div>
              <div
                  style="flex: 1;height: 100%;background: #0ccbcc; border-radius: 5px;display: flex;justify-content: center;align-items: center">
                <div class="f2" style="margin: 0 5px">
                  无人机
                </div>
                <div class="f1">
                  {{ nowTargetInfo.uavCount }}
                </div>
              </div>
            </div>
            <div style="flex: 4;width: 100%;padding: 5px;display: flex;gap: 10px">
              <div
                  style="flex: 1;height: 100%;background: #f08d56; border-radius: 5px;display: flex;flex-direction: column;justify-content: center;align-items: center">
                <div class="f1">
                  {{ nowTargetInfo.level1Count }}
                </div>
                <div class="f2">
                  Ⅰ级
                </div>
              </div>
              <div
                  style="flex: 1;height: 100%;background: #f08d56; border-radius: 5px;display: flex;flex-direction: column;justify-content: center;align-items: center">
                <div class="f1">
                  {{ nowTargetInfo.level2Count }}
                </div>
                <div class="f2">
                  Ⅱ级
                </div>
              </div>
              <div
                  style="flex: 1;height: 100%;background: #f08d56; border-radius: 5px;display: flex;flex-direction: column;justify-content: center;align-items: center">
                <div class="f1">
                  {{ nowTargetInfo.level3Count }}
                </div>
                <div class="f2">
                  Ⅲ级
                </div>
              </div>
              <div
                  style="flex: 1;height: 100%;background: #f08d56; border-radius: 5px;display: flex;flex-direction: column;justify-content: center;align-items: center">
                <div class="f1">
                  {{ nowTargetInfo.level4Count }}
                </div>
                <div class="f2">
                  Ⅳ级
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="box cc">
      <div style="display: flex;align-items: center;margin-top: 1%">
        <el-icon style="color: #FFAA22">
          <CaretRight/>
        </el-icon>
        <span>鸟情小时趋势图</span>
      </div>
      <div style="width: 100%;height: 90%;" ref="ref1"></div>
    </div>
    <div class="box cc">
      <div style="display: flex;align-items: center;margin-top: 1%">
        <el-icon style="color: #FFAA22">
          <CaretRight/>
        </el-icon>
        <span>威胁小时趋势图</span>
      </div>
      <div style="width: 100%;height: 90%;" ref="ref2"></div>
    </div>
  </div>
</template>

<script setup name="Index">
import {getDeviceStatus, getHourTargetInfo, getTodayTargetInfo, getNowTargetInfo} from "@/api/radar/hourReport.js";
import * as echarts from 'echarts';

const nowTargetInfo = ref({})
const deviceStatus = ref({})
const todayTargetInfo = ref({})
const hourTargetInfo = ref({})
const todayTargetRef = ref()
const todayThreatRef = ref()
const ref1 = ref()
const ref2 = ref()
let intervalId;
onMounted(() => {
  runTasks()
  intervalId = window.setInterval(() => {
    runTasks()
  }, 3000)
  const eventSource = new EventSource(import.meta.env.VITE_APP_BASE_API +"/hourReport/getScreenInfo");
  eventSource.onmessage = function(event) {
    console.log(event)
  };
})
onBeforeUnmount(() => {
  clearInterval(intervalId)
})

function runTasks() {
  getDeviceStatus1()
  getTodayTargetInfo1()
  getHourTargetInfo1()
  getNowTargetInfo1()
}

const getDeviceStatus1 = () => {
  getDeviceStatus().then(res => {
    deviceStatus.value = res.data
  })
}
const getNowTargetInfo1 = () => {
  getNowTargetInfo().then(res => {
    nowTargetInfo.value = res.data
  })
}
const getTodayTargetInfo1 = () => {
  getTodayTargetInfo().then(res => {
    todayTargetInfo.value = res.data
    let myChart;
    let myChart1;
    if (echarts.getInstanceByDom(todayTargetRef.value)) {
      myChart = echarts.getInstanceByDom(todayTargetRef.value);
    } else {
      myChart = echarts.init(todayTargetRef.value);
    }
    if (echarts.getInstanceByDom(todayThreatRef.value)) {
      myChart1 = echarts.getInstanceByDom(todayThreatRef.value);
    } else {
      myChart1 = echarts.init(todayThreatRef.value);
    }
    let option = {
      tooltip: {
        trigger: 'item'
      },
      graphic: {
        type: 'group',
        left: 'center',
        top: 10,
        children: [
          {
            type: 'text',
            left: 'center',
            style: {
              text: `鸟：${todayTargetInfo.value.birdCount}`,
              fontSize: 14
            }
          },
          {
            type: 'text',
            top: 20,
            left: 'center',
            style: {
              text: `无人机：${todayTargetInfo.value.uavCount}`,
              fontSize: 14
            }
          },
          {
            type: 'text',
            top: 40,
            left: 'center',
            style: {
              text: `总数：${Number(todayTargetInfo.value.birdCount) + Number(todayTargetInfo.value.uavCount)}`,
              fontSize: 14
            }
          },
        ]
      },
      series: [
        {
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['50%', '70%'],
          // adjust the start and end angle
          startAngle: 180,
          endAngle: 360,
          data: [
            // {value: todayTargetInfo.value.birdCount, name: '鸟'},
            // {value: todayTargetInfo.value.uavCount, name: '无人机'},
            {value: 5, name: '鸟'},
            {value: 10, name: '无人机'},
          ],
          label: {},
        }
      ]
    }
    myChart.setOption(option);
    let option1 = {
      xAxis: {
        type: 'category',
        data: ['Ⅰ级', 'Ⅱ级', 'Ⅲ级', 'Ⅳ级']
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          showBackground: true,
          // data: [todayTargetInfo.value.level1Count, todayTargetInfo.value.level2Count,
          //   todayTargetInfo.value.level3Count, todayTargetInfo.value.level4Count],
          data: [5, 6, 8, 12],
          type: 'bar',
          label: {
            show: true, // 显示标签
            position: 'top', // 标签位置：top（柱顶）、inside（柱内）等
            color: '#333', // 标签文字颜色
            fontSize: 12 // 标签文字大小
          }
        }
      ]
    };
    myChart1.setOption(option1);
  })
}
const getHourTargetInfo1 = async () => {
  getHourTargetInfo().then(res => {
    hourTargetInfo.value = res.data
    let xarr = []
    let birdarr = []
    let uavarr = []
    let l1arr = []
    let l2arr = []
    let l3arr = []
    let l4arr = []
    if (hourTargetInfo.value && hourTargetInfo.value.length > 0) {
      hourTargetInfo.value.forEach(item => {
        xarr.push(getHourText(item.reportTime))
        birdarr.push(item.birdCount)
        uavarr.push(item.uavCount)
        l1arr.push(item.count1)
        l2arr.push(item.count2)
        l3arr.push(item.count3)
        l4arr.push(item.count4)
      })
    }
    let myChart;
    let myChart1;

    if (echarts.getInstanceByDom(ref1.value)) {
      myChart = echarts.getInstanceByDom(ref1.value);
    } else {
      myChart = echarts.init(ref1.value);
    }
    if (echarts.getInstanceByDom(ref2.value)) {
      myChart1 = echarts.getInstanceByDom(ref2.value);
    } else {
      myChart1 = echarts.init(ref2.value);
    }
    let option = {
      legend: {
        data: ['鸟', '无人机']
      },
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: xarr
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: '鸟',
          type: 'line',
          stack: 'Total',
          data: birdarr
        },
        {
          name: '无人机',
          type: 'line',
          stack: 'Total',
          data: uavarr
        },
      ]
    }
    myChart.setOption(option);

    let option1 = {
      legend: {
        data: ['Ⅰ级', 'Ⅱ级', 'Ⅲ级', 'Ⅳ级']
      },
      tooltip: {
        trigger: 'axis'
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: xarr
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: 'Ⅳ级',
          type: 'line',
          data: l4arr
        },
        {
          name: 'Ⅲ级',
          type: 'line',
          data: l3arr
        }, {
          name: 'Ⅱ级',
          type: 'line',
          data: l2arr
        }, {
          name: 'Ⅰ级',
          type: 'line',
          data: l1arr
        }
      ]
    }
    myChart1.setOption(option1);
  })
}

function getHourText(datetimeStr) {
  const date = new Date(datetimeStr.replace(/-/g, '/')); // 替换是为了兼容某些浏览器
  const hour = date.getHours();
  return `${hour}点`;
}
</script>

<style scoped lang="scss">
.box {
  display: inline-block;
  margin: 4px 5px;
  width: calc((100% - 20px) / 2);
  height: calc((100% - 16px) / 2);
}

.home {
  height: calc(100vh - 84px);
  background: #F5F9FF;
  width: 100%;
}

.top {
  width: 100%;
  height: calc((100% - 10px) * 0.1);
  margin-bottom: 10px;
  display: flex;
  justify-content: flex-start; /* 水平居中 */
  align-items: center; /* 垂直居中 */
  gap: 20px; /* 可选：控制 span 之间的间距 */
}

.bottom {
  width: 100%;
  height: calc((100% - 10px) * 0.9);
}

.left1 {
  display: inline-block;
  width: calc((100% - 20px) / 2);
  height: 100%;
  margin: 0 5px;
}

.cc {
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); /* 柔和阴影 */
  padding: 5px;
  font-weight: 500;
  font-size: 18px;
}

.top-inner {
  flex: 7;
  display: flex;
  justify-content: space-around; /* 水平居中 */
  align-items: center; /* 垂直居中 */
  gap: 20px; /* 可选：控制 span 之间的间距 */
}

.left-inner {
  flex: 1;
  display: flex;
  justify-content: space-around; /* 水平居中 */
  align-items: center; /* 垂直居中 */
  gap: 20px; /* 可选：控制 span 之间的间距 */
}

.f1 {
  font-weight: 600;
  font-size: 20px;
  line-height: 28px;
}

.f2 {
  font-size: 18px;
  line-height: 28px;
}
</style>


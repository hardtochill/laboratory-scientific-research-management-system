<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="等级" prop="threatLevel">
        <el-select v-model="queryParams.threatLevel" placeholder="等级" clearable style="width: 200px">
          <el-option
              v-for="dict in threat_level"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="雷达类型" prop="targetType">
        <el-select v-model="queryParams.targetType" placeholder="雷达类型" clearable style="width: 200px">
          <el-option
              v-for="dict in target_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button type="danger" icon="close" @click="handleDelVideoOnTimePeriod">批量删除录像</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="dataList">
      <el-table-column type="index" width="40"/>
      <el-table-column label="威胁等级" align="center">
        <template #default="scope">
          <dict-tag :options="threat_level" :value="scope.row.threatLevel"/>
        </template>
      </el-table-column>
      <el-table-column label="雷达推断类型" align="center">
        <template #default="scope">
          <dict-tag :options="target_type" :value="scope.row.targetType"/>
        </template>
      </el-table-column>
      <el-table-column label="视频推断类型" align="center">
        <template #default="scope">
          <dict-tag :options="target_type" :value="scope.row.targetTypePy"/>
        </template>
      </el-table-column>
      <el-table-column prop="appearanceTime" label="出现时间" align="center" width="160"/>
      <el-table-column prop="disappearanceTime" label="消失时间" align="center" width="160"/>
      <el-table-column prop="minHorizontalDistance" label="最小水平距离(m)" align="center"/>
      <el-table-column prop="minAxialDistance" label="最小轴向距离(m)" align="center"/>
      <el-table-column prop="rcs" label="最大rcs(m²)" align="center"/>
      <el-table-column prop="pathCount" label="点迹数量" align="center"/>
      <el-table-column label="操作" width="250" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="VideoPlay" v-if="scope.row.videoAddress"
                     @click="handleVideoPlay(scope.row)">播放录像
          </el-button>
          <el-button link type="danger" icon="close" v-if="scope.row.videoAddress"
                     @click="handleDelVideo(scope.row)">删除录像
          </el-button>
          <el-button link type="success" icon="View" @click="handleDetails(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
    />
    <el-dialog title="鸟情历史详情" v-model="open" width="80%" append-to-body>
      <el-descriptions
          :column="3"
          border
      >
        <el-descriptions-item label="威胁等级">
          <dict-tag :options="threat_level" :value="detailsData.threatLevel"/>
        </el-descriptions-item>
        <el-descriptions-item label="雷达推断类型">
          <dict-tag :options="target_type" :value="detailsData.targetType"/>
        </el-descriptions-item>
        <el-descriptions-item label="视频推断类型">
          <dict-tag :options="target_type" :value="detailsData.targetTypePy"/>
        </el-descriptions-item>
        <el-descriptions-item label="出现时间">{{ detailsData.appearanceTime }}</el-descriptions-item>
        <el-descriptions-item label="消失时间">{{ detailsData.disappearanceTime }}</el-descriptions-item>
        <el-descriptions-item label="最小水平距离(m)">{{ detailsData.minHorizontalDistance }}</el-descriptions-item>
        <el-descriptions-item label="最小轴向距离(m)">{{ detailsData.minAxialDistance }}</el-descriptions-item>
        <el-descriptions-item label="最大rcs(m²)">{{ detailsData.rcs }}</el-descriptions-item>
        <el-descriptions-item label="点迹数量">{{ detailsData.pathCount }}</el-descriptions-item>
      </el-descriptions>
      <div class="tip">航迹信息</div>
      <el-table v-loading="loading" :data="detailsData.targetInfoPaths">
        <el-table-column prop="scanTime" label="扫描时间" align="center" width="200"/>
        <el-table-column prop="rcs" label="rcs(m²)" align="center"/>
        <el-table-column label="目标类型" align="center">
          <template #default="scope">
            <dict-tag :options="target_type" :value="scope.row.targetType"/>
          </template>
        </el-table-column>
        <el-table-column prop="horizontalDistance" label="水平距离(m)" align="center"/>
        <el-table-column prop="axialDistance" label="轴向距离(m)" align="center"/>
        <el-table-column prop="azimuthAngle" label="方位角(°)" align="center"/>
        <el-table-column prop="snr" label="信噪比(dB)" align="center"/>
<!--        <el-table-column prop="x" label="x(m)" align="center"/>-->
<!--        <el-table-column prop="y" label="y(m)" align="center"/>-->
        <el-table-column prop="z" label="z(m)" align="center"/>
<!--        <el-table-column prop="xk" label="预测x(m)" align="center"/>-->
<!--        <el-table-column prop="yk" label="预测y(m)" align="center"/>-->
<!--        <el-table-column prop="zk" label="预测z(m)" align="center"/>-->
      </el-table>
    </el-dialog>
    <el-dialog title="播放回放视频" v-model="videoOpen" width="60%" append-to-body>
      <video
          v-if="videoOpen"
          ref="videoPlayer"
          :src="videoUrl"
          controls
          autoplay
          loop
          width="100%"/>
    </el-dialog>
    <el-dialog title="选择删除的时间段" v-model="videoTimePeriodOpen" width="500" append-to-body>
      <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD hh:mm:ss" type="datetimerange" range-separator="-"
                      start-placeholder="开始时间" end-placeholder="结束时间"></el-date-picker>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitDelVideoByTime">确 定</el-button>
          <el-button @click="videoTimePeriodOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>
<script setup>
import {
  listTargetInfo,
  getTargetInfo,
  delVideoByUrl,
  delVideoByTimePeriod,
} from "@/api/radar/targetInfo.js"
import {delThreatLevel} from "@/api/radar/threat_level.js";

const dateRange = ref([])
const detailsData = ref({})
const loading = ref(false)
const {proxy} = getCurrentInstance()
const {threat_level, target_type} = proxy.useDict("threat_level", "target_type")
const total = ref(0)
const dataList = ref([])
const showSearch = ref(true)
const open = ref(false)
const videoOpen = ref(false)
const videoUrl = ref('')
const videoTimePeriodOpen = ref(false)
const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  threatLevel: undefined,
  targetType: undefined,
})
onMounted(() => {
  getList()
})

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef")
  handleQuery()
}

function handleVideoPlay(row) {
  videoOpen.value = true
  videoUrl.value = import.meta.env.VITE_VIDEO_BASE_API + row.videoAddress
  //videoUrl.value = 'https://www.w3schools.com/html/mov_bbb.mp4'
}

function handleDetails(row) {
  getTargetInfo(row.id).then(res => {
    detailsData.value = res.data
    open.value = true
  })
}

function handleDelVideo(row) {
  proxy.$modal.confirm('是否确认删除？').then(function () {
    return delVideoByUrl({
      id: row.id,
      url: row.videoAddress
    })
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  })
}

function submitDelVideoByTime() {
  if (!dateRange.value || dateRange.value.length < 2) {
    proxy.$modal.msgError("未选择时间段")
    return
  }
  delVideoByTimePeriod({
    startTime: dateRange.value[0],
    endTime: dateRange.value[1]
  }).then(res => {
    proxy.$modal.msgSuccess("删除成功")
    getList()
  })
}

function handleDelVideoOnTimePeriod() {
  dateRange.value = []
  videoTimePeriodOpen.value = true
}

const getList = () => {
  loading.value = true
  listTargetInfo(queryParams.value).then(response => {
    const data = response.data
    dataList.value = data.rows
    total.value = data.total
    loading.value = false
  })
}
</script>
<style scoped lang="scss">
.tip {
  padding: 2px 16px;
  background-color: #ecf8ff;
  border-radius: 4px;
  border-left: 5px solid #50bfff;
  margin: 10px 0;
  line-height: 25px;
  font-size: 15px;
  font-weight: 500;
}
</style>
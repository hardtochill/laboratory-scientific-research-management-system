<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
    </el-form>
    <el-table v-loading="loading" :data="dataList">
      <el-table-column type="index" width="40"/>
      <el-table-column label="时间" align="center" width="180">
        <template #default="scope">
          {{ subData(scope.row.startDate) }} - {{ subData(scope.row.endDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="birdCount" label="鸟出现次数" align="center"/>
      <el-table-column prop="uavCount" label="无人机出现次数" align="center"/>
      <el-table-column prop="count1" label="Ⅰ级威胁数量" align="center"/>
      <el-table-column prop="count2" label="Ⅱ级威胁数量" align="center"/>
      <el-table-column prop="count3" label="‌Ⅲ级威胁数量" align="center"/>
      <el-table-column prop="count4" label="Ⅳ级威胁数量" align="center"/>
      <el-table-column label="操作" width="250" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="success" icon="View" @click="handleDetails(scope.row)">详情</el-button>
          <el-button link type="primary" icon="Download" @click="handleExport(scope.row)">导出</el-button>
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
    <el-dialog title="详情" v-model="open" width="80%" append-to-body>
      <el-descriptions
          :column="3"
          border
      >
        <el-descriptions-item label="时间" :span=3>
          {{ subData(detailsData.startDate) }} - {{ subData(detailsData.endDate) }}
        </el-descriptions-item>
        <el-descriptions-item label="鸟出现次数">{{ detailsData.birdCount }}</el-descriptions-item>
        <el-descriptions-item label="无人机出现次数">{{ detailsData.uavCount }}</el-descriptions-item>
        <el-descriptions-item label="Ⅰ级威胁数量">{{ detailsData.count1 }}</el-descriptions-item>
        <el-descriptions-item label="Ⅱ级威胁数量">{{ detailsData.count2 }}</el-descriptions-item>
        <el-descriptions-item label="Ⅲ级威胁数量">{{ detailsData.count3 }}</el-descriptions-item>
        <el-descriptions-item label="Ⅳ级威胁数量">{{ detailsData.count4 }}</el-descriptions-item>
      </el-descriptions>
      <div class="tip">时段数据</div>
      <el-table v-loading="loading" :data="detailsData.weeklyReportTimeList">
        <el-table-column prop="hour" label="小时" align="center">
          <template #default="scope">
            {{ getHourRange(scope.row.hour) }}
          </template>
        </el-table-column>
        <el-table-column prop="birdCount" label="鸟出现次数" align="center"/>
        <el-table-column prop="uavCount" label="无人机出现次数" align="center"/>
        <el-table-column prop="count1" label="Ⅰ级威胁数量" align="center"/>
        <el-table-column prop="count2" label="Ⅱ级威胁数量" align="center"/>
        <el-table-column prop="count3" label="‌Ⅲ级威胁数量" align="center"/>
        <el-table-column prop="count4" label="Ⅳ级威胁数量" align="center"/>
      </el-table>
    </el-dialog>
  </div>
</template>
<script setup>
import {getWeeklyReport, listWeeklyReport} from "@/api/radar/weeklyReport.js";

const {proxy} = getCurrentInstance()
const open = ref(false);
const showSearch = ref(true);
const total = ref(0)
const detailsData = ref({})
const loading = ref(false)
const dataList = ref([])
const queryParams = ref({
  pageNum: 1,
  pageSize: 10,
  threatLevel: undefined,
  targetType: undefined,
})
onMounted(() => {
  getList()
})
const subData = (str) => {
  return str.split(" ")[0];
}
const getList = () => {
  loading.value = true
  listWeeklyReport(queryParams.value).then(response => {
    const data = response.data
    dataList.value = data.rows
    total.value = data.total
    loading.value = false
  })
}

function handleDetails(row) {
  getWeeklyReport(row.id).then(res => {
    detailsData.value = res.data
    open.value = true
  })
}

function handleExport(row) {
  proxy.download("weeklyReport/export", {
    id: row.id,
  }, `鸟情周报_${subData(row.startDate)}.xlsx`)
}

function getHourRange(hour) {
  return `${hour}:00-${hour + 1}:00`;
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
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="等级" prop="level">
        <el-select v-model="queryParams.level" placeholder="等级" clearable style="width: 200px">
          <el-option
              v-for="dict in threat_level"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        <el-button type="primary" plain icon="Plus" @click="handleAdd">新增</el-button>
      </el-form-item>
    </el-form>
    <el-table v-loading="loading" :data="dataList">
      <el-table-column type="index" width="40"/>
      <el-table-column label="等级" align="center">
        <template #default="scope">
          <dict-tag :options="threat_level" :value="scope.row.level"/>
        </template>
      </el-table-column>
      <el-table-column label="目标类型" align="center">
        <template #default="scope">
          <dict-tag :options="target_type" :value="scope.row.targetType"/>
        </template>
      </el-table-column>
      <el-table-column label="距离(m)" align="center" prop="distance">
        <template #default="scope">
          {{ scope.row.startDistance }} - {{ scope.row.endDistance }}
        </template>
      </el-table-column>
      <el-table-column label="rcs大小(m²)" align="center" prop="rcs">
        <template #default="scope">
          {{ scope.row.startRcs }} - {{ scope.row.endRcs }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
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
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="levelRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="等级" prop="level">
          <el-select v-model="form.level" clearable>
            <el-option
                v-for="dict in threat_level"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="目标类型" prop="targetType">
          <el-select v-model="form.targetType" clearable>
            <el-option
                v-for="dict in target_type"
                :key="dict.value"
                :label="dict.label"
                :value="dict.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="距离下限" prop="startDistance">
          <el-input-number v-model="form.startDistance" :min="0">
            <template #suffix>
              <span>m</span>
            </template>
          </el-input-number>
        </el-form-item>
        <el-form-item label="距离上限" prop="endDistance">
          <el-input-number v-model="form.endDistance" :min="0">
            <template #suffix>
              <span>m</span>
            </template>
          </el-input-number>
        </el-form-item>
        <el-form-item label="rcs下限" prop="startRcs">
          <el-input-number v-model="form.startRcs" :min="0">
            <template #suffix>
              <span>m²</span>
            </template>
          </el-input-number>
        </el-form-item>
        <el-form-item label="rcs上限" prop="endRcs" :min="0">
          <el-input-number v-model="form.endRcs">
            <template #suffix>
              <span>m²</span>
            </template>
          </el-input-number>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>

</template>
<script setup>
import {
  listThreatLevel,
  getThreatLevel,
  addThreatLevel,
  updateThreatLevel,
  delThreatLevel
} from "@/api/radar/threat_level"

const {proxy} = getCurrentInstance()
const {threat_level, target_type} = proxy.useDict("threat_level", "target_type")
const title = ref("")
const total = ref(0)
const loading = ref(false);
const dataList = ref([]);

const showSearch = ref(true)
const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    level: undefined,
  },
  rules: {
    level: [{required: true, message: "不能为空", trigger: "blur"}],
    targetType: [{required: true, message: "不能为空", trigger: "blur"}],
    startDistance: [{required: true, message: "不能为空", trigger: "blur"}],
    endDistance: [{required: true, message: "不能为空", trigger: "blur"}],
    startRcs: [{required: true, message: "不能为空", trigger: "blur"}],
    endRcs: [{required: true, message: "不能为空", trigger: "blur"}],
  }
})
const open = ref(false);
const {queryParams, form, rules} = toRefs(data)
onMounted(() => {
  getList()
})

function submitForm() {
  proxy.$refs["levelRef"].validate(valid => {
    if (valid) {
      if (form.value.id) {
        updateThreatLevel(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功")
          open.value = false
          getList()
        })
      } else {
        addThreatLevel(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功")
          open.value = false
          getList()
        })
      }
    }
  })
}

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

function cancel() {
  open.value = false
  reset()
}

const handleUpdate = (row) => {
  getThreatLevel(row.id).then(response => {
    form.value = response.data
    open.value = true
    title.value = "修改威胁等级"
  })
}
const handleDelete = (row) => {
  proxy.$modal.confirm('是否确认删除？').then(function () {
    return delThreatLevel(row.id)
  }).then(() => {
    getList()
    proxy.$modal.msgSuccess("删除成功")
  })
}
const getList = () => {
  loading.value = true
  listThreatLevel(queryParams.value).then(response => {
    const data = response.data
    dataList.value = data.rows
    total.value = data.total
    loading.value = false
  })
}
const handleAdd = () => {
  reset()
  open.value = true
  title.value = "新增威胁等级"
}

function reset() {
  form.value = {
    id: undefined,
    level: undefined,
    targetType: undefined,
    startDistance: undefined,
    endDistance: undefined,
    startRcs: undefined,
    endRcs: undefined
  }
  proxy.resetForm("levelRef")
}
</script>
<style scoped lang="scss">

</style>
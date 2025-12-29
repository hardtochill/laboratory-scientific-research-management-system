<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="80px">
      <el-form-item label="文献名称" prop="title">
        <el-input v-model="queryParams.title" placeholder="请输入文献名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="关键词">
        <el-select v-model="selectedKeywords" multiple filterable remote placeholder="请选择关键词" :remote-method="remoteMethod" :loading="keywordLoading" style="width: 240px">
          <el-option v-for="item in keywordOptions" :key="item.id" :label="item.keywordName" :value="item.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="发表时间" style="width: 308px">
        <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Upload" @click="handleUpload">上传文献</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" :columns="columns"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="literatureList" @selection-change="handleSelectionChange" @sort-change="handleSortChange">
      <!-- <el-table-column type="selection" width="50" align="center" /> -->
       <el-table-column type="index" width="50" align="center" />
      <el-table-column label="文献名称" width="200" align="center" prop="title" v-if="columns[0].visible" :show-overflow-tooltip="true">
        <template #default="scope">
          <span>{{ scope.row.title }}</span>
        </template>
      </el-table-column>
      <el-table-column label="关键词" align="center" v-if="columns[1].visible" width="200" :show-overflow-tooltip="true">
        <template #default="scope">
          <!-- <div class="keyword-tags">
            <el-tag v-for="keyword in scope.row.keywords" :key="keyword.id" size="small" style="margin-right: 4px">{{ keyword.keywordName }}</el-tag>
          </div> -->
          <span>{{ scope.row.keywords }}</span>
        </template>
      </el-table-column>
      <el-table-column label="作者" align="center" prop="authors" v-if="columns[2].visible" width="150" :show-overflow-tooltip="true" />
      <el-table-column label="来源" align="center" prop="journal" v-if="columns[3].visible" width="150" :show-overflow-tooltip="true" />
      <el-table-column label="发表时间" align="center" prop="publishTime" v-if="columns[4].visible" width="160" :sortable="true">
        <template #default="scope">
          <span>{{ parseTime(scope.row.publishTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="下载数" align="center" prop="downloadCount" v-if="columns[5].visible" width="100" :sortable="true" />
      <el-table-column label="评分" align="center" prop="finalScore" v-if="columns[6].visible" width="100" :sortable="true">
        <template #default="scope">
          <span>{{ scope.row.finalScore }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" align="center" width="200" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-tooltip content="详情" placement="top">
            <el-button link type="primary" icon="Document" @click="handleDetail(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="评分" placement="top">
            <el-button link type="primary" icon="Star" @click="handleScore(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="修改文献信息" placement="top">
            <el-button link type="primary" icon="Edit" @click="handleEdit(scope.row)"></el-button>
          </el-tooltip>
          <el-tooltip content="下载" placement="top">
            <el-button link type="primary" icon="Download" @click="handleDownload(scope.row)"></el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <!-- 评分对话框 -->
    <el-dialog :title="'评分文献：' + scoreForm.title" v-model="scoreOpen" width="400px" append-to-body>
      <el-form :model="scoreForm" :rules="scoreRules" ref="scoreRef" label-width="80px">
        <el-form-item label="评分" prop="score">
          <el-rate v-model="scoreForm.score" :max="10" show-score />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitScore">确 定</el-button>
          <el-button @click="cancelScore">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 编辑文献对话框 -->
    <el-dialog :title="'编辑文献：' + editForm.title" v-model="editOpen" width="600px" append-to-body>
      <el-form :model="editForm" :rules="editRules" ref="editRef" label-width="100px">
        <el-form-item label="文献名称" prop="title">
          <el-input v-model="editForm.title" placeholder="请输入文献名称" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="文献作者" prop="authors">
          <el-input v-model="editForm.authors" placeholder="多个作者请用逗号分隔" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="文献来源" prop="journal">
          <el-input v-model="editForm.journal" placeholder="请输入文献来源" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="发表时间" prop="publishTime">
          <el-date-picker v-model="editForm.publishTime" type="date" value-format="YYYY-MM-DD" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="文献摘要" prop="abstract">
          <el-input v-model="editForm.abstract" type="textarea" placeholder="请输入文献摘要" :rows="3" maxlength="1000" show-word-limit />
        </el-form-item>
        <el-form-item label="关键词" prop="keywordIds">
          <el-select v-model="editForm.keywordIds" multiple filterable remote placeholder="请选择关键词" :remote-method="remoteMethod" :loading="keywordLoading" style="width: 100%">
            <el-option v-for="item in keywordOptions" :key="item.id" :label="item.keywordName" :value="item.id" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitEdit">确 定</el-button>
          <el-button @click="cancelEdit">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 上传文献对话框 -->
    <el-dialog title="上传文献" v-model="uploadOpen" width="600px" append-to-body>
      <el-form :model="uploadForm" :rules="uploadRules" ref="uploadRef" label-width="100px" enctype="multipart/form-data">
        <el-form-item label="文献名称" prop="title">
          <el-input v-model="uploadForm.title" placeholder="请输入文献名称" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="文献作者" prop="authors">
          <el-input v-model="uploadForm.authors" placeholder="多个作者请用逗号分隔" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="文献来源" prop="journal">
          <el-input v-model="uploadForm.journal" placeholder="请输入文献来源" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item label="发表时间" prop="publishTime">
          <el-date-picker v-model="uploadForm.publishTime" type="date" value-format="YYYY-MM-DD" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="文献摘要" prop="abstract">
          <el-input v-model="uploadForm.abstract" type="textarea" placeholder="请输入文献摘要" :rows="3" maxlength="1000" show-word-limit />
        </el-form-item>
        <el-form-item label="关键词" prop="keywordIds">
          <el-select v-model="uploadForm.keywordIds" multiple filterable remote placeholder="请选择关键词" :remote-method="remoteMethod" :loading="keywordLoading" style="width: 100%">
            <el-option v-for="item in keywordOptions" :key="item.id" :label="item.keywordName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="文献文件" prop="file">
          <el-upload ref="fileUpload" :file-list="fileList" :limit="1" :on-exceed="onExceed" :on-change="onChange" :on-remove="onRemove" :auto-upload="false" drag>
            <el-icon class="el-icon--upload" style="height: 5px;">
              <upload-filled />
            </el-icon>
            <div class="el-upload__text">
              将PDF文件拖到此处，或<em>点击上传</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">
                仅支持PDF格式，文件大小不超过50MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitUpload">确 定</el-button>
          <el-button @click="cancelUpload">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="LiteratureManagement">
import { listLiterature, addLiterature, scoreLiterature, updateLiterature, getLiteratureDetail } from "@/api/literature/literatureManagement"
import { download } from "@/utils/request"
import { parseTime } from "@/utils/ruoyi"
import { useRouter } from "vue-router"
import { ref, reactive, toRefs, onMounted } from "vue"
import { getCurrentInstance } from "vue"
import { listKeyword } from "@/api/keyword/keyword"
import { UploadFilled } from "@element-plus/icons-vue"

const router = useRouter()
const { proxy } = getCurrentInstance()

const literatureList = ref([])
  const uploadOpen = ref(false)
  const editOpen = ref(false)
  const scoreOpen = ref(false)
  const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const dateRange = ref([])
const keywordOptions = ref([])
const selectedKeywords = ref([])
const keywordLoading = ref(false)
const fileList = ref([])

// 列显隐信息
const columns = ref([
  { key: 0, label: `文献名称`, visible: true },
  { key: 1, label: `关键词`, visible: true },
  { key: 2, label: `作者`, visible: true },
  { key: 3, label: `来源`, visible: true },
  { key: 4, label: `发表时间`, visible: true },
  { key: 5, label: `下载数`, visible: true },
  { key: 6, label: `评分`, visible: true }
])

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    title: undefined,
    keywordIds: [],
    sortField: undefined,
    sortOrder: undefined
  },
  scoreForm: {
    id: undefined,
    title: undefined,
    score: undefined
  },
  scoreRules: {
    score: [{ required: true, message: "请输入评分", trigger: "change" }]
  },
  editForm: {
    id: undefined,
    title: undefined,
    authors: undefined,
    journal: undefined,
    abstract: undefined,
    keywordIds: []
  },
  editRules: {
    title: [{ required: true, message: "请输入文献名称", trigger: "blur" }]
  },
  uploadForm: {
    title: undefined,
    authors: undefined,
    journal: undefined,
    publishTime: undefined,
    abstract: undefined,
    keywordIds: [],
    file: undefined
  },
  uploadRules: {
    title: [{ required: true, message: "请输入文献名称", trigger: "blur" }],
    file: [{ 
      validator: (rule, value, callback) => {
        if (!uploadForm.value.file) {
          callback(new Error('请上传文献文件'))
        } else {
          callback()
        }
      }, 
      trigger: 'change' 
    }]
  }
})

const { queryParams, scoreForm, scoreRules, editForm, editRules, uploadForm, uploadRules } = toRefs(data)

/** 查询文献列表 */
function getList() {
  loading.value = true
  const params = { ...queryParams.value };
    if (dateRange.value && dateRange.value.length === 2) {
      params.publishTimeStart = dateRange.value[0];
      params.publishTimeEnd = dateRange.value[1];
    }
    if (selectedKeywords.value && selectedKeywords.value.length > 0) {
      params.keywordIds = selectedKeywords.value;
    }
  listLiterature(params).then(res => {
    loading.value = false
    literatureList.value = res.rows
    total.value = res.total
  })
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = []
  selectedKeywords.value = []
  keywordOptions.value = []
  proxy.resetForm("queryRef")
  handleQuery()
}

/** 选择条数  */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id)
  single.value = selection.length != 1
  multiple.value = !selection.length
}

/** 详情按钮操作 */
function handleDetail(row) {
  router.push(`/literature/detail/${row.id}`)
}

/** 评分按钮操作 */
function handleScore(row) {
  scoreForm.value.id = row.id
  scoreForm.value.title = row.title
  scoreForm.value.score = row.score !== null ? row.score : undefined
  scoreOpen.value = true
}

/** 提交评分 */
function submitScore() {
  proxy.$refs["scoreRef"].validate((valid) => {
    if (valid) {
      scoreLiterature({
        literatureId: scoreForm.value.id,
        score: scoreForm.value.score
      }).then(() => {
        scoreOpen.value = false
        proxy.$modal.msgSuccess("评分成功")
        getList()
      })
    }
  })
}

/** 取消评分 */
function cancelScore() {
  scoreOpen.value = false
  scoreForm.value.score = undefined
}

/** 编辑按钮操作 */
async function handleEdit(row) {
  try {
    // 获取文献详情
    const response = await getLiteratureDetail(row.id)
    const literatureDetail = response.data
    
    // 填充编辑表单
    editForm.value.id = literatureDetail.id
    editForm.value.title = literatureDetail.title
    editForm.value.authors = literatureDetail.authors
    editForm.value.journal = literatureDetail.journal
    editForm.value.abstract = literatureDetail.abstractText
    editForm.value.publishTime = literatureDetail.publishTime ? parseTime(literatureDetail.publishTime, '{y}-{m}-{d}') : undefined
    
    // 处理关键词 - 先加载关键词选项
    await loadKeywordsForEdit()
    
    // 如果keywords是对象数组，提取ID
    if (literatureDetail.keywords && literatureDetail.keywords.length > 0) {
      if (typeof literatureDetail.keywords[0] === 'object') {
        // 对象数组，提取ID
        editForm.value.keywordIds = literatureDetail.keywords.map(kw => kw.id || kw.keywordId)
      } else {
        // 字符串数组，需要匹配名称到ID
        editForm.value.keywordIds = []
        literatureDetail.keywords.forEach(keywordName => {
          const matchedKeyword = keywordOptions.value.find(kw => kw.keywordName === keywordName)
          if (matchedKeyword) {
            editForm.value.keywordIds.push(matchedKeyword.id)
          }
        })
      }
    } else {
      editForm.value.keywordIds = []
    }
    
    editOpen.value = true
  } catch (error) {
    console.error('获取文献详情失败:', error)
    proxy.$modal.msgError("获取文献详情失败")
  }
}

/** 为编辑加载关键词 */
async function loadKeywordsForEdit() {
  try {
    const res = await listKeyword({})
    keywordOptions.value = res.rows
  } catch (error) {
    console.error('加载关键词失败:', error)
  }
}

/** 提交编辑 */
function submitEdit() {
  proxy.$refs["editRef"].validate((valid) => {
    if (valid) {
      updateLiterature({
        id: editForm.value.id,
        title: editForm.value.title,
        authors: editForm.value.authors,
        journal: editForm.value.journal,
        publishTime: editForm.value.publishTime,
        abstractText: editForm.value.abstract,
        keywordIds: editForm.value.keywordIds
      }).then(() => {
        editOpen.value = false
        proxy.$modal.msgSuccess("修改成功")
        getList()
      }).catch(error => {
        console.error('修改失败:', error)
        proxy.$modal.msgError(error.message || "修改失败")
      })
    }
  })
}

/** 取消编辑 */
function cancelEdit() {
  editOpen.value = false
  // 重置表单
  editForm.value = {
    id: undefined,
    title: undefined,
    authors: undefined,
    journal: undefined,
    abstract: undefined,
    keywordIds: []
  }
  proxy.resetForm("editRef")
}

/** 下载按钮操作 */
function handleDownload(row) {
  download(`/literature/download/${row.id}`, {}, `${row.title}.pdf`)
}

/** 监听表格排序 */
function handleSortChange({ column, prop, order }) {
  queryParams.value.sortField = prop
  queryParams.value.sortOrder = order === "ascending" ? "asc" : "desc"
  getList()
}

/** 上传文献按钮操作 */
function handleUpload() {
  resetUploadForm()
  uploadOpen.value = true
}

/** 重置上传表单 */
function resetUploadForm() {
  uploadForm.value = {
    title: undefined,
    authors: undefined,
    journal: undefined,
    publishTime: undefined,
    abstract: undefined,
    keywordIds: [],
    file: undefined
  }
  fileList.value = []
  proxy.resetForm("uploadRef")
}

/** 取消上传 */
function cancelUpload() {
  uploadOpen.value = false
  resetUploadForm()
}

/** 提交上传 */
async function submitUpload() {
  proxy.$refs["uploadRef"].validate(async (valid) => {
    if (valid) {
      if (!uploadForm.value.file) {
        proxy.$modal.msgError("请上传文献文件")
        return
      }
      
      try {
        const formData = new FormData()
        formData.append('title', uploadForm.value.title || '')
        formData.append('authors', uploadForm.value.authors || '')
        formData.append('journal', uploadForm.value.journal || '')
        formData.append('abstract', uploadForm.value.abstract || '')
        
        // 处理发表时间 - 只有当有值时才添加
        if (uploadForm.value.publishTime) {
          formData.append('publishTime', uploadForm.value.publishTime)
        }
        
        // 处理关键词 - 只有当有值时才添加
        if (uploadForm.value.keywordIds && uploadForm.value.keywordIds.length > 0) {
          uploadForm.value.keywordIds.forEach((id) => {
            formData.append('keywordIds', id)
          })
        }
        
        formData.append('file', uploadForm.value.file)
        
        // 调用后端的add方法
        await addLiterature(formData)
        
        uploadOpen.value = false
        fileList.value = [] // 清空文件列表
        proxy.$modal.msgSuccess("上传成功")
        getList()
      } catch (error) {
        console.error('上传失败:', error)
        proxy.$modal.msgError(error.message || "上传失败")
      }
    }
  })
}

/** 文件变化时验证 */
function onChange(file, fileList) {
  // 检查文件类型
  const isPDF = file.raw.type === 'application/pdf'
  if (!isPDF) {
    proxy.$modal.msgError('只能上传PDF文件!')
    // 移除不符合要求的文件
    fileList.splice(fileList.indexOf(file), 1)
    // 清理上传表单的文件
    uploadForm.value.file = undefined
    return false
  }
  
  // 检查文件大小 (50MB = 50 * 1024 * 1024)
  const isLt50M = file.raw.size / 1024 / 1024 < 50
  if (!isLt50M) {
    proxy.$modal.msgError('文件大小不能超过50MB!')
    // 移除不符合要求的文件
    fileList.splice(fileList.indexOf(file), 1)
    // 清理上传表单的文件
    uploadForm.value.file = undefined
    return false
  }
  
  // 校验通过，设置上传表单的文件
  uploadForm.value.file = file.raw
  
  return false // 返回false阻止自动上传，由我们手动控制
}

/** 文件删除时清理 */
function onRemove(file, fileList) {
  // 当文件被删除时，清理上传表单的文件
  if (fileList.length === 0) {
    uploadForm.value.file = undefined
  }
}

/** 超出文件数量限制时替换文件 */
function onExceed(files, fileList) {
  // 替换已上传的文件为新文件
  const newFile = files[0]
  
  // 检查新文件的类型和大小
  const isPDF = newFile.type === 'application/pdf'
  if (!isPDF) {
    proxy.$modal.msgError('只能上传PDF文件!')
    return false
  }
  
  // 检查文件大小 (50MB = 50 * 1024 * 1024)
  const isLt50M = newFile.size / 1024 / 1024 < 50
  if (!isLt50M) {
    proxy.$modal.msgError('文件大小不能超过50MB!')
    return false
  }
  
  // 替换文件列表
  fileList.splice(0, fileList.length, {
    name: newFile.name,
    size: newFile.size,
    status: 'ready',
    raw: newFile
  })
  
  // 更新响应式的fileList
  fileList.value = [...fileList]
  
  // 设置上传表单的文件
  uploadForm.value.file = newFile
  
  return false // 返回false阻止自动上传，由我们手动控制
}

/** 关键词远程搜索 */
function remoteMethod(query) {
  keywordLoading.value = true
  listKeyword({ keywordName: query }).then(res => {
    keywordLoading.value = false
    keywordOptions.value = res.rows
  })
}

/** 初始化 */
onMounted(() => {
  getList()
})
</script>

<style scoped>

</style>

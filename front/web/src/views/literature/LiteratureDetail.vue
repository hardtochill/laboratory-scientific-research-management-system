<template>
    <div class="app-container">
        <!-- 返回按钮 -->
        <div class="back-btn">
            <el-button type="primary" @click="goBack">返回列表</el-button>
        </div>
        
        <!-- 上半部分：文献内容展示 -->
        <div class="literature-content">
            <h1 class="title">{{ literature.title }}</h1>
            <div class="authors">{{ literature.authors }}</div>
            <div class="journal">{{ literature.journal }}</div>
            
            <div class="detail-info">
                <div class="info-item">
                    <span class="label">发表时间：</span>
                    <span>{{ formatDate(literature.publishTime) }}</span>
                </div>
                <div class="info-item">
                    <span class="label">摘要：</span>
                    <div class="abstract-text">{{ literature.abstractText }}</div>
                </div>
                <div class="info-item">
                    <span class="label">下载数：</span>
                    <span>{{ literature.downloadCount }}</span>
                </div>
                <div class="info-item">
                    <span class="label">评分：</span>
                    <span>{{ literature.finalScore }}</span>
                </div>
            </div>
        </div>
        
        <!-- 下半部分：心得发表区 -->
        <div class="notes-section">
            <div class="section-header">
                <h2 class="section-title">文献心得</h2>
                <div class="sort-controls">
                    <el-select v-model="sortField" placeholder="选择排序字段" size="small" @change="handleSortChange">
                        <el-option label="发表时间" value="publishTime"></el-option>
                        <el-option label="点赞数" value="likeCount"></el-option>
                    </el-select>
                    <el-select v-model="sortOrder" placeholder="选择排序方式" size="small" @change="handleSortChange">
                        <el-option label="升序" value="asc"></el-option>
                        <el-option label="降序" value="desc"></el-option>
                    </el-select>
                </div>
            </div>
            
            <!-- 心得列表 -->
            <div class="notes-list">
                <div v-for="note in notes" :key="note.id" class="note-item">
                    <div class="note-header">
                        <span class="user-nickname">{{ note.userNickName }}</span>
                        <span class="publish-time">{{ formatDate(note.publishTime) }}</span>
                    </div>
                    <div class="note-content">
                        {{ note.noteContent }}
                    </div>
                    <div class="note-footer">
                        <span class="like-count">点赞数：{{ note.likeCount }}</span>
                    </div>
                </div>
            </div>
            
            <!-- 分页 -->
            <div class="pagination">
                <el-pagination
                    v-model:current-page="pagination.currentPage"
                    v-model:page-size="pagination.pageSize"
                    :page-sizes="[10, 20, 50, 100]"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="pagination.total"
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                />
            </div>
        </div>
    </div>
</template>

<script setup name="LiteratureDetail">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from "vue-router"
import { ElMessage } from 'element-plus'
import { Top, Bottom } from '@element-plus/icons-vue'
import { getDetail, getNoteList } from '@/api/experiment/literature'

const router = useRouter()
const route = useRoute()

// 文献详情数据
const literature = ref({})

// 心得列表数据
const notes = ref([])

// 分页数据
const pagination = ref({
    currentPage: 1,
    pageSize: 10,
    total: 0
})

// 排序数据
const sortField = ref('publishTime')
const sortOrder = ref('desc')

/** 返回列表 */
function goBack() {
    router.push("/literature")
}

/** 格式化日期 */
function formatDate(dateStr) {
    if (!dateStr) return ''
    const date = new Date(dateStr)
    return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    })
}

/** 获取文献详情 */
async function getLiteratureDetail() {
    const id = route.params.id
    if (!id) {
        ElMessage.error('参数错误')
        return
    }
    
    try {
        const res = await getDetail(id)
        literature.value = res.data
    } catch (error) {
        ElMessage.error('获取文献详情失败')
        console.error('获取文献详情失败:', error)
    }
}

/** 获取心得列表 */
async function getLiteratureNotes() {
    const id = route.params.id
    if (!id) return
    
    try {
        const params = {
            literatureId: id,
            pageNum: pagination.value.currentPage,
            pageSize: pagination.value.pageSize,
            sortField: sortField.value,
            sortOrder: sortOrder.value
        }
        
        const res = await getNoteList(params)
        notes.value = res.rows
        pagination.value.total = res.total
    } catch (error) {
        ElMessage.error('获取心得列表失败')
        console.error('获取心得列表失败:', error)
    }
}

/** 分页大小变化 */
function handleSizeChange(val) {
    pagination.value.pageSize = val
    getLiteratureNotes()
}

/** 分页当前页变化 */
function handleCurrentChange(val) {
    pagination.value.currentPage = val
    getLiteratureNotes()
}

/** 排序变更处理 */
function handleSortChange() {
    // 排序变更时重置到第一页
    pagination.value.currentPage = 1
    getLiteratureNotes()
}

/** 页面加载时获取数据 */
onMounted(() => {
    getLiteratureDetail()
    getLiteratureNotes()
})
</script>

<style scoped>
.app-container {
    padding: 20px;
    max-width: 1200px;
    margin: 0 auto;
}

.back-btn {
    margin-bottom: 20px;
}

/* 上半部分：文献内容 */
.literature-content {
    margin-bottom: 40px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e0e0e0;
}

.title {
    text-align: center;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 15px;
    color: #333;
}

.authors {
    text-align: center;
    font-size: 16px;
    margin-bottom: 10px;
    color: #666;
}

.journal {
    text-align: center;
    font-size: 16px;
    margin-bottom: 20px;
    color: #666;
}

.detail-info {
    margin-top: 20px;
}

.info-item {
    margin-bottom: 15px;
}

.label {
    font-weight: bold;
    color: #333;
    margin-right: 10px;
}

.abstract-text {
    margin-top: 5px;
    padding: 10px;
    background-color: #f5f5f5;
    border-radius: 4px;
    line-height: 1.6;
}

/* 下半部分：心得列表 */
.notes-section {
    margin-top: 30px;
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.section-title {
    font-size: 20px;
    font-weight: bold;
    margin: 0;
    color: #333;
}

.sort-controls {
    display: flex;
    gap: 10px;
    align-items: center;
}

.sort-controls .el-select {
    min-width: 120px;
}

.notes-list {
    margin-bottom: 20px;
}

.note-item {
    background-color: #f9f9f9;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.note-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
    font-size: 14px;
}

.user-nickname {
    font-weight: bold;
    color: #333;
}

.publish-time {
    color: #999;
}

.note-content {
    height: 100px;
    overflow-y: auto;
    line-height: 1.6;
    margin-bottom: 10px;
    padding: 10px;
    background-color: #fff;
    border-radius: 4px;
    border: 1px solid #e0e0e0;
}

.note-footer {
    text-align: right;
    color: #666;
    font-size: 14px;
}

.like-count {
    margin-right: 10px;
}

/* 分页 */
.pagination {
    text-align: right;
    margin-top: 20px;
}
</style>
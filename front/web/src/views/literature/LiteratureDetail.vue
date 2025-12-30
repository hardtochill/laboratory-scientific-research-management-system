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
                    <span>{{ parseTime(literature.publishTime, '{y}-{m}-{d}') }}</span>
                </div>
                <div class="info-item">
                    <span class="label">摘要：</span>
                    <div class="abstract-text">{{ literature.abstractText }}</div>
                </div>
                <div class="info-item">
                    <span class="label">关键词：</span>
                    <el-tag v-for="keyword in literature.keywords" :key="keyword.id" size="medium" style="margin-right: 6px">{{ keyword.keywordName }}</el-tag>
                </div>
                <div class="info-item">
                    <span class="label">下载数：</span>
                    <span>{{ literature.downloadCount }}</span>
                </div>
                <div class="info-item">
                    <span class="label">评分：</span>
                    <span>{{ literature.finalScore }}</span>
                </div>
                <div class="info-item">
                    <span class="label">上传用户：</span>
                    <span>{{ literature.uploadUserNickName }}</span>
                </div>
            </div>
        </div>
        <!-- 下半部分：评论发表区 -->
        
    </div>
</template>

<script setup name="LiteratureDetail">
import { ref, onActivated } from 'vue'
import { useRouter, useRoute } from "vue-router"
import { ElMessage } from 'element-plus'
import SvgIcon from '@/components/SvgIcon'
import { getLiteratureDetail } from '@/api/literature/literature'
import { parseTime } from '@/utils/ruoyi'



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
    router.push("/literature/read")
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
async function getDetail() {
    const id = route.params.id
    if (!id) {
        ElMessage.error('参数错误')
        return
    }
    
    try {
        const res = await getLiteratureDetail(id)
        literature.value = res.data
    } catch (error) {
        ElMessage.error('获取文献详情失败')
        console.error('获取文献详情失败:', error)
    }
}

/** 页面加载时获取数据 */
onActivated(() => {
    getDetail()
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
    font-size: 13px;
}

.like-button {
    padding: 0;
    margin: 0;
    height: auto;
    line-height: normal;
    color: #909399;
}

.like-icon {
    font-size: 18px;
    margin-right: 4px;
    vertical-align: middle;
    cursor: pointer;
    transition: color 0.3s;
}

.like-count {
    vertical-align: middle;
}

/* 分页 */
.pagination {
    text-align: right;
    margin-top: 20px;
}
</style>
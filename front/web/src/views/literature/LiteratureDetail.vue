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
        <!-- 下半部分：评论展示区 -->
        <div class="comments-section">
            <div class="section-header">
                <h2 class="section-title">评论</h2>
                <div class="sort-controls">
                    <el-select v-model="sortField" placeholder="排序字段" style="width: 120px" @change="handleSortChange">
                        <el-option label="点赞数" value="likeCount" />
                        <el-option label="评论时间" value="commentTime" />
                    </el-select>
                    <el-select v-model="sortOrder" placeholder="排序方式" style="width: 120px" @change="handleSortChange">
                        <el-option label="升序" value="asc" />
                        <el-option label="降序" value="desc" />
                    </el-select>
                </div>
            </div>
            
            <div v-loading="commentsLoading" class="comments-list">
                <div v-for="comment in parentComments" :key="comment.id" class="comment-item">
                    <div class="comment-header">
                        <div class="user-info">
                            <span class="user-nickname">{{ comment.userNickName }}</span>
                        </div>
                        <div class="comment-time">
                            {{ formatDate(comment.commentTime) }}
                        </div>
                    </div>
                    
                    <div class="comment-main">
                        <div class="comment-content">
                            {{ comment.commentContent }}
                        </div>
                        <div class="comment-like-section">
                            <div class="like-section">
                                <svg-icon :icon-class="comment.isLiked ? 'thumbs-up' : 'thumbs-o-up'" 
                                         class="like-icon"
                                         @click="handleLike(comment)"></svg-icon>
                                <span class="like-count">{{ comment.likeCount }}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="comment-actions">
                        <span v-if="comment.hasChildComments" 
                              class="view-child-btn"
                              @click="toggleChildComments(comment.id)">
                            {{ expandedChildComments.includes(comment.id) ? '收起子评论' : '查看子评论' }}
                        </span>
                    </div>
                    
                    <div v-if="comment.commentFiles && comment.commentFiles.length > 0" class="related-files">
                        <span class="files-label">关联文件：</span>
                        <el-button v-for="file in comment.commentFiles" 
                                  :key="file.id"
                                  type="text" 
                                  class="file-link"
                                  @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                            {{ file.fileName }}.{{ file.fileType }}
                        </el-button>
                    </div>
                    
                    <!-- 子评论区域 -->
                    <div v-if="expandedChildComments.includes(comment.id)" class="child-comments">
                        <div v-if="childCommentsLoading[comment.id]" class="child-loading">
                            <el-icon class="is-loading"><loading /></el-icon>
                            加载中...
                        </div>
                        <div v-else-if="childComments[comment.id] && childComments[comment.id].length > 0">
                            <div v-for="childComment in childComments[comment.id]" 
                                 :key="childComment.id" 
                                 class="child-comment-item">
                                <div class="comment-header">
                                    <div class="user-info">
                                        <span class="user-nickname">{{ childComment.userNickName }}</span>
                                    </div>
                                    <div class="comment-time">
                                        {{ formatDate(childComment.commentTime) }}
                                    </div>
                                </div>
                                
                                <div class="comment-main">
                                    <div class="comment-content">
                                        {{ childComment.commentContent }}
                                    </div>
                                    <div class="comment-like-section">
                                        <div class="like-section">
                                            <svg-icon :icon-class="childComment.isLiked ? 'thumbs-up' : 'thumbs-o-up'" 
                                                     class="like-icon"
                                                     @click="handleLike(childComment)"></svg-icon>
                                            <span class="like-count">{{ childComment.likeCount }}</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div v-if="childComment.commentFiles && childComment.commentFiles.length > 0" class="related-files">
                                    <span class="files-label">关联文件：</span>
                                    <el-button v-for="file in childComment.commentFiles" 
                                              :key="file.id"
                                              type="text" 
                                              class="file-link"
                                              @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                                        {{ file.fileName }}.{{ file.fileType }}
                                    </el-button>
                                </div>
                            </div>
                        </div>
                        <div v-else class="no-child-comments">
                            暂无子评论
                        </div>
                    </div>
                </div>
                
                <div v-if="parentComments.length === 0 && !commentsLoading" class="no-comments">
                    暂无评论
                </div>
            </div>
            
            <!-- 评论分页 -->
            <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="handlePagination" />
        </div>
    </div>
</template>

<script setup name="LiteratureDetail">
import { ref, onActivated, onMounted } from 'vue'
import { useRouter, useRoute } from "vue-router"
import { ElMessage } from 'element-plus'
import { Loading } from '@element-plus/icons-vue'
import SvgIcon from '@/components/SvgIcon'
import { getLiteratureDetail } from '@/api/literature/literature'
import { listParentComments, listChildComments, toggleLike } from '@/api/comment/comment'
import { download } from "@/utils/request"
import { parseTime } from '@/utils/ruoyi'



const router = useRouter()
const route = useRoute()

// 文献详情数据
const literature = ref({})


// 排序数据
const sortField = ref('likeCount')  // 默认按点赞数排序
const sortOrder = ref('desc')       // 默认降序

// 分页数据
const queryParams = ref({
  pageNum: 1,
  pageSize: 10
})
const total = ref(0)

// 评论相关数据
const parentComments = ref([])
const childComments = ref({})  // { parentId: [childComments] }
const expandedChildComments = ref([])  // 已展开的父评论ID列表
const commentsLoading = ref(false)
const childCommentsLoading = ref({})  // { parentId: boolean }

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
    getParentComments()
})
onMounted(() => {
    getDetail()
    getParentComments()
})

/** 获取父评论列表 */
async function getParentComments() {
    const literatureId = route.params.id
    if (!literatureId) {
        ElMessage.error('文献ID错误')
        return
    }
    
    commentsLoading.value = true
    try {
        const res = await listParentComments(
            literatureId, 
            sortField.value, 
            sortOrder.value,
            queryParams.value.pageNum,
            queryParams.value.pageSize
        )
        parentComments.value = res.rows || []
        total.value = res.total || 0
    } catch (error) {
        ElMessage.error('获取评论失败')
        console.error('获取父评论失败:', error)
    } finally {
        commentsLoading.value = false
    }
}

/** 切换子评论显示 */
async function toggleChildComments(parentId) {
    const index = expandedChildComments.value.indexOf(parentId)
    
    if (index > -1) {
        // 收起子评论
        expandedChildComments.value.splice(index, 1)
    } else {
       // 展开子评论
        expandedChildComments.value.push(parentId)
        
        // 如果子评论还没有加载，则加载子评论
        if (!childComments.value[parentId]) {
            childCommentsLoading.value[parentId] = true
            try {
                const res = await listChildComments(parentId)
                childComments.value[parentId] = res.rows || []
            } catch (error) {
                ElMessage.error('获取子评论失败')
                console.error('获取子评论失败:', error)
            } finally {
                childCommentsLoading.value[parentId] = false
            }
        }
    }
}

/** 点赞/取消点赞 */
async function handleLike(comment) {
    try {
        const res = await toggleLike(comment.id)
        // 更新点赞状态和数量
        comment.isLiked = res.data
        comment.likeCount += comment.isLiked ? 1 : -1
    } catch (error) {
        ElMessage.error('点赞操作失败')
        console.error('点赞失败:', error)
    }
}

/** 下载文件 */
async function downloadFile(fileId, fileName) {
    download(`/commentFile/download/${fileId}`, {}, fileName)
}

/** 排序变化处理 */
function handleSortChange() {
    // 重置到第一页
    queryParams.value.pageNum = 1
    getParentComments()
}

/** 分页变化处理 */
function handlePagination() {
    getParentComments()
}
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

.user-nickname {
    font-weight: bold;
    color: #333;
}

.publish-time {
    color: #999;
}

.like-count {
    vertical-align: middle;
}

/* 分页 */
.pagination {
    text-align: right;
    margin-top: 20px;
}

/* 评论区域样式 */
.comments-section {
    margin-top: 40px;
}

.comments-list {
    min-height: 200px;
}

.comment-item {
    background-color: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.user-info .user-nickname {
    font-weight: bold;
    color: #333;
    font-size: 16px;
}

.comment-time {
    color: #999;
    font-size: 14px;
}

.comment-main {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 15px;
}

.comment-content {
    flex: 1;
    line-height: 1.6;
    color: #333;
    font-size: 15px;
    margin-right: 20px;
}

.comment-like-section {
    display: flex;
    align-items: center;
}

.like-section {
    display: flex;
    align-items: center;
    gap: 8px;
}

.like-icon {
    font-size: 22px;
    cursor: pointer;
    transition: all 0.3s ease;
    color: #606266;
    padding: 2px;
    border-radius: 4px;
    margin-right: -6px;
}

.like-icon:hover {
    color: #409eff;
    background-color: rgba(64, 158, 255, 0.1);
    transform: scale(1.1);
}

.like-icon:active {
    color: #3078c6;
    transform: scale(0.95);
}

.like-count {
    font-size: 14px;
    color: #666;
}

.view-child-btn {
    color: #409eff;
    cursor: pointer;
    font-size: 14px;
}

.view-child-btn:hover {
    text-decoration: underline;
}

.related-files {
    margin-top: 15px;
    padding-top: 15px;
    border-top: 1px solid #f0f0f0;
}

.files-label {
    font-size: 14px;
    color: #666;
    margin-right: 10px;
}

.file-link {
    color: #409eff !important;
    font-size: 14px;
    margin-right: 10px;
    padding: 0 !important;
    height: auto !important;
}

.file-link:hover {
    text-decoration: underline;
}

/* 子评论样式 */
.child-comments {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #f0f0f0;
    margin-left: 20px;
}

.child-comment-item {
    background-color: #f9f9f9;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    padding: 15px;
    margin-bottom: 15px;
}

.child-loading {
    text-align: center;
    padding: 20px;
    color: #909399;
}

.no-child-comments {
    text-align: center;
    padding: 20px;
    color: #909399;
    font-style: italic;
}

.no-comments {
    text-align: center;
    padding: 40px 20px;
    color: #909399;
    font-size: 16px;
}
</style>
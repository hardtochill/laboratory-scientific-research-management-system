<template>
    <div>
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
                        <el-tag v-for="keyword in literature.keywords" :key="keyword.id" size="medium"
                            style="margin-right: 6px">{{ keyword.keywordName }}</el-tag>
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
                    <div class="section-actions">
                        <el-button type="primary" @click="openCommentDialog">发表评论</el-button>
                        <div class="sort-controls">
                            <el-select v-model="sortField" placeholder="排序字段" style="width: 120px"
                                @change="handleSortChange">
                                <el-option label="点赞数" value="likeCount" />
                                <el-option label="评论时间" value="commentTime" />
                            </el-select>
                            <el-select v-model="sortOrder" placeholder="排序方式" style="width: 120px"
                                @change="handleSortChange">
                                <el-option label="升序" value="asc" />
                                <el-option label="降序" value="desc" />
                            </el-select>
                        </div>
                    </div>
                </div>

                <div v-loading="commentsLoading" class="comments-list">
                    <div v-for="comment in parentComments" :key="comment.id" class="comment-item">
                        <div class="comment-header">
                            <div class="user-info">
                                <span class="user-nickname" @click="getUserInfo(comment.userId)" style="cursor: pointer;">{{ comment.userNickName }}</span>
                            </div>
                            <div class="comment-time">
                                {{ formatDate(comment.commentTime) }}
                            </div>
                        </div>

                        <div class="comment-content">
                            <span v-if="comment.receiveUserNickName" class="reply-prefix" @click="getUserInfo(comment.receiveUserId)" style="cursor: pointer;">回复@{{ comment.receiveUserNickName }}：</span>
                            {{ comment.commentContent }}
                        </div>

                        <div class="comment-actions-row">
                            <div class="actions-left">
                                <span v-if="comment.hasChildComments" class="view-child-btn-inline"
                                    @click="toggleChildComments(comment.id)">
                                    {{ expandedChildComments.includes(comment.id) ? '收起子评论' : '查看子评论' }}
                                </span>
                            </div>
                            <div class="actions-right">
                                <div class="like-section" style="margin-bottom: 4px;">
                                    <svg-icon :icon-class="comment.isLiked ? 'thumbs-up' : 'thumbs-o-up'"
                                        class="like-icon" @click="handleLike(comment)"></svg-icon>
                                    <span class="like-count">{{ comment.likeCount }}</span>
                                </div>
                                <div class="reply-section">
                                    <el-button type="text" @click="openReplyDialog(comment.id)">回复</el-button>
                                </div>
                            </div>
                        </div>

                        <div v-if="comment.commentFiles && comment.commentFiles.length > 0" class="related-files">
                            <span class="files-label">关联文件：</span>
                            <el-button v-for="file in comment.commentFiles" :key="file.id" type="text" class="file-link"
                                @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                                {{ file.fileName }}.{{ file.fileType }}
                            </el-button>
                        </div>

                        <!-- 子评论区域 -->
                        <div v-if="expandedChildComments.includes(comment.id)" class="child-comments">
                            <div v-if="childCommentsLoading[comment.id]" class="child-loading">
                                <el-icon class="is-loading">
                                    <loading />
                                </el-icon>
                                加载中...
                            </div>
                            <div v-else-if="childComments[comment.id] && childComments[comment.id].length > 0">
                                <div v-for="childComment in childComments[comment.id]" :key="childComment.id"
                                    class="child-comment-item">
                                    <div class="comment-header">
                                        <div class="user-info">
                                            <span class="user-nickname" @click="getUserInfo(childComment.userId)" style="cursor: pointer;">{{ childComment.userNickName }}</span>
                                        </div>
                                        <div class="comment-time">
                                            {{ formatDate(childComment.commentTime) }}
                                        </div>
                                    </div>

                                    <div class="comment-content">
                                        <span v-if="childComment.receiveUserNickName">
                                            回复
                                            <span class="reply-prefix" @click="getUserInfo(childComment.receiveUserId)" style="cursor: pointer;">@{{ childComment.receiveUserNickName}}</span>
                                            : 
                                        </span>
                                        {{ childComment.commentContent }}
                                    </div>

                                    <div class="comment-actions-row">
                                        <div class="actions-left">
                                        </div>
                                        <div class="actions-right">
                                            <div class="like-section" style="margin-bottom: 4px;">
                                                <svg-icon
                                                    :icon-class="childComment.isLiked ? 'thumbs-up' : 'thumbs-o-up'"
                                                    class="like-icon" @click="handleLike(childComment)"></svg-icon>
                                                <span class="like-count">{{ childComment.likeCount }}</span>
                                            </div>
                                            <div class="reply-section">
                                                <el-button type="text"
                                                    @click="openReplyDialog(childComment.id)">回复</el-button>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="childComment.commentFiles && childComment.commentFiles.length > 0"
                                        class="related-files">
                                        <span class="files-label">关联文件：</span>
                                        <el-button v-for="file in childComment.commentFiles" :key="file.id" type="text"
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
                <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
                    v-model:limit="queryParams.pageSize" @pagination="handlePagination" />
            </div>
        </div>

        <!-- 通用评论对话框 -->
        <el-dialog v-model="showCommentDialog" :title="commentDialogTitle" width="600px" @close="closeCommentDialog">
            <el-form ref="commentFormRef" :model="commentForm" label-width="80px">
                <el-form-item :label="commentFormLabel" prop="content">
                    <el-input v-model="commentForm.content" type="textarea" :rows="4" maxlength="500" show-word-limit
                        :placeholder="`请输入${commentFormType === 'comment' ? '评论' : '回复'}内容（最多500字）`"></el-input>
                </el-form-item>
                <el-form-item label="可见范围" prop="visibleType">
                    <el-radio-group v-model="commentForm.visibleType" :disabled="commentFormType === 'reply'">
                        <el-radio :label="1">仅自己可见</el-radio>
                        <el-radio :label="2">公开</el-radio>
                    </el-radio-group>
                    <div v-if="commentFormType === 'reply'" style="margin-top: 5px; margin-left: 6px; color: #999; font-size: 12px;">
                        子评论只能设置为公开
                    </div>
                </el-form-item>
                <el-form-item label="关联文件">
                    <el-upload ref="commentUploadRef" action="#" :auto-upload="false" :file-list="commentForm.files"
                        :on-change="(fileList) => commentForm.files = fileList"
                        :on-remove="(fileList) => commentForm.files = fileList" multiple>
                        <el-button type="primary">选择文件</el-button>
                    </el-upload>
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="closeCommentDialog">取消</el-button>
                    <el-button type="primary" @click="submitComment">{{ commentFormType === 'comment' ? '发表' : '回复' }}</el-button>
                </span>
            </template>
        </el-dialog>

        <!-- 用户信息弹窗 -->
        <el-dialog v-model="showUserInfoDialog" title="用户信息" width="500px" @close="closeUserInfoDialog">
            <div v-loading="userInfoLoading" class="user-info-content">
                <div v-if="userInfoData && Object.keys(userInfoData).length > 0" class="user-info-item">
                    <div class="info-row">
                        <span class="label">用户名：</span>
                        <span class="value">{{ userInfoData.userName || '-' }}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">昵称：</span>
                        <span class="value">{{ userInfoData.userNickName || '-' }}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">邮箱：</span>
                        <span class="value">{{ userInfoData.email || '-' }}</span>
                    </div>
                    <div class="info-row">
                        <span class="label">电话：</span>
                        <span class="value">{{ userInfoData.phone || '-' }}</span>
                    </div>
                    <div class="info-row" v-if="userInfoData.sysRoles && userInfoData.sysRoles.length > 0">
                        <span class="label">角色：</span>
                        <span class="value">
                            <el-tag v-for="role in userInfoData.sysRoles" :key="role.roleId" size="small" style="margin-right: 5px;">
                                {{ role.roleName }}
                            </el-tag>
                        </span>
                    </div>
                </div>
                <div v-else class="no-data">
                    暂无用户信息
                </div>
            </div>
            <template #footer>
                <span class="dialog-footer">
                    <el-button type="primary" @click="closeUserInfoDialog">确定</el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script setup name="LiteratureDetail">
import { ref, onActivated, onMounted, computed } from 'vue'
import { useRouter, useRoute } from "vue-router"
import { ElMessage } from 'element-plus'
import { Loading } from '@element-plus/icons-vue'
import SvgIcon from '@/components/SvgIcon'
import { getLiteratureDetail } from '@/api/literature/literature'
import { listParentComments, listChildComments, toggleLike, addComment, getCommentUserDetail } from '@/api/comment/comment'
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

// 评论对话框相关数据
const showCommentDialog = ref(false)
const commentForm = ref({
  content: '',
  visibleType: 1, // 1: 仅自己可见, 2: 公开
  files: []
})
const commentFormType = ref('comment') // 'comment' | 'reply'
const currentParentId = ref(null) // 当前回复的父评论ID
const currentTargetId = ref(null) // 当前点击的目标评论ID（用于回复）
const parentCommentId = ref(null) // 父评论ID（用于刷新）
const targetCommentUserId = ref(null) // 目标评论的userId（用于receiveUserId）
const targetCommentUserNickName = ref(null) // 目标评论的userNickName（用于receiveUserNickName）

// 用户信息弹窗相关状态
const showUserInfoDialog = ref(false)
const userInfoData = ref({})
const userInfoLoading = ref(false)

// 计算属性
const commentDialogTitle = computed(() => {
  return commentFormType.value === 'comment' ? '发表评论' : '回复评论'
})

const commentFormLabel = computed(() => {
  return commentFormType.value === 'comment' ? '评论内容' : '回复内容'
})

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

/** 刷新指定父评论的子评论 - 性能优化版本 */
async function refreshChildCommentsForParent(parentId) {
    // 如果该父评论已展开，直接刷新其子评论数据，保持展开状态
    if (expandedChildComments.value.includes(parentId)) {
        childCommentsLoading.value[parentId] = true
        try {
            const res = await listChildComments(parentId)
            childComments.value[parentId] = res.rows || []
        } catch (error) {
            ElMessage.error('刷新子评论失败')
            console.error('刷新子评论失败:', error)
        } finally {
            childCommentsLoading.value[parentId] = false
        }
    } else {
        // 如果该父评论未展开，也刷新数据，这样下次展开时能看到最新内容
        try {
            const res = await listChildComments(parentId)
            childComments.value[parentId] = res.rows || []
        } catch (error) {
            console.error('预刷新子评论失败:', error)
            // 不显示错误消息，因为用户可能没有展开这个评论
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

/** 打开发表评论对话框 */
function openCommentDialog() {
    commentFormType.value = 'comment'
    commentForm.value.content = ''
    commentForm.value.visibleType = 1
    commentForm.value.files = []
    currentParentId.value = null
    currentTargetId.value = null
    parentCommentId.value = null
    targetCommentUserId.value = null
    showCommentDialog.value = true
}

/** 打开回复对话框 */
function openReplyDialog(targetCommentId) {
    commentFormType.value = 'reply'
    commentForm.value.content = ''
    commentForm.value.visibleType = 2
    commentForm.value.files = []
    
    // 如果是主评论，直接使用其ID
    const isParentComment = parentComments.value.some(comment => comment.id === targetCommentId)
    
    if (isParentComment) {
        // 点击的是主评论的回复按钮
        currentParentId.value = targetCommentId
        parentCommentId.value = targetCommentId
        
        // 获取主评论的userId和userNickName，用于receiveUserId和receiveUserNickName
        const targetComment = parentComments.value.find(comment => comment.id === targetCommentId)
        targetCommentUserId.value = targetComment ? targetComment.userId : null
        targetCommentUserNickName.value = targetComment ? targetComment.userNickName : null
    } else {
        // 点击的是子评论的回复按钮，需要找到其所属的主评论
        let parentComment = null
        let targetComment = null
        
        for (const comment of parentComments.value) {
            const childCommentsList = childComments.value[comment.id] || []
            const isChildComment = childCommentsList.some(child => child.id === targetCommentId)
            if (isChildComment) {
                parentComment = comment
                targetComment = childCommentsList.find(child => child.id === targetCommentId)
                break
            }
        }
        
        if (parentComment && targetComment) {
            currentParentId.value = parentComment.id
            parentCommentId.value = parentComment.id
            // 保存子评论的userId和userNickName作为receiveUserId和receiveUserNickName
            targetCommentUserId.value = targetComment.userId
            targetCommentUserNickName.value = targetComment.userNickName
        } else {
            console.error('找不到所属的主评论，targetCommentId:', targetCommentId)
            ElMessage.error('回复失败：找不到所属的评论')
            return
        }
    }
    
    // 保存用户点击的目标评论ID
    currentTargetId.value = targetCommentId
    showCommentDialog.value = true
    
    console.log('打开回复对话框，targetCommentId:', targetCommentId, 'parentId:', currentParentId.value, 'targetUserId:', targetCommentUserId.value, 'targetUserNickName:', targetCommentUserNickName.value)
    console.log('当前commentForm.files:', commentForm.value.files)
}

/** 关闭评论对话框 */
function closeCommentDialog() {
    showCommentDialog.value = false
    // 重置表单
    commentForm.value.content = ''
    commentForm.value.visibleType = 1
    commentForm.value.files = []
    commentFormType.value = 'comment'
    currentParentId.value = null
    currentTargetId.value = null
    parentCommentId.value = null
    targetCommentUserId.value = null
    targetCommentUserNickName.value = null
}

/** 获取用户信息 */
async function getUserInfo(userId) {
    if (!userId) {
        ElMessage.warning('用户ID无效')
        return
    }
    
    try {
        userInfoLoading.value = true
        const response = await getCommentUserDetail(userId)
        if (response.code === 200) {
            userInfoData.value = response.data || {}
            showUserInfoDialog.value = true
        } else {
            ElMessage.error(response.msg || '获取用户信息失败')
        }
    } catch (error) {
        console.error('获取用户信息失败:', error)
        ElMessage.error('获取用户信息失败')
    } finally {
        userInfoLoading.value = false
    }
}

/** 关闭用户信息弹窗 */
function closeUserInfoDialog() {
    showUserInfoDialog.value = false
    userInfoData.value = {}
}

/** 发表评论/回复评论 - 通用方法 */
async function submitComment() {
    const literatureId = route.params.id
    if (!literatureId) {
        ElMessage.error('文献ID错误')
        return
    }
    
    if (!commentForm.value.content.trim()) {
        ElMessage.warning(`请输入${commentFormType.value === 'comment' ? '评论' : '回复'}内容`)
        return
    }
    
    if (commentForm.value.content.length > 500) {
        ElMessage.warning(`${commentFormType.value === 'comment' ? '评论' : '回复'}内容不能超过500字`)
        return
    }
    
    try {
        if (commentFormType.value === 'comment') {
            // 发表评论
            await addComment(
                0, // parentId = 0 表示一级评论
                literatureId,
                commentForm.value.content.trim(),
                commentForm.value.visibleType,
                commentForm.value.files,
                null // 发表评论不携带receiveUserId
            )
            
            ElMessage.success('评论发表成功')
            closeCommentDialog()
            
            // 刷新评论列表
            await getParentComments()
            
            // 如果有展开的子评论，也要刷新子评论数据
            if (expandedChildComments.value.length > 0) {
                for (const parentId of expandedChildComments.value) {
                    childComments.value[parentId] = null
                    await toggleChildComments(parentId)
                }
            }
        } else {
            // 回复评论
            if (!currentParentId.value) {
                ElMessage.error('参数错误')
                return
            }
            
            await addComment(
                currentParentId.value,
                literatureId,
                commentForm.value.content.trim(),
                2, // 子评论固定为公开
                commentForm.value.files,
                targetCommentUserId.value, // 传递目标评论的userId作为receiveUserId
                targetCommentUserNickName.value // 传递目标评论的userNickName作为receiveUserNickName
            )
            
            ElMessage.success('回复发表成功')
            
            // 保存需要刷新的父评论ID，再关闭对话框
            const refreshParentId = parentCommentId.value
            closeCommentDialog()
            
            // 首先刷新父评论列表，以更新hasChildComments状态
            await getParentComments()
            
            // 然后刷新被回复评论所属父评论的子评论，保持其展开状态
            if (refreshParentId) {
                await refreshChildCommentsForParent(refreshParentId)
            }
        }
    } catch (error) {
        ElMessage.error(`${commentFormType.value === 'comment' ? '评论' : '回复'}发表失败`)
        console.error(`${commentFormType.value === 'comment' ? '评论' : '回复'}失败:`, error)
    }
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

.section-actions {
    display: flex;
    align-items: center;
    gap: 15px;
}

.sort-controls {
    display: flex;
    align-items: center;
    gap: 10px;
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
    border: 1px solid #e8e8e8;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 8px;
}

.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;
}

.user-info .user-nickname {
    font-weight: 500;
    color: #333;
    font-size: 16px;
}

.comment-time {
    color: #999;
    font-size: 12px;
}

.comment-content {
    line-height: 1.6;
    color: #333;
    font-size: 15px;
    margin-bottom: 8px;
}

.comment-actions-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: -5px;
}

.actions-left {
    display: flex;
    align-items: center;
}

.actions-right {
    display: flex;
    align-items: center;
    gap: 15px;
}

.view-child-btn-inline {
    color: #409eff;
    cursor: pointer;
    font-size: 13px;
    padding: 4px 8px;
    border-radius: 4px;
    transition: all 0.2s ease;
}

.view-child-btn-inline:hover {
    color: #337ecc;
    background-color: rgba(64, 158, 255, 0.1);
}

.like-icon {
    font-size: 22px;
    cursor: pointer;
    transition: all 0.3s ease;
    color: #606266;
    padding: 2px;
    border-radius: 4px;
    margin-right: 1px;
    margin-bottom: -4px;
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



.related-files {
    margin-top: 8px;
    padding-top: 8px;
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
    margin-top: 8px;
    padding-top: 8px;
    border-top: 1px solid #f0f0f0;
    margin-left: 20px;
}

.child-comment-item {
    background-color: #f9f9f9;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    padding: 10px;
    margin-bottom: 8px;
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

/* 回复前缀样式 */
.reply-prefix {
    color: #409eff;
    font-weight: 500;
}

/* 用户信息弹窗样式 */
.user-info-content {
    padding: 10px 0;
}

.user-info-item {
    line-height: 1.8;
}

.info-row {
    display: flex;
    margin-bottom: 10px;
    align-items: center;
}

.info-row .label {
    font-weight: 500;
    color: #333;
    min-width: 80px;
    text-align: right;
    margin-right: 10px;
}

.info-row .value {
    color: #666;
    flex: 1;
}

.no-data {
    text-align: center;
    color: #909399;
    padding: 40px 0;
}
</style>
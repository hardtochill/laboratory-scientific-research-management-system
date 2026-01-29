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
                        <span style="color: #555;">{{ parseTime(literature.publishTime, '{y}-{m}-{d}') }}</span>
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
                        <span class="label">DOI：</span>
                        <span style="color: #555;">{{ literature.doi }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">下载数：</span>
                        <span style="color: #555;">{{ literature.downloadCount }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">评分：</span>
                        <el-rate v-model="currentUserScore" :max="10" show-score @change="handleScoreChange" />
                    </div>
                    <div class="info-item">
                        <span class="label">上传用户：</span>
                        <span style="color: #495057;">{{ literature.uploadUserNickName }}</span>
                        <el-button type="primary" size="medium" @click="handleDownload" class="download-button-inline">
                            <el-icon><Download /></el-icon>
                            下载文献
                        </el-button>
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
                                <span class="visible-type" style="color: #999; margin-left: 8px; font-size: 13px;">{{ comment.visibleType === 1 ? '仅自己可见' : '公开' }}</span>
                            </div>
                            <div class="comment-time">
                                {{ formatDate(comment.commentTime) }}
                            </div>
                        </div>

                       <div class="comment-content">
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
                                <div class="like-section">
                                    <svg-icon :icon-class="comment.isLiked ? 'thumbs-up' : 'thumbs-o-up'"
                                        class="like-icon" @click="handleLike(comment)"></svg-icon>
                                    <span class="like-count">{{ comment.likeCount }}</span>
                                </div>
                                <el-button type="text" @click="openReplyDialog(comment.id)" class="reply-btn">回复</el-button>
                                <div class="more-actions">
                                    <el-dropdown @command="(command) => handleMoreAction(command, comment)">
                                        <span class="more-icon">
                                            <svg-icon icon-class="more-up2"></svg-icon>
                                        </span>
                                        <template #dropdown>
                                            <el-dropdown-menu>
                                                <el-dropdown-item v-if="isHasTeacherRole || comment.userId === currentUserId" 
                                                                  command="delete" class="delete-item">删除</el-dropdown-item>
                                                <el-dropdown-item v-else :disabled="true" class="delete-item-disabled">
                                                    删除
                                                </el-dropdown-item>

                                                <el-dropdown-item v-if="isHasTeacherRole || comment.userId === currentUserId" 
                                                                  :command="comment.visibleType === 1 ? 'makePublic' : 'makePrivate'"
                                                                  class="change-visibility-item">
                                                    {{ comment.visibleType === 1 ? '公开' : '仅自己可见' }}
                                                </el-dropdown-item>
                                                <el-dropdown-item v-else :disabled="true" class="change-visibility-item-disabled">
                                                    {{ comment.visibleType === 1 ? '公开' : '仅自己可见' }}
                                                </el-dropdown-item>
                                            </el-dropdown-menu>
                                        </template>
                                    </el-dropdown>
                                </div>
                            </div>
                        </div>

                        <div v-if="comment.commentFiles && comment.commentFiles.length > 0" class="related-files">
                            <span class="files-label">关联文件：</span>
                            <el-button v-for="file in comment.commentFiles" :key="file.id" type="text" class="file-link"
                                @click="downloadCommentFile(file.id, file.fileName + '.' + file.fileType)">
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
                                            <span class="visible-type" style="color: #999; margin-left: 8px;font-size: 13px;">{{ childComment.visibleType === 1 ? '仅自己可见' : '公开' }}</span>
                                        </div>
                                        <div class="comment-time">
                                            {{ formatDate(childComment.commentTime) }}
                                        </div>
                                    </div>

                                    <div class="comment-content">
                                        <span v-if="childComment.receiveUserNickName">
                                            <span class="reply-prefix" @click="getUserInfo(childComment.receiveUserId)" style="cursor: pointer;">@{{ childComment.receiveUserNickName}}</span>
                                            : 
                                        </span>
                                        {{ childComment.commentContent }}
                                    </div>

                                    <div class="comment-actions-row">
                                        <div class="actions-left">
                                        </div>
                                        <div class="actions-right">
                                            <div class="like-section">
                                                <svg-icon
                                                    :icon-class="childComment.isLiked ? 'thumbs-up' : 'thumbs-o-up'"
                                                    class="like-icon" @click="handleLike(childComment)"></svg-icon>
                                                <span class="like-count">{{ childComment.likeCount }}</span>
                                            </div>
                                            <el-button type="text" 
                                                    class="reply-btn"
                                                    @click="openReplyDialog(childComment.id)">回复</el-button>
                                            <div class="more-actions">
                                                <el-dropdown
                                                    @command="(command) => handleMoreAction(command, childComment)">
                                                    <span class="more-icon">
                                                        <svg-icon icon-class="more-up2"></svg-icon>
                                                    </span>
                                                    <template #dropdown>
                                                        <el-dropdown-menu>
                                                            <el-dropdown-item
                                                                v-if="isHasTeacherRole || childComment.userId === currentUserId"
                                                                command="delete"
                                                                class="delete-item">删除</el-dropdown-item>
                                                            <el-dropdown-item v-else
                                                            class="delete-item-disabled" :disabled="true">
                                                                删除
                                                            </el-dropdown-item>
                                                            <el-dropdown-item :disabled="true"
                                                                class="change-visibility-item-disabled">
                                                                更改可见状态
                                                            </el-dropdown-item>
                                                        </el-dropdown-menu>
                                                    </template>
                                                </el-dropdown>
                                            </div>
                                        </div>
                                    </div>

                                    <div v-if="childComment.commentFiles && childComment.commentFiles.length > 0"
                                        class="related-files">
                                        <span class="files-label">关联文件：</span>
                                        <el-button v-for="file in childComment.commentFiles" :key="file.id" type="text"
                                            class="file-link"
                                            @click="downloadCommentFile(file.id, file.fileName + '.' + file.fileType)">
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
            <el-form ref="commentFormRef" :model="commentForm" label-width="80px" :rules="commentRules">
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
                <el-form-item label="关联文件" prop="files">
                    <el-tooltip :content="commentFormType === 'reply' ? '回复时可不上传文件' : '请至少上传一个关联文件'" placement="top-start">
                        <el-upload ref="commentUploadRef" action="#" :auto-upload="false"
                            v-model:file-list="commentForm.files" :on-change="handleFileChange"
                            :on-remove="handleFileRemove" multiple style="width: 100%;"
                            :accept="'.gif,.jpg,.jpeg,.png,.doc,.docx,.xls,.xlsx,.ppt,.pptx,txt,.rar,.zip,.gz,.bz2,.pdf'">
                            <el-button type="primary">选择文件</el-button>
                        </el-upload>
                    </el-tooltip>
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
                    <div class="info-row" v-if="userInfoData.roles && userInfoData.roles.length > 0">
                        <span class="label">角色：</span>
                        <span class="value">
                            <el-tag v-for="role in userInfoData.roles" :key="role.roleId" size="small"
                                style="margin-right: 5px;">
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
import { ElMessage, ElMessageBox } from 'element-plus'
import { Loading, Download } from '@element-plus/icons-vue'
import SvgIcon from '@/components/SvgIcon'
import { getLiteratureDetail, scoreLiterature } from '@/api/literature/literature'
import { listParentComments, listChildComments, toggleLike, addComment, deleteComment, changeVisibleType } from '@/api/comment/comment'
import { download } from "@/utils/request"
import { parseTime } from '@/utils/ruoyi'
import useUserStore from '@/store/modules/user'
import { getUserDetail } from '../../api/system/user'



const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

// 用户角色相关数据
const userRoles = ref([])
const isHasTeacherRole = ref(false)
const currentUserId = ref(null)

// 文献详情数据
const literature = ref({})

// 评分数据
const currentUserScore = ref(null)

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
const commentFormRef = ref(null) // 评论表单引用

// 评论表单验证规则
const commentRules = ref({
  content: [{ required: true, message: '请输入评论内容', trigger: 'blur' }],
  files: [{ 
    validator: (rule, value, callback) => {
      // 仅在发表一级评论时强制要求上传文件
      if (commentFormType.value === 'comment' && (!commentForm.value.files || commentForm.value.files.length === 0)) {
        callback(new Error('请至少上传一个关联文件'))
      } else {
        callback()
      }
    }, 
    trigger: 'change' 
  }]
})
const commentFormType = ref('comment') // 'comment' | 'reply'
const commentUploadRef = ref(null) // 文件上传组件引用
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

/** 检查用户是否含有teacher角色 */
function checkUserRoles() {
    userRoles.value = userStore.roles || []
    currentUserId.value = userStore.id || null
    isHasTeacherRole.value = userRoles.value.includes('teacher') || userRoles.value.includes('admin')
}

/** 返回列表 */
function goBack() {
    router.push("/literature/resource")
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
        // 设置当前用户评分的初始值，优先使用路由参数中的score
        const queryScore = route.query.score
        console.log('路由参数中的score:', queryScore)
        if (queryScore !== undefined) {
            currentUserScore.value = parseFloat(queryScore)
        } else {
            currentUserScore.value = res.data.userScore !== null ? res.data.userScore : undefined
        }
    } catch (error) {
        ElMessage.error('获取文献详情失败')
        console.error('获取文献详情失败:', error)
    }
}

/** 处理评分变化 */
async function handleScoreChange(newScore) {
    const literatureId = literature.value.id
    if (!literatureId) {
        ElMessage.error('文献ID错误')
        return
    }
    
    try {
        await scoreLiterature({
            literatureId: literatureId,
            score: newScore
        })
        // 更新本地评分数据
        literature.value.finalScore = newScore
        currentUserScore.value = newScore
        ElMessage.success('评分成功')
    } catch (error) {
        ElMessage.error('评分失败')
        console.error('评分失败:', error)
        // 恢复原来的评分
        currentUserScore.value = literature.value.userScore
    }
}

/** 下载文献 */
async function handleDownload() {
    if (!literature.value.id) {
        ElMessage.error('文献ID错误')
        return
    }
    try {
        await download(`/literature/download/${literature.value.id}`, {}, `${literature.value.title}.pdf`, {}, false)
        ElMessage.success('文件下载成功')
    } catch (error) {
        console.error('文件下载失败:', error)
    }
}

/** 页面加载时获取数据 */
onActivated(() => {
    getDetail()
    getParentComments()
    checkUserRoles()
})
onMounted(() => {
    getDetail()
    getParentComments()
    checkUserRoles()
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

/** 刷新指定父评论的子评论 */
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

/** 下载评论文件 */
async function downloadCommentFile(fileId, fileName) {
    // 使用异步方式下载，不阻塞用户操作
    try {
        await download(`/commentFile/download/${fileId}`, {}, fileName, {}, false)
        ElMessage.success('文件下载成功')
    } catch (error) {
        console.error('文件下载失败:', error)
        ElMessage.error('文件下载失败')
    }
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
    
    // 清除表单验证错误
    if (commentFormRef.value) {
        commentFormRef.value.clearValidate()
    }
}

/** 打开回复对话框 */
function openReplyDialog(targetCommentId) {
    commentFormType.value = 'reply'
    
    // 清除表单验证错误
    if (commentFormRef.value) {
        commentFormRef.value.clearValidate()
    }
    commentForm.value.content = ''
    commentForm.value.visibleType = 2
    commentForm.value.files = []
    
    // 直接查找目标评论，利用parentId优化性能
    let targetComment = null
    let parentId = null
    
    // 首先在主评论中查找
    targetComment = parentComments.value.find(comment => comment.id === targetCommentId)
    
    if (targetComment) {
        // 找到的是主评论
        // 如果是回复一级评论，则parentId = 被回复评论的id
        parentId = targetCommentId
    } else {
        // 在子评论中查找
        for (const comment of parentComments.value) {
            const childCommentsList = childComments.value[comment.id] || []
            const foundChild = childCommentsList.find(child => child.id === targetCommentId)
            if (foundChild) {
                targetComment = foundChild
                // 如果是回复子评论，则parentId = 被回复评论的parentId
                parentId = targetComment.parentId
                break
            }
        }
    }
    
    if (!targetComment) {
        console.error('找不到目标评论，targetCommentId:', targetCommentId)
        ElMessage.error('回复失败：找不到目标评论')
        return
    }
    
    // 设置父评论ID和目标评论ID
    currentParentId.value = parentId
    parentCommentId.value = parentId
    currentTargetId.value = targetCommentId
    
    // 保存目标评论的userId和userNickName作为receiveUserId和receiveUserNickName
    targetCommentUserId.value = targetComment.userId
    targetCommentUserNickName.value = targetComment.userNickName
    
    showCommentDialog.value = true
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
    
    // 清除表单验证错误
    if (commentFormRef.value) {
        commentFormRef.value.clearValidate()
    }
    
    // 手动清空上传组件的文件列表
    const uploadRef = commentUploadRef.value
    if (uploadRef && uploadRef.clearFiles) {
        uploadRef.clearFiles()
    }
}

/** 获取用户信息 */
async function getUserInfo(userId) {
    if (!userId) {
        ElMessage.warning('用户ID无效')
        return
    }
    
    try {
        userInfoLoading.value = true
        const response = await getUserDetail(userId)
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

/** 处理更多操作下拉菜单 */
async function handleMoreAction(command, comment) {
    if (!comment) {
        ElMessage.error('评论信息获取失败')
        return
    }

    switch (command) {
        case 'delete':
            await handleDeleteComment(comment)
            break
        case 'makePublic':
            await changeCommentVisibility(comment, 2) // 公开
            break
        case 'makePrivate':
            await changeCommentVisibility(comment, 1) // 仅自己可见
            break
    }
}

/** 更改评论可见状态 */
async function changeCommentVisibility(comment, visibleType) {
    try {
        await changeVisibleType(comment.id, visibleType)
        ElMessage.success('更改可见状态成功')
        
        await getParentComments()

    } catch (error) {
        console.error('更改可见状态失败:', error)
        ElMessage.error('更改可见状态失败')
    }
}

/** 删除评论 */
async function handleDeleteComment(comment) {
    // 确认删除
    try {
        await ElMessageBox.confirm(
            '确定要删除这条评论吗？删除后无法恢复。', 
            '删除确认', 
            {
                confirmButtonText: '确定删除',
                cancelButtonText: '取消',
                type: 'warning',
            }
        )
    } catch {
        // 用户取消删除
        return
    }

    try {
        await deleteComment(comment.id)
        ElMessage.success('删除成功')
        
        // 更新UI - 参考发表评论的刷新逻辑
        const isChildComment = comment.parentId && comment.parentId !== 0
        
        if (isChildComment) {
            // 这是一个子评论，删除后需要：
            // 1. 刷新父评论列表（更新hasChildComments状态）
            // 2. 刷新该父评论的子评论列表（保持展开状态）
            await getParentComments()
            await refreshChildCommentsForParent(comment.parentId)
        } else {
            // 这是一个父评论，删除后需要：
            // 1. 刷新父评论列表
            // 2. 从展开列表中移除被删除的父评论
            // 3. 刷新其他已展开的父评论的子评论数据
            await getParentComments()
            
            // 从展开列表中移除被删除的父评论ID
            const deletedParentIndex = expandedChildComments.value.indexOf(comment.id)
            if (deletedParentIndex > -1) {
                expandedChildComments.value.splice(deletedParentIndex, 1)
            }
            
            // 刷新其他已展开的父评论的子评论数据
            if (expandedChildComments.value.length > 0) {
                for (const parentId of expandedChildComments.value) {
                    // 清除缓存，强制重新加载
                    childComments.value[parentId] = null
                    await refreshChildCommentsForParent(parentId)
                }
            }
        }
    } catch (error) {
        console.error('删除评论失败:', error)
        ElMessage.error('删除评论失败')
    }
}

/** 处理文件选择变化 */
function handleFileChange(file, fileList) {
    // 检查文件大小 (50MB限制)
    const maxSize = 50 * 1024 * 1024 // 50MB
    if (file.size > maxSize) {
        ElMessage.warning(`文件 ${file.name} 大小超过50MB限制，请重新选择`)
        // 移除超过大小限制的文件
        const index = fileList.findIndex(f => f.uid === file.uid)
        if (index > -1) {
            fileList.splice(index, 1)
        }
        return
    }
    // 更新文件列表
    commentForm.value.files = fileList
}

/** 处理文件移除 */
function handleFileRemove(file, fileList) {
    commentForm.value.files = fileList
}

/** 发表评论/回复评论 */
async function submitComment() {
    const literatureId = route.params.id
    if (!literatureId) {
        ElMessage.error('文献ID错误')
        return
    }
    
    // 使用表单验证
    if (!commentFormRef.value) {
        return
    }
    
    try {
        await commentFormRef.value.validate()
    } catch (error) {
        // 验证失败，表单会自动显示错误信息
        return
    }
    
    // 保存评论数据用于后台上传
    const commentType = commentFormType.value
    const content = commentForm.value.content.trim()
    const visibleType = commentFormType.value === 'comment' ? commentForm.value.visibleType : 2
    const files = commentForm.value.files
    const parentId = commentFormType.value === 'comment' ? 0 : currentParentId.value
    const receiveUserId = commentFormType.value === 'comment' ? null : targetCommentUserId.value
    const receiveUserNickName = commentFormType.value === 'comment' ? null : targetCommentUserNickName.value
    
    // 显示后台上传提示
    const operationText = commentType === 'comment' ? '评论' : '回复'
    ElMessage.info(`正在后台发表${operationText}，请稍候...`)
    
    // 立即关闭对话框，允许用户继续操作
    closeCommentDialog()
    
    // 后台执行评论提交操作
    const submitCommentInBackground = async () => {
        try {
            await addComment(
                parentId,
                literatureId,
                content,
                visibleType,
                files,
                receiveUserId,
                receiveUserNickName
            )
            
            ElMessage.success(`${operationText}发表成功`)
            
            // 刷新评论列表
            await getParentComments()
            
            // 如果有展开的子评论，也要刷新子评论数据
            if (expandedChildComments.value.length > 0) {
                for (const parentId of expandedChildComments.value) {
                    childComments.value[parentId] = null
                    await toggleChildComments(parentId)
                }
            }
            
            // 如果是回复评论，还需要特别处理
            if (commentType === 'reply' && currentParentId.value) {
                // 首先刷新父评论列表，以更新hasChildComments状态
                await getParentComments()
                
                // 然后刷新被回复评论所属父评论的子评论，保持其展开状态
                if (parentCommentId.value) {
                    await refreshChildCommentsForParent(parentCommentId.value)
                }
            }
        } catch (error) {
            ElMessage.error(`${operationText}发表失败`)
            console.error(`${operationText}失败:`, error)
        }
    }
    
    // 启动后台提交
    submitCommentInBackground()
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
    display: flex;
    align-items: center;
}

.label {
    font-weight: bold;
    color: #333;
    margin-right: 10px;
}

.abstract-text {
    margin-top: 8px;
    padding: 15px;
    background-color: #f8f9fa;
    color: #495057;
    font-size: 14px;
    border-radius: 6px;
    line-height: 1.8;
    border-left: 3px solid #79bbff;
}

.download-button-inline {
    margin-left: auto;
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
    color: #666;
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
    margin-bottom: 10px;
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
    margin-bottom: 2px;
}

/* 评论操作区域统一样式 */
.comment-actions-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 8px;
}

.actions-left {
    flex: 1;
}

.actions-right {
    display: flex;
    align-items: center;
}

/* 点赞区域 */
.like-section {
    display: flex;
    align-items: center;
    margin-right: 4px;
    height: 20px;
    line-height: 20px;
}

.like-icon {
    font-size: 22px;
    cursor: pointer;
    padding: 3px;
    border-radius: 4px;
    transition: all 0.3s;
    color: #606266;
}

.like-icon:hover {
    color: #409eff;
    background-color: #f0f9ff;
    transform: scale(1.1);
}

.like-icon:active {
    transform: scale(0.95);
}

.like-count {
    font-size: 13px;
    color: #909399;
    text-align: center;
}

/* 回复按钮 */
.reply-btn {
    font-size: 13px;
    padding: 4px 4px 4px 8px;
    height: 20px;
    line-height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 更多操作 */
.more-actions {
    position: relative;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.more-icon {
    cursor: pointer;
    padding: 4px;
    border-radius: 4px;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 20px;
    height: 20px;
    outline: none !important;
}

.more-icon:hover {
    background-color: #f5f7fa;
    color: #666;
}

.more-icon .svg-icon {
    width: 14px;
    height: 14px;
    color: #606266;
    outline: none !important;
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
}

.file-link:hover {
    text-decoration: underline;
}

/* 删除按钮样式 */
.delete-btn {
    color: #f56c6c !important;
    margin-right: 6px;
    height: auto !important;
}

.delete-btn:hover {
    color: #c45656 !important;
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

/* 文件上传组件样式 */
.el-upload__tip {
    color: #909399;
    font-size: 12px;
    line-height: 1.4;
    margin-top: 8px;
}

.el-upload-list {
    margin-top: 8px;
}

.el-upload-list__item {
    transition: all 0.3s;
}

.el-upload-list__item:hover {
    background-color: #f5f7fa;
}



/* 下拉菜单项样式 */
:deep(.el-dropdown-menu__item.delete-item) {
    color: #f56c6c !important;
}

:deep(.el-dropdown-menu__item.delete-item:hover) {
    background-color: #fef0f0 !important;
    color: #f56c6c !important;
}

:deep(.el-dropdown-menu__item.change-visibility-item) {
    color: #606266 !important;
}

:deep(.el-dropdown-menu__item.change-visibility-item:hover) {
    background-color: #f5f7fa !important;
    color: #606266 !important;
}

:deep(.el-dropdown-menu__item.delete-item-disabled){
    color: #c0c4cc !important;
    cursor: not-allowed !important;
}

:deep(.el-dropdown-menu__item.change-visibility-item-disabled) {
    color: #c0c4cc !important;
    cursor: not-allowed !important;
}

:deep(.el-dropdown-menu__item.change-visibility-item-disabled:hover) {
    background-color: transparent !important;
    color: #c0c4cc !important;
}
.without-outline:focus {
    outline: none;
}
</style>
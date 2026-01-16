<template>
  <div class="submission-management">
    <!-- 查询表单 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="100px" class="query-form">
      <el-form-item label="计划名称" prop="name">
        <el-select v-model="queryParams.name" placeholder="请选择计划名称" clearable style="width: 240px" filterable remote
          reserve-keyword :remote-method="querySelectablePlans" :loading="planLoading">
          <el-option v-for="plan in selectablePlans" :key="plan.id" :label="plan.name" :value="plan.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="创建用户" prop="createUserId">
        <el-select v-model="queryParams.createUserId" placeholder="请选择创建用户" clearable style="width: 240px" filterable
          remote reserve-keyword :remote-method="querySelectableCreators" :loading="creatorLoading">
          <el-option v-for="creator in selectableCreators" :key="creator.userId"
            :label="`${creator.nickName}(${creator.userName})`" :value="creator.userId" />
        </el-select>
      </el-form-item>
      <el-form-item label="投稿类型" prop="type">
        <el-select v-model="queryParams.type" placeholder="请选择投稿类型" clearable style="width: 240px"
          @change="handleQuery">
          <el-option label="期刊论文" :value="SUBMISSION_TYPE.JOURNAL_PAPER" />
          <el-option label="会议论文" :value="SUBMISSION_TYPE.CONFERENCE_PAPER" />
          <el-option label="发明专利" :value="SUBMISSION_TYPE.INVENTION_PATENT" />
          <el-option label="实用新型专利" :value="SUBMISSION_TYPE.UTILITY_MODEL_PATENT" />
          <el-option label="软件著作权" :value="SUBMISSION_TYPE.SOFTWARE_COPYRIGHT" />
        </el-select>
      </el-form-item>
      <el-form-item label="计划状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择计划状态" clearable style="width: 240px"
          @change="handleQuery">
          <el-option label="待送审" :value="1" />
          <el-option label="审核中" :value="2" />
          <el-option label="发表成功" :value="3" />
          <el-option label="发表失败" :value="4" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-card>
      <template #header>
        <div class="card-header">
          <span>投稿计划列表</span>
          <el-button type="primary" @click="handleAddPlan">
            <el-icon-plus /> 新增投稿计划
          </el-button>
        </div>
      </template>
      <!-- 投稿计划列表 -->
      <div class="submission-list">
        <div v-for="plan in submissionPlans" :key="plan.id" class="submission-item">
          <!-- 投稿计划行 -->
          <div class="submission-row">
            <!-- 左侧内容区域 -->
            <div class="left-content">
              <!-- 展开/收起按钮容器 -->
              <div class="expand-btn-container">
                <el-button type="text" @click.stop="toggleProcesses(plan)"
                  :icon="plan.expanded ? CaretBottom : CaretRight"></el-button>
              </div>

              <!-- 计划名称 -->
              <span class="submission-name">{{ plan.name }}</span>

              <!-- 计划状态 -->
              <el-tag :type="getPlanStatusType(plan.status)" size="small" class="submission-status">
                {{ getPlanStatusText(plan.status) }}
              </el-tag>

              <!-- 投稿期刊 -->
              <span class="journal-name">{{ plan.journal || '-' }}</span>
            </div>

            <!-- 右侧按钮区域 -->
            <div class="right-buttons">
              <!-- 新增流程按钮 -->
              <el-tooltip content="新增投稿流程" placement="top">
                <el-button link type="primary" @click.stop="handleAddProcess(plan)" :icon="Plus"></el-button>
              </el-tooltip>
              <!-- 计划详情按钮 -->
              <el-tooltip content="投稿计划详情" placement="top">
                <el-button link type="primary" @click.stop="showPlanDetail(plan)" :icon="Document"
                  style="margin-left: 0px;"></el-button>
              </el-tooltip>
              <!-- 修改状态下拉菜单 -->
              <el-tooltip content="更新计划状态" placement="top">
                <el-dropdown trigger="click" @command="(newStatus) => handleChangePlanStatus(plan, newStatus)">
                  <el-button link type="primary" :icon="Switch"></el-button>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item command="1">待送审</el-dropdown-item>
                      <el-dropdown-item command="2">审核中</el-dropdown-item>
                      <el-dropdown-item command="3">发表成功</el-dropdown-item>
                      <el-dropdown-item command="4">发表失败</el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </el-tooltip>
              <!-- 删除计划按钮 -->
              <el-tooltip content="删除投稿计划" placement="top">
                <el-button link type="danger" @click.stop="handleDeletePlan(plan)" :icon="Delete"></el-button>
              </el-tooltip>
            </div>
          </div>

          <!-- 投稿流程列表（带动画效果） -->
          <transition name="expand">
            <div v-if="plan.expanded" class="processes">
              <div class="loading" v-if="plan.loading">
                <el-skeleton :rows="3" animated />
              </div>
              <div v-else class="process-list">
                <div v-for="process in plan.processes" :key="process.id" class="process-item">
                  <div class="process-header">
                    <span class="process-name">{{ process.name }}</span>
                    <el-tag :type="getProcessStatusType(process.status)" size="small" class="process-status">
                      {{ getProcessStatusText(process.status) }}
                    </el-tag>
                  </div>

                  <!-- 关联文件展示（按tag分类） -->
                  <div class="related-files">
                    <div v-for="tag in PROCESS_TAG_CONFIG[process.name]" :key="tag" class="tag-file-group">
                      <el-row>
                        <span class="files-label">{{ FILE_TAG_TEXT[tag] }}：</span>
                        <div v-if="getFilesByTag(process, tag).length > 0" class="tag-file-list">
                          <el-button v-for="file in getFilesByTag(process, tag)" :key="file.id" type="text"
                            class="file-link" @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                            {{ file.fileName }}.{{ file.fileType }}
                          </el-button>
                        </div>
                        <span v-else class="no-files">-</span>
                      </el-row>
                    </div>
                  </div>

                  <div class="process-actions">
                    <!-- 流程详情按钮 -->
                    <el-tooltip content="流程详情" placement="top">
                      <el-button link type="primary" @click.stop="showProcessDetail(process)"
                        :icon="Document"></el-button>
                    </el-tooltip>
                    <!-- 文件管理按钮 -->
                    <el-tooltip content="文件管理" placement="top">
                      <el-button link type="primary" @click.stop="showFileManagement(process)"
                        :icon="Files"></el-button>
                    </el-tooltip>
                    <!-- 发起审核按钮 -->
                    <el-tooltip content="发起内部审核" placement="top"
                      v-if="process.status === PROCESS_STATUS.WAITING_SUBMIT_REVIEW || process.status === PROCESS_STATUS.REVIEW_FAILED">
                      <el-button link type="primary" @click.stop="handleSubmitReview(process)"
                        :icon="Check"></el-button>
                    </el-tooltip>
                    <!-- 删除流程按钮 -->
                    <el-tooltip content="删除流程" placement="top">
                      <el-button link type="danger" @click.stop="handleDeleteProcess(process)"
                        :icon="Delete"></el-button>
                    </el-tooltip>
                  </div>
                </div>
              </div>
            </div>
          </transition>
        </div>
      </div>

      <!-- 分页控件 -->
      <div class="pagination-container">
        <el-pagination v-model:current-page="queryParams.pageNum" v-model:page-size="queryParams.pageSize"
          :page-sizes="[5, 10, 20, 50]" layout="total, sizes, prev, pager, next, jumper" :total="total"
          @size-change="handleSizeChange" @current-change="handleCurrentChange" />
      </div>
    </el-card>

    <!-- 投稿计划详情对话框 -->
    <el-dialog v-model="planDialogVisible" :title="planDialogTitle" width="600px" :before-close="handlePlanDialogClose">
      <div v-if="currentPlan" class="submission-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="计划名称">
            {{ currentPlan.name }}
          </el-descriptions-item>
          <el-descriptions-item label="投稿类型">
            {{ getSubmissionTypeText(currentPlan.type) }}
          </el-descriptions-item>
          <el-descriptions-item label="投稿期刊">
            {{ currentPlan.journal || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="计划状态">
            <el-tag :type="getPlanStatusType(currentPlan.status)">
              {{ getPlanStatusText(currentPlan.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="创建人">
            {{ currentPlan.createUserNickName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentPlan.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="参与用户">
            {{currentPlan.participantUsers?.map(user => `${user.nickName}(${user.userName})`).join(', ') || '-'}}
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            {{ currentPlan.remark || '-' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handlePlanDialogClose">关闭</el-button>
          <el-button type="primary" @click="handlePlanEdit">修改</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 投稿计划新增/修改对话框 -->
    <el-dialog v-model="planFormVisible" :title="planFormTitle" width="600px" :before-close="handlePlanFormClose">
      <el-form :model="planFormData" ref="planFormRef" label-width="120px" :rules="planFormRules"
        class="submission-form">
        <!-- 隐藏字段 -->
        <el-form-item prop="id" style="display: none;">
          <el-input v-model="planFormData.id" type="hidden" />
        </el-form-item>

        <!-- 计划名称 -->
        <el-form-item label="计划名称" prop="name">
          <el-input v-model="planFormData.name" placeholder="请输入计划名称" maxlength="100" show-word-limit />
        </el-form-item>

        <!-- 投稿类型 -->
        <el-form-item label="投稿类型" prop="type">
          <el-select v-model="planFormData.type" placeholder="请选择投稿类型" style="width: 100%;">
            <el-option label="期刊论文" :value="SUBMISSION_TYPE.JOURNAL_PAPER" />
            <el-option label="会议论文" :value="SUBMISSION_TYPE.CONFERENCE_PAPER" />
            <el-option label="发明专利" :value="SUBMISSION_TYPE.INVENTION_PATENT" />
            <el-option label="实用新型专利" :value="SUBMISSION_TYPE.UTILITY_MODEL_PATENT" />
            <el-option label="软件著作权" :value="SUBMISSION_TYPE.SOFTWARE_COPYRIGHT" />
          </el-select>
        </el-form-item>

        <!-- 投稿期刊 -->
        <el-form-item label="投稿期刊" prop="journal">
          <el-input v-model="planFormData.journal" placeholder="请输入投稿期刊" maxlength="100" show-word-limit />
        </el-form-item>

        <!-- 计划状态 -->
        <el-form-item label="计划状态" prop="status">
          <el-select v-model="planFormData.status" placeholder="请选择计划状态" style="width: 100%;">
            <el-option label="待送审" value="1" />
            <el-option label="审核中" value="2" />
            <el-option label="发表成功" value="3" />
            <el-option label="发表失败" value="4" />
          </el-select>
        </el-form-item>

        <!-- 参与用户 -->
        <el-tooltip content="只有参与用户对该投稿计划可见" placement="top">
          <el-form-item label="参与用户" prop="participantUserIds">
            <el-select v-model="planFormData.participantUserIds" multiple filterable remote reserve-keyword
              placeholder="请输入用户名搜索并选择" style="width: 100%;" :remote-method="querySelectableParticipantUser"
              :loading="participantUserLoading">
              <el-option v-for="user in selectableParticipantUsers" :key="user.userId"
                :label="`${user.nickName}(${user.userName})`" :value="user.userId" />
            </el-select>
          </el-form-item>
        </el-tooltip>
        <!-- 备注 -->
        <el-form-item label="备注" prop="remark">
          <el-input v-model="planFormData.remark" type="textarea" placeholder="请输入备注信息" :rows="3" maxlength="255"
            show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handlePlanFormClose">取消</el-button>
          <el-button type="primary" @click="handlePlanFormSubmit">保存</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 投稿流程详情对话框 -->
    <el-dialog v-model="processDialogVisible" :title="processDialogTitle" width="600px"
      :before-close="handleProcessDialogClose">
      <div v-if="currentProcess" class="process-detail">
        <el-descriptions :column="1" border :label-width="120">
          <el-descriptions-item label="流程名称">
            {{ currentProcess.name }}
          </el-descriptions-item>
          <el-descriptions-item label="流程状态">
            <el-tag :type="getProcessStatusType(currentProcess.status)">
              {{ getProcessStatusText(currentProcess.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="审核人">
            {{ currentProcess.reviewerUserNickName || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentProcess.processCreateTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            {{ currentProcess.remark || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="关联文件">
            <div class="related-files">
              <div v-for="tag in PROCESS_TAG_CONFIG[currentProcess.name]" :key="tag" class="tag-file-group">
                <el-row>
                  <div class="tag-label">{{ FILE_TAG_TEXT[tag] }}：</div>
                  <div v-if="getFilesByTag(currentProcess, tag).length > 0" class="tag-file-list">
                    <el-button v-for="file in getFilesByTag(currentProcess, tag)" :key="file.id" type="text"
                      class="file-link" @click="downloadFile(file.id, file.fileName + '.' + file.fileType)">
                      {{ file.fileName }}.{{ file.fileType }}
                    </el-button>
                  </div>
                  <span v-else class="no-files">-</span>
                </el-row>
              </div>
            </div>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleProcessDialogClose">关闭</el-button>
          <el-button
            v-if="currentProcess?.status === PROCESS_STATUS.WAITING_SUBMIT_REVIEW || currentProcess?.status === PROCESS_STATUS.REVIEW_FAILED"
            type="primary" @click="handleProcessEdit">
            修改
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 投稿流程新增/修改对话框 -->
    <el-dialog v-model="processFormVisible" :title="processFormTitle" width="600px"
      :before-close="handleProcessFormClose">
      <el-form :model="processFormData" ref="processFormRef" label-width="120px" :rules="processFormRules"
        class="process-form">
        <!-- 隐藏字段 -->
        <el-form-item prop="id" style="display: none;">
          <el-input v-model="processFormData.id" type="hidden" />
        </el-form-item>
        <el-form-item prop="planId" style="display: none;">
          <el-input v-model="processFormData.planId" type="hidden" />
        </el-form-item>

        <!-- 流程名称 -->
        <el-form-item label="流程名称" prop="name">
          <el-select v-model="processFormData.name" placeholder="请选择流程名称" style="width: 100%;">
            <el-option v-for="process in PROCESS_NAME_ENUM" :key="process.value" :label="process.label"
              :value="process.value" />
          </el-select>
        </el-form-item>

        <!-- 审核人 -->
        <el-form-item label="审核人" prop="reviewerUserId">
          <el-select v-model="processFormData.reviewerUserId" placeholder="请选择审核人" filterable remote reserve-keyword
            style="width: 100%;" :remote-method="querySelectableReviewers" :loading="reviewerLoading">
            <el-option v-for="user in selectableReviewers" :key="user.userId"
              :label="`${user.nickName}(${user.userName})`" :value="user.userId" />
          </el-select>
        </el-form-item>

        <!-- 备注 -->
        <el-form-item label="备注" prop="remark">
          <el-input v-model="processFormData.remark" type="textarea" placeholder="请输入备注信息" :rows="3" maxlength="255"
            show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleProcessFormClose">取消</el-button>
          <el-button type="primary" @click="handleProcessFormSubmit">保存</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 文件管理对话框 -->
    <el-dialog v-model="fileDialogVisible" title="投稿文件管理" width="800px" height="500px"
      :before-close="handleFileDialogClose">
      <div v-if="currentProcessForFile" class="file-management">
        <div class="process-info">
          <h4>流程：{{ currentProcessForFile.name }}</h4>
        </div>
        <!-- 文件列表（按tag分类） -->
        <div class="file-list-section">
          <h4>已上传文件</h4>
          <div v-if="currentProcessForFile" class="tag-file-sections">
            <template v-for="(tag, index) in PROCESS_TAG_CONFIG[currentProcessForFile.name]" :key="tag">
              <div class="tag-file-section">
                <div class="tag-title-container">
                  <h5 class="tag-section-title">{{ FILE_TAG_TEXT[tag] }}</h5>
                  <el-button
                    v-if="currentProcessForFile?.status !== PROCESS_STATUS.REVIEWING && currentProcessForFile?.status !== PROCESS_STATUS.REVIEW_PASSED"
                    type="primary" size="small" @click="openUploadDialog(tag)" :icon="UploadFilled"
                    style="margin-right: 8px;">
                    上传
                  </el-button>
                </div>
                <el-table :data="getFilesByTagFromList(processFileList, tag)" stripe style="width: 100%"
                  v-loading="fileLoading">
                  <el-table-column prop="fileName" label="文件名" min-width="200">
                    <template #default="{ row }">
                      <span class="file-name">{{ row.fileName }}.{{ row.fileType }}</span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="fileSize" label="文件大小" width="120">
                    <template #default="{ row }">
                      {{ formatFileSize(row.fileSize) || '-' }}
                    </template>
                  </el-table-column>
                  <el-table-column prop="uploadTime" label="上传时间" width="160">
                    <template #default="{ row }">
                      {{ parseTime(row.createTime) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="操作" width="150" fixed="right">
                    <template #default="{ row }">
                      <el-button link type="primary" @click="downloadFile(row.id, row.fileName + '.' + row.fileType)"
                        :icon="Download">
                        下载
                      </el-button>
                      <el-button v-if="currentProcessForFile?.status === PROCESS_STATUS.WAITING_SUBMIT_REVIEW || currentProcessForFile?.status === PROCESS_STATUS.REVIEW_FAILED" link type="danger" @click="handleDeleteFile(row)" :icon="Delete">
                        删除
                      </el-button>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
              <el-divider v-if="index < PROCESS_TAG_CONFIG[currentProcessForFile.name].length - 1" />
            </template>
          </div>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleFileDialogClose">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 新的文件上传对话框 -->
    <el-dialog v-model="uploadDialogVisible" :title="`上传${FILE_TAG_TEXT[currentUploadTag]}`" width="600px"
      :before-close="handleUploadDialogClose">
      <div class="upload-dialog-content">
        <el-upload ref="uploadRef" :file-list="tempFileList" :auto-upload="false" :on-change="handleTempFileChange"
          :on-remove="handleTempFileRemove" :before-upload="beforeUpload" drag multiple
          accept=".java,.py,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.jpg,.jpeg,.png,.gif,.rar,.zip,.gz,.bz2">
          <el-icon class="el-icon--upload">
            <UploadFilled />
          </el-icon>
          <div class="el-upload__text">
            将文件拖到此处，或<em>点击上传</em>
          </div>
          <template #tip>
            <div class="el-upload__tip">
              支持java、py、pdf、doc、docx、xls、xlsx、ppt、pptx、txt、jpg、jpeg、png、gif、rar、zip、gz、bz2格式文件，单个文件不超过50MB
            </div>
          </template>
        </el-upload>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleUploadDialogClose">取消</el-button>
          <el-button type="primary" @click="handleTempFileUpload" :loading="tempUploading">
            {{ tempUploading ? '上传中...' : '确定' }}
          </el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 发起审核对话框 -->
    <el-dialog v-model="submitReviewDialogVisible" title="发起内部审核" width="400px"
      :before-close="handleSubmitReviewDialogClose">
      <el-form :model="submitReviewForm" ref="submitReviewFormRef" label-width="100px">
        <el-form-item label="审核备注" prop="reviewedRemark">
          <el-input v-model="submitReviewForm.reviewedRemark" type="textarea" placeholder="请输入审核备注（非必填）" :rows="4"
            maxlength="255" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleSubmitReviewDialogClose">取消</el-button>
          <el-button type="primary" @click="handleSubmitReviewConfirm">确认发起</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, reactive, toRefs, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listSubmissionPlans, getSubmissionPlan, createSubmissionPlan, updateSubmissionPlan, deleteSubmissionPlan, listSubmissionPlansForSelect, getSelectableCreateUsers } from '@/api/submission/submissionPlan'
import { listSubmissionProcessesByPlanId, createSubmissionProcess, updateSubmissionProcess, deleteSubmissionProcess, submitForReview, getSubmissionProcessDetail, getSelectableReviewerUsers } from '@/api/submission/submissionProcess'
import { uploadSubmissionProcessFile, deleteSubmissionProcessFile, getSubmissionProcessFiles, downloadSubmissionProcessFile } from '@/api/submission/submissionProcessFile'
import { parseTime } from '@/utils/ruoyi'
import { CaretRight, CaretBottom, Plus, Switch, Delete, Document, Files, Check, UploadFilled, Download } from '@element-plus/icons-vue'

// 投稿计划状态枚举
const PLAN_STATUS = {
  WAITING_REVIEW: 1,
  UNDER_REVIEW: 2,
  PUBLISHED_SUCCESS: 3,
  PUBLISHED_FAILED: 4
}

// 投稿类型枚举
const SUBMISSION_TYPE = {
  JOURNAL_PAPER: 1,
  CONFERENCE_PAPER: 2,
  INVENTION_PATENT: 3,
  UTILITY_MODEL_PATENT: 4,
  SOFTWARE_COPYRIGHT: 5
}

// 投稿流程状态枚举
const PROCESS_STATUS = {
  WAITING_SUBMIT_REVIEW: 1,
  REVIEWING: 2,
  REVIEW_PASSED: 3,
  REVIEW_FAILED: 4
}

// 投稿流程文件标签枚举
const FILE_TAG = {
  JOURNAL_SUBMISSION: 1, // 提交给期刊的文件
  RAW_DATA_AND_PROGRAM: 2, // 原始数据与程序
  REVIEW_COMMENTS: 3, // 审稿意见
  SUPPLEMENTARY_DATA: 4, // 补充数据
  FINAL_DRAFT: 5 // 最终稿
}

// 流程名称对应的文件标签配置
const PROCESS_TAG_CONFIG = {
  '一审': [FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.RAW_DATA_AND_PROGRAM],
  '二审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '三审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '四审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '五审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '六审': [FILE_TAG.REVIEW_COMMENTS, FILE_TAG.JOURNAL_SUBMISSION, FILE_TAG.SUPPLEMENTARY_DATA],
  '校稿': [FILE_TAG.FINAL_DRAFT]
}

// 文件标签文本映射
const FILE_TAG_TEXT = {
  [FILE_TAG.JOURNAL_SUBMISSION]: '提交给期刊的文件',
  [FILE_TAG.RAW_DATA_AND_PROGRAM]: '原始数据与程序',
  [FILE_TAG.REVIEW_COMMENTS]: '审稿意见',
  [FILE_TAG.SUPPLEMENTARY_DATA]: '补充数据',
  [FILE_TAG.FINAL_DRAFT]: '最终稿'
}

// 投稿流程名称枚举（展示顺序：一审、二审、三审、校稿、四审、五审、六审）
const PROCESS_NAME_ENUM = [
  { label: '一审', value: '一审' },
  { label: '二审', value: '二审' },
  { label: '三审', value: '三审' },
  { label: '校稿', value: '校稿' },
  { label: '四审', value: '四审' },
  { label: '五审', value: '五审' },
  { label: '六审', value: '六审' }
]

// 获取投稿计划状态类型
const getPlanStatusType = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PLAN_STATUS.WAITING_REVIEW:
      return 'info'
    case PLAN_STATUS.UNDER_REVIEW:
      return 'warning'
    case PLAN_STATUS.PUBLISHED_SUCCESS:
      return 'success'
    case PLAN_STATUS.PUBLISHED_FAILED:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取投稿计划状态文本
const getPlanStatusText = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PLAN_STATUS.WAITING_REVIEW:
      return '待送审'
    case PLAN_STATUS.UNDER_REVIEW:
      return '审核中'
    case PLAN_STATUS.PUBLISHED_SUCCESS:
      return '发表成功'
    case PLAN_STATUS.PUBLISHED_FAILED:
      return '发表失败'
    default:
      return '未知状态'
  }
}

// 获取投稿类型文本
const getSubmissionTypeText = (type) => {
  const numType = parseInt(type)
  switch (numType) {
    case SUBMISSION_TYPE.JOURNAL_PAPER:
      return '期刊论文'
    case SUBMISSION_TYPE.CONFERENCE_PAPER:
      return '会议论文'
    case SUBMISSION_TYPE.INVENTION_PATENT:
      return '发明专利'
    case SUBMISSION_TYPE.UTILITY_MODEL_PATENT:
      return '实用新型专利'
    case SUBMISSION_TYPE.SOFTWARE_COPYRIGHT:
      return '软件著作权'
    default:
      return '未知类型'
  }
}

// 获取投稿流程状态类型
const getProcessStatusType = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PROCESS_STATUS.WAITING_SUBMIT_REVIEW:
      return 'info'
    case PROCESS_STATUS.REVIEWING:
      return 'warning'
    case PROCESS_STATUS.REVIEW_PASSED:
      return 'success'
    case PROCESS_STATUS.REVIEW_FAILED:
      return 'danger'
    default:
      return 'info'
  }
}

// 获取投稿流程状态文本
const getProcessStatusText = (status) => {
  const numStatus = parseInt(status)
  switch (numStatus) {
    case PROCESS_STATUS.WAITING_SUBMIT_REVIEW:
      return '待发起内部审核'
    case PROCESS_STATUS.REVIEWING:
      return '内部审核中'
    case PROCESS_STATUS.REVIEW_PASSED:
      return '内部审核通过'
    case PROCESS_STATUS.REVIEW_FAILED:
      return '审核不通过'
    default:
      return '未知状态'
  }
}

// 投稿计划列表
const submissionPlans = ref([])
// 加载状态
const loading = ref(true)
// 分页数据
const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    id: undefined,
    name: undefined,
    createUserId: undefined,
    createUserNickName: undefined,
    type: undefined,
    status: undefined
  },
  total: 0
})

const { queryParams, total } = toRefs(data)

// 投稿计划详情对话框
const planDialogVisible = ref(false)
const planDialogTitle = ref('投稿计划详情')
const currentPlan = ref(null)

// 投稿计划表单对话框
const planFormVisible = ref(false)
const planFormTitle = ref('新增投稿计划')
const planFormRef = ref(null)
const planFormData = reactive({
  id: undefined,
  name: '',
  type: undefined,
  journal: '',
  status: '1',
  remark: '',
  participantUserIds: []
})

const planFormRules = reactive({
  name: [
    { required: true, message: '请输入计划名称', trigger: 'blur' },
    { min: 1, max: 100, message: '长度在 1 到 100 个字符', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择投稿类型', trigger: 'change' }
  ],
  journal: [
    { max: 100, message: '长度不超过 100 个字符', trigger: 'blur' }
  ]
})

// 投稿流程详情对话框
const processDialogVisible = ref(false)
const processDialogTitle = ref('投稿流程详情')
const currentProcess = ref(null)

// 投稿流程表单对话框
const processFormVisible = ref(false)
const processFormTitle = ref('新增投稿流程')
const processFormRef = ref(null)
const processFormData = reactive({
  id: undefined,
  planId: undefined,
  name: '',
  reviewerUserId: undefined,
  remark: ''
})

const processFormRules = reactive({
  name: [
    { required: true, message: '请选择流程名称', trigger: 'change' },
  ],
  reviewerUserId: [
    { required: true, message: '请选择审核人', trigger: 'change' }
  ]
})

// 文件管理相关
const fileDialogVisible = ref(false)
const currentProcessForFile = ref(null)
const processFileList = ref([])
const tagFileLists = ref({}) // 按tag分类的文件列表
const fileLoading = ref(false)
const uploading = ref(false)
const uploadRef = ref(null)

// 新的文件上传对话框相关
const uploadDialogVisible = ref(false)
const currentUploadTag = ref(null) // 当前上传的tag
const tempFileList = ref([]) // 临时文件列表
const tempUploading = ref(false)

// 发起审核对话框
const submitReviewDialogVisible = ref(false)
const currentProcessForReview = ref(null)
const submitReviewForm = reactive({
  reviewedRemark: ''
})

// 可选审核人列表
const selectableReviewers = ref([])
const reviewerLoading = ref(false)

// 投稿计划名称列表（用于下拉选择）
const selectablePlans = ref([])
const planLoading = ref(false)

// 创建用户列表（用于下拉选择）
const selectableCreators = ref([])
const creatorLoading = ref(false)

// 参与用户列表（用于下拉选择）
const selectableParticipantUsers = ref([])
const participantUserLoading = ref(false)

// 加载投稿计划列表
const loadSubmissionPlans = async () => {
  loading.value = true
  try {
    const response = await listSubmissionPlans(queryParams.value)
    submissionPlans.value = (response.rows || []).map((plan) => ({
      ...plan,
      expanded: false,
      loading: false,
      processes: []
    }))
    total.value = response.total || 0
  } catch (error) {
    ElMessage.error('加载投稿计划失败')
    console.error('加载投稿计划失败:', error)
  } finally {
    loading.value = false
  }
}

// 查询操作
const handleQuery = () => {
  queryParams.value.pageNum = 1
  loadSubmissionPlans()
}

// 重置查询
const resetQuery = () => {
  queryParams.value = {
    pageNum: 1,
    pageSize: 10,
    name: undefined,
    createUserNickName: undefined,
    type: undefined,
    journal: undefined,
    status: undefined
  }
  handleQuery()
}

// 分页变化
const handleSizeChange = (newSize) => {
  queryParams.value.pageSize = newSize
  loadSubmissionPlans()
}

const handleCurrentChange = (newNum) => {
  queryParams.value.pageNum = newNum
  loadSubmissionPlans()
}

// 切换流程显示/隐藏
const toggleProcesses = async (plan) => {
  if (!plan.expanded) {
    // 加载流程
    await loadProcesses(plan)
  }
  plan.expanded = !plan.expanded
}

// 加载投稿流程
const loadProcesses = async (plan) => {
  if (!plan.loading) {
    try {
      plan.loading = true
      const response = await listSubmissionProcessesByPlanId(plan.id)
      // 后端接口已经返回了包含关联文件的流程列表
      const processes = response.rows || []

      // 确保每个流程都有files字段，避免前端展示时出错
      const processesWithFiles = processes.map(process => ({
        ...process,
        files: process.files || []
      }))

      plan.processes = processesWithFiles
    } catch (error) {
      ElMessage.error('加载投稿流程失败')
      console.error('加载投稿流程失败:', error)
    } finally {
      plan.loading = false
    }
  }
}

// 根据tag获取文件列表
const getFilesByTag = (process, tag) => {
  // 优先从后端返回的分类文件列表中获取
  if (process.journalSubmissionFiles && tag === FILE_TAG.JOURNAL_SUBMISSION) {
    return process.journalSubmissionFiles
  } else if (process.rawDataAndProgramFiles && tag === FILE_TAG.RAW_DATA_AND_PROGRAM) {
    return process.rawDataAndProgramFiles
  } else if (process.reviewCommentsFiles && tag === FILE_TAG.REVIEW_COMMENTS) {
    return process.reviewCommentsFiles
  } else if (process.supplementaryDataFiles && tag === FILE_TAG.SUPPLEMENTARY_DATA) {
    return process.supplementaryDataFiles
  } else if (process.finalDraftFiles && tag === FILE_TAG.FINAL_DRAFT) {
    return process.finalDraftFiles
  }
  // 兼容旧的files数组
  return process.files?.filter(file => file.tag === tag) || []
}

// 检查是否所有tag都至少有一个文件
const isAllTagsHaveFiles = computed(() => {
  if (!currentProcessForFile.value) return false
  const requiredTags = PROCESS_TAG_CONFIG[currentProcessForFile.value.name]
  return requiredTags.every(tag =>
    tagFileLists.value[tag] && tagFileLists.value[tag].length > 0
  )
})

// 从文件列表中按tag获取文件
const getFilesByTagFromList = (fileList, tag) => {
  return fileList.filter(file => file.tag === tag)
}

// 格式化文件大小
const formatFileSize = (size) => {
  if (!size) return '0 B'
  const units = ['B', 'KB', 'MB', 'GB']
  let unitIndex = 0
  let fileSize = size

  while (fileSize >= 1024 && unitIndex < units.length - 1) {
    fileSize /= 1024
    unitIndex++
  }

  return `${fileSize.toFixed(1)} ${units[unitIndex]}`
}

// 显示投稿计划详情
const showPlanDetail = async (plan) => {
  try {
    const response = await getSubmissionPlan(plan.id)
    currentPlan.value = response.data
    planDialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载投稿计划详情失败')
    console.error('加载投稿计划详情失败:', error)
  }
}

// 显示投稿流程详情
const showProcessDetail = async (process) => {
  try {
    // 调用新的getSubmissionProcessDetail接口获取最新的流程详情
    const response = await getSubmissionProcessDetail(process.id)
    const processDetail = response.data

    // 后端接口已经返回了包含关联文件的流程详情
    // 确保有files字段，避免前端展示时出错
    processDetail.files = processDetail.files || []

    currentProcess.value = processDetail
    processDialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载投稿流程详情失败')
    console.error('加载投稿流程详情失败:', error)
  }
}

// 新增投稿计划
const handleAddPlan = () => {
  resetPlanForm()
  planFormTitle.value = '新增投稿计划'
  planFormVisible.value = true
}

// 修改投稿计划
const handlePlanEdit = () => {
  planDialogVisible.value = false
  planFormTitle.value = '修改投稿计划'
  Object.assign(planFormData, {
    id: currentPlan.value.id,
    name: currentPlan.value.name,
    type: currentPlan.value.type,
    journal: currentPlan.value.journal || '',
    status: String(currentPlan.value.status),
    remark: currentPlan.value.remark || '',
    participantUserIds: currentPlan.value.participantUsers?.map(user => `${user.nickName}(${user.userName})`) || []
  })
  planFormVisible.value = true
}

// 重置投稿计划表单
const resetPlanForm = () => {
  if (planFormRef.value) {
    planFormRef.value.resetFields()
  }
  Object.assign(planFormData, {
    id: undefined,
    name: '',
    type: undefined,
    journal: '',
    status: '1',
    remark: '',
    participantUserIds: []
  })
  selectableParticipantUsers.value = []
}

// 提交投稿计划表单
const handlePlanFormSubmit = async () => {
  if (!planFormRef.value) return
  try {
    await planFormRef.value.validate()
    const submitData = {
      ...planFormData,
      type: parseInt(planFormData.type),
      status: parseInt(planFormData.status)
    }
    if (planFormData.id) {
      await updateSubmissionPlan(submitData)
    } else {
      await createSubmissionPlan(submitData)
    }
    ElMessage.success('保存成功')
    planFormVisible.value = false
    resetPlanForm()
    loadSubmissionPlans()
  } catch (error) {
    if (error === false) return
  }
}

// 关闭投稿计划表单
const handlePlanFormClose = () => {
  planFormVisible.value = false
  resetPlanForm()
}

// 关闭投稿计划详情
const handlePlanDialogClose = () => {
  planDialogVisible.value = false
  currentPlan.value = null
}

// 删除投稿计划
const handleDeletePlan = async (plan) => {
  try {
    await ElMessageBox.confirm('确定要删除该投稿计划吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteSubmissionPlan(plan.id)
    ElMessage.success('删除成功')
    loadSubmissionPlans()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除投稿计划失败:', error)
    }
  }
}

// 修改投稿计划状态
const handleChangePlanStatus = async (plan, newStatus) => {
  try {
    await updateSubmissionPlan({
      id: plan.id,
      status: parseInt(newStatus)
    })
    ElMessage.success('修改状态成功')
    loadSubmissionPlans()
  } catch (error) {
    ElMessage.error('修改状态失败')
    console.error('修改投稿计划状态失败:', error)
  }
}

// 新增投稿流程
const handleAddProcess = (plan) => {
  resetProcessForm()
  processFormTitle.value = '新增投稿流程'
  processFormData.planId = plan.id
  processFormVisible.value = true
}

// 修改投稿流程
const handleProcessEdit = () => {
  if (!currentProcess.value) {
    ElMessage.error('流程信息不存在')
    return
  }

  const currentStatus = currentProcess.value.status
  if (currentStatus === PROCESS_STATUS.REVIEWING) {
    ElMessage.info('审核中，无法修改')
    return
  }
  if (currentStatus === PROCESS_STATUS.REVIEW_PASSED) {
    ElMessage.info('审核成功，无法修改')
    return
  }

  processDialogVisible.value = false
  processFormTitle.value = '修改投稿流程'
  Object.assign(processFormData, {
    id: currentProcess.value.id,
    planId: currentProcess.value.planId,
    name: currentProcess.value.name,
    reviewerUserId: currentProcess.value.reviewerUserId,
    remark: currentProcess.value.remark || ''
  })
  processFormVisible.value = true
}

// 重置投稿流程表单
const resetProcessForm = () => {
  if (processFormRef.value) {
    processFormRef.value.resetFields()
  }
  Object.assign(processFormData, {
    id: undefined,
    planId: undefined,
    name: '',
    reviewerUserId: undefined,
    remark: ''
  })
}

// 提交投稿流程表单
const handleProcessFormSubmit = async () => {
  if (!processFormRef.value) return
  try {
    await processFormRef.value.validate()
    // 从用户列表中获取审核人的nickName
    const selectedUser = selectableReviewers.value.find(user => user.userId === processFormData.reviewerUserId)
    const submitData = {
      ...processFormData,
      reviewerUserNickName: selectedUser ? selectedUser.nickName : ''
    }
    if (processFormData.id) {
      await updateSubmissionProcess(submitData)
    } else {
      await createSubmissionProcess(submitData)
    }
    ElMessage.success('保存成功')
    processFormVisible.value = false
    resetProcessForm()
    // 重新加载当前计划的流程
    const currentPlan = submissionPlans.value.find(p => p.id === submitData.planId)
    if (currentPlan) {
      await loadProcesses(currentPlan)
    }
  } catch (error) {
    if (error === false) return
  }
}

// 关闭投稿流程表单
const handleProcessFormClose = () => {
  processFormVisible.value = false
  resetProcessForm()
}

// 关闭投稿流程详情
const handleProcessDialogClose = () => {
  processDialogVisible.value = false
  currentProcess.value = null
}

// 删除投稿流程
const handleDeleteProcess = async (process) => {
  try {
    await ElMessageBox.confirm('确定要删除该投稿流程吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteSubmissionProcess(process.id)
    ElMessage.success('删除成功')
    // 重新加载当前计划的流程
    const currentPlan = submissionPlans.value.find(p => p.id === process.planId)
    if (currentPlan) {
      await loadProcesses(currentPlan)
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除投稿流程失败:', error)
    }
  }
}

// 显示文件管理
const showFileManagement = async (process) => {
  currentProcessForFile.value = process
  fileDialogVisible.value = true
  fileLoading.value = true
  try {
    // 调用getSubmissionProcessFiles接口获取文件列表
    const response = await getSubmissionProcessFiles(process.id)
    processFileList.value = response.data || []
    // 初始化tagFileLists
    tagFileLists.value = {}
  } catch (error) {
    ElMessage.error('加载文件列表失败')
    console.error('加载文件列表失败:', error)
    processFileList.value = []
    tagFileLists.value = {}
  } finally {
    fileLoading.value = false
  }
}

// 打开上传对话框
const openUploadDialog = (tag) => {
  currentUploadTag.value = tag
  tempFileList.value = [] // 清空临时文件列表
  uploadDialogVisible.value = true
}

// 临时文件选择变化处理
const handleTempFileChange = (file, fileList) => {
  tempFileList.value = fileList
}

// 临时文件移除处理
const handleTempFileRemove = (file, fileList) => {
  tempFileList.value = fileList
}

// 上传前验证
const beforeUpload = (file) => {
  const isLt50M = file.size / 1024 / 1024 < 50
  if (!isLt50M) {
    ElMessage.error('文件大小不能超过50MB')
    return false
  }
  return true
}

// 删除文件
const handleDeleteFile = async (file) => {
  try {
    if (currentProcessForFile.value.status === PROCESS_STATUS.REVIEWING) {
      ElMessage.info('审核中，无法删除文件')
      return
    }
    if (currentProcessForFile.value.status === PROCESS_STATUS.REVIEW_PASSED) {
      ElMessage.info('审核成功，无法删除文件')
      return
    }

    await ElMessageBox.confirm('确定要删除该文件吗？', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    await deleteSubmissionProcessFile(file.id)
    ElMessage.success('文件删除成功')
    // 从本地文件列表中移除删除的文件
    processFileList.value = processFileList.value.filter(f => f.id !== file.id)

    // 刷新当前计划的流程列表，更新关联文件显示
    const currentPlan = submissionPlans.value.find(plan => plan.id === currentProcessForFile.value.planId)
    if (currentPlan) {
      await loadProcesses(currentPlan)
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('文件删除失败')
      console.error('文件删除失败:', error)
    }
  }
}

// 关闭文件管理
const handleFileDialogClose = () => {
  fileDialogVisible.value = false
  currentProcessForFile.value = null
  processFileList.value = []
  tagFileLists.value = {} // 清空所有tag的文件列表
}

// 关闭上传对话框（取消按钮）
const handleUploadDialogClose = () => {
  uploadDialogVisible.value = false
  tempFileList.value = [] // 清空临时文件列表
}

// 处理临时文件上传（确定按钮）
const handleTempFileUpload = async () => {
  // 检查文件列表，过滤掉无效文件（如上传失败的文件）
  const validFiles = tempFileList.value.filter(file => !file.status || file.status !== 'fail')

  if (validFiles.length === 0) {
    ElMessage.warning('请选择要上传的文件')
    return
  }

  tempUploading.value = true
  let successCount = 0
  let failCount = 0

  try {
    const processId = currentProcessForFile.value.id
    const tag = currentUploadTag.value

    // 遍历临时文件列表，直接上传到后端
    for (const fileItem of validFiles) {
      try {
        await uploadSubmissionProcessFile(processId, fileItem, tag)
        successCount++
      } catch (error) {
        failCount++
        console.error(`文件 ${fileItem.name} 上传失败:`, error)
        ElMessage.error(`文件 ${fileItem.name} 上传失败: ${error.message || '未知错误'}`)
      }
    }

    // 显示上传结果
    if (successCount > 0 && failCount === 0) {
      ElMessage.success(`所有文件上传成功 (${successCount}/${validFiles.length})`)
    } else if (successCount > 0 && failCount > 0) {
      ElMessage.warning(`部分文件上传成功 (${successCount}个成功，${failCount}个失败)`)
    } else {
      ElMessage.error(`文件上传失败 (${failCount}/${validFiles.length})`)
    }

    if (successCount > 0) {
      // 上传成功后刷新文件列表
      const response = await getSubmissionProcessFiles(currentProcessForFile.value.id)
      processFileList.value = response.data || []

      // 刷新当前计划的流程列表，更新关联文件显示
      const currentPlan = submissionPlans.value.find(plan => plan.id === currentProcessForFile.value.planId)
      if (currentPlan) {
        await loadProcesses(currentPlan)
      }
    }

    // 关闭对话框并清空临时文件列表
    uploadDialogVisible.value = false
    tempFileList.value = []

    // 清空对应tag的文件列表（因为已经直接上传了）
    if (tagFileLists.value[currentUploadTag.value]) {
      tagFileLists.value[currentUploadTag.value] = []
    }
  } catch (error) {
    ElMessage.error('文件上传过程出现错误: ' + (error.message || '未知错误'))
    console.error('文件上传过程出现错误:', error)
  } finally {
    tempUploading.value = false
  }
}

// 发起内部审核
const handleSubmitReview = (process) => {
  currentProcessForReview.value = process
  submitReviewForm.reviewedRemark = ''
  submitReviewDialogVisible.value = true
}

// 确认发起审核
const handleSubmitReviewConfirm = async () => {
  try {
    await submitForReview(currentProcessForReview.value.id, submitReviewForm.reviewedRemark)
    ElMessage.success('发起审核成功')
    submitReviewDialogVisible.value = false
    // 重新加载当前计划的流程
    const currentPlan = submissionPlans.value.find(p => p.id === currentProcessForReview.value.planId)
    if (currentPlan) {
      await loadProcesses(currentPlan)
    }
  } catch (error) {
    ElMessage.error('发起审核失败')
    console.error('发起审核失败:', error)
  }
}

// 关闭发起审核对话框
const handleSubmitReviewDialogClose = () => {
  submitReviewDialogVisible.value = false
  currentProcessForReview.value = null
  submitReviewForm.reviewedRemark = ''
}

// 查询可选审核人
const querySelectableReviewers = async (query) => {
  reviewerLoading.value = true
  try {
    const response = await getSelectableReviewerUsers({
      nickName: query
    })
    selectableReviewers.value = response.data || []
  } catch (error) {
    console.error('获取审核人列表失败:', error)
  } finally {
    reviewerLoading.value = false
  }
}

// 查询可选投稿计划
const querySelectablePlans = async (query) => {
  planLoading.value = true
  try {
    const response = await listSubmissionPlansForSelect({ name: query })
    selectablePlans.value = response.data || []
  } catch (error) {
    console.error('获取投稿计划列表失败:', error)
  } finally {
    planLoading.value = false
  }
}

// 查询可选创建用户
const querySelectableCreators = async (query) => {
  creatorLoading.value = true
  try {
    const response = await getSelectableCreateUsers({ nickName: query })
    selectableCreators.value = response.data || []
  } catch (error) {
    console.error('获取创建用户列表失败:', error)
  } finally {
    creatorLoading.value = false
  }
}

// 查询可选参与用户
const querySelectableParticipantUser = async (query) => {
  participantUserLoading.value = true
  try {
    const response = await getSelectableCreateUsers({ nickName: query })
    selectableParticipantUsers.value = response.data || []
  } catch (error) {
    console.error('获取参与用户列表失败:', error)
    ElMessage.error('获取参与用户列表失败')
    selectableParticipantUsers.value = []
  } finally {
    participantUserLoading.value = false
  }
}

// 下载投稿流程文件
const downloadFile = async (fileId, fileName) => {
  try {
    const response = await downloadSubmissionProcessFile(fileId)
    // 创建下载链接并触发下载
    const blob = new Blob([response])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = fileName
    document.body.appendChild(link)
    link.click()
    // 清理
    window.URL.revokeObjectURL(url)
    document.body.removeChild(link)
  } catch (error) {
    ElMessage.error('文件下载失败')
    console.error('文件下载失败:', error)
  }
}

// 页面加载时初始化数据
onMounted(async () => {
  await loadSubmissionPlans()
})
</script>

<style scoped>
.submission-management {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.submission-list {
  margin-top: 20px;
}

.submission-item {
  margin-bottom: 10px;
}

.submission-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #f9f9f9;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submission-row:hover {
  background-color: #f0f0f0;
}

.left-content {
  display: flex;
  align-items: center;
  flex: 1;
  gap: 16px;
}

.right-buttons {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 8px;
}

.expand-btn-container {
  width: 24px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
}

.submission-name {
  font-weight: 600;
  font-size: 16px;
  color: #2c3e50;
  min-width: 150px;
  max-width: 250px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.journal-name {
  color: #606266;
  font-size: 14px;
  max-width: 200px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.processes {
  margin-left: 32px;
  margin-top: 8px;
}

.process-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.process-item {
  padding: 12px;
  background-color: #f5f7fa;
  border-radius: 6px;
  border-left: 4px solid #409eff;
}

.process-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
}

.process-name {
  font-weight: 500;
  font-size: 15px;
  color: #303133;
}

.process-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}

.loading {
  padding: 16px;
}

/* 展开/收起动画 */
.expand-enter-active,
.expand-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.expand-enter-from,
.expand-leave-to {
  max-height: 0;
  opacity: 0;
  transform: translateY(-10px);
}

/* 文件管理样式 */
.file-management {
  padding: 10px 0;
}

.process-info {
  margin-bottom: 20px;
  padding: 12px;
  background-color: #f8f9fa;
  border-radius: 6px;
  border-left: 4px solid #409eff;
}

.process-info h4 {
  margin: 0;
  color: #303133;
  font-weight: 600;
}

.upload-section {
  margin-bottom: 24px;
}

.upload-actions {
  margin-top: 12px;
  text-align: center;
}

.file-list-section {
  margin-top: 16px;
  max-height: 280px;
  overflow-y: auto;
}

.file-list-section h4 {
  margin-bottom: 16px;
  color: #303133;
  font-weight: 600;
}

.tag-title-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.tag-section-title {
  margin: 0;
  color: #303133;
  font-weight: 500;
  font-size: 15px;
}

.file-name {
  font-weight: 500;
  color: #409eff;
}

.files-label {
  font-size: 15px;
  color: #606266;
  margin-top: 5px;
}

.tag-label {
  font-size: 15px;
  color: #606266;
  margin-top: 5px;
}

.no-files {
  text-align: center;
}

/* 上传区域样式 */
:deep(.el-upload-dragger) {
  border: 2px dashed #d9d9d9;
  border-radius: 6px;
  width: 100%;
  height: 180px;
  transition: border-color 0.3s;
}

:deep(.el-upload-dragger:hover) {
  border-color: #409eff;
}

:deep(.el-icon--upload) {
  font-size: 48px;
  color: #c0c4cc;
  margin-bottom: 16px;
}

:deep(.el-upload__text) {
  color: #606266;
  font-size: 14px;
}

:deep(.el-upload__text em) {
  color: #409eff;
  font-style: normal;
}
</style>
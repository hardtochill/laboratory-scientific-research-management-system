<template>
  <div class="task-management">
    <!-- 查询表单 -->
      <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px" class="query-form">
        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="queryParams.taskName" placeholder="请输入任务名称" clearable style="width: 240px" @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="任务状态" prop="taskStatus">
          <el-select v-model="queryParams.taskStatus" placeholder="请选择任务状态" clearable style="width: 240px">
            <el-option label="未开始" :value="1" />
            <el-option label="进行中" :value="2" />
            <el-option label="已完成" :value="3" />
            <el-option label="已跳过" :value="4" />
          </el-select>
        </el-form-item>


        <el-form-item label="创建时间" style="width: 308px">
          <el-date-picker v-model="dateRange" value-format="YYYY-MM-DD HH:mm:ss" type="daterange" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 100%"></el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    <el-card>
      <template #header>
        <div class="card-header">
          <span>任务列表</span>
          <el-button type="primary" @click="handleAdd" v-if="isHasTeacherRole">
            <el-icon-plus /> 新增任务
          </el-button>
        </div>
      </template>
      <!-- 任务列表 -->
      <div class="task-list">
        <div v-for="task in parentTasks" :key="task.taskId" class="task-item">
          <!-- 任务行 -->
          <div class="task-row">
            <!-- 左侧内容区域 -->
            <div class="left-content">
              <!-- 展开/收起按钮容器 -->
          <div class="expand-btn-container">
            <el-button type="text" @click.stop="toggleSubTasks(task)"
              :icon="task.expanded ? CaretBottom : CaretRight" v-if="task.hasSubTasks"></el-button>
          </div>

              <!-- 任务名称 -->
              <span class="task-name">{{ task.taskName }}</span>

              <!-- 任务状态 -->
              <el-tag :type="getStatusType(task.taskStatus)" size="small" class="task-status">
                {{ getStatusText(task.taskStatus) }}
              </el-tag>

              <!-- 任务进度条 -->
              <div class="progress-container">
                <el-progress :percentage="getProgressPercentage(task)" :color="getProgressColor(task)"
                  :status="getProgressStatus(task)" :text-inside="true" style="font-size: 8px;" :stroke-width="11" striped striped-flow :duration="200"></el-progress>
              </div>
            </div>

            <!-- 右侧按钮区域 -->
        <div class="right-buttons">
          <!-- 新增子任务按钮 -->
          <el-tooltip content="新增子任务" placement="top" v-if="isHasTeacherRole">
            <el-button link type="primary" @click.stop="handleAddSubTask(task)" :icon="Plus"></el-button>
          </el-tooltip>
          <!-- 修改任务按钮 -->
          <el-tooltip content="任务详情" placement="top">
            <el-button link type="primary" @click.stop="showTaskDetail(task)" :icon="MoreFilled" style="margin-left: 0px;"></el-button>
          </el-tooltip>
          <!-- 修改状态下拉菜单 -->
          <el-tooltip content="更新任务状态" placement="top" v-if="isHasTeacherRole">
            <el-dropdown trigger="click" @command="(newStatus) => handleChangeStatus(task, newStatus)">
              <el-button link type="primary" :icon="Switch"></el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="1">未开始</el-dropdown-item>
                  <el-dropdown-item command="2">进行中</el-dropdown-item>
                  <el-dropdown-item command="3">已完成</el-dropdown-item>
                  <el-dropdown-item command="4">已跳过</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </el-tooltip>
          <!-- 删除任务按钮 -->
          <el-tooltip content="删除任务" placement="top" v-if="isHasTeacherRole">
            <el-button link type="primary" @click.stop="handleDeleteTask(task)" :icon="Delete"></el-button>
          </el-tooltip>
        </div>
          </div>

          <!-- 子任务列表（带动画效果） -->
          <transition name="expand">
            <div v-if="task.expanded" class="sub-tasks">
              <div class="loading" v-if="task.loading">
                <el-skeleton :rows="3" animated />
              </div>
              <div v-else>
                <TaskItem v-for="(subTask, subTaskIndex) in task.subTasks" :key="subTask.taskId" :task="subTask"
                  :task-index="subTaskIndex"
                  :is-first-level-task="false"
                  :expanded-task-ids="expandedTaskIds"
                  :is-has-teacher-role="isHasTeacherRole"
                  @show-detail="showTaskDetail" @add-sub-task="handleAddSubTask"
                  @update-expanded="handleUpdateExpanded"
                  @change-status="handleChangeStatus"
                  @delete-task="handleDeleteTask" />
              </div>
            </div>
          </transition>
        </div>
      </div>
      
      <!-- 分页控件 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :page-sizes="[5, 10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 任务详情对话框 -->
    <el-dialog v-model="dialogVisible" title="任务详情" width="600px" :before-close="handleClose">
      <div v-if="currentTask" class="task-detail">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="任务名称">
            {{ currentTask.taskName }}
          </el-descriptions-item>
          <el-descriptions-item label="任务描述">
            {{ currentTask.taskDescription || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="任务状态">
            <el-tag :type="getStatusType(currentTask.taskStatus)">
              {{ getStatusText(currentTask.taskStatus) }}
            </el-tag>
          </el-descriptions-item>

          <el-descriptions-item label="创建人">
            {{ currentTask.createNickName }}
          </el-descriptions-item>
          <el-descriptions-item label="参与用户">
            <span v-if="currentTask.participantUsers && currentTask.participantUsers.length > 0">
              {{ currentTask.participantUsers.map(user => `${user.nickName}(${user.userName})`).join(', ') }}
            </span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">
            {{ parseTime(currentTask.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="预期完成时间">
            {{ parseTime(currentTask.expectedFinishTime) || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="实际完成时间">
            {{ parseTime(currentTask.actualFinishTime) || '-' }}
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            {{ currentTask.taskRemark || '-' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleClose">关闭</el-button>
          <el-button type="primary" @click="handleEdit(currentTask)">修改</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 新增/修改任务对话框 -->
    <el-dialog v-model="formVisible" :title="formTitle" width="620px" :before-close="handleFormClose">
      <el-form :model="formData" ref="formRef" label-width="120px" :rules="formRules" class="task-form">
        <!-- 隐藏字段 -->
        <el-form-item prop="taskId" style="display: none;">
          <el-input v-model="formData.taskId" type="hidden" />
        </el-form-item>

        <!-- 任务名称 -->
        <el-form-item label="任务名称" prop="taskName">
          <el-input v-model="formData.taskName" placeholder="请输入任务名称" maxlength="50" show-word-limit />
        </el-form-item>

        <!-- 任务描述 -->
        <el-form-item label="任务描述" prop="taskDescription">
          <el-input v-model="formData.taskDescription" type="textarea" placeholder="请输入任务描述" :rows="3" maxlength="255" show-word-limit />
        </el-form-item>

        <!-- 任务状态 -->
        <el-form-item label="任务状态" prop="taskStatus">
          <!-- 对于teacher角色用户显示可编辑的下拉框 -->
          <el-select v-if="isHasTeacherRole" v-model="formData.taskStatus" placeholder="请选择任务状态" style="width: 100%;">
            <el-option label="未开始" value="1" />
            <el-option label="进行中" value="2" />
            <el-option label="已完成" value="3" />
            <el-option label="已跳过" value="4" />
          </el-select>
          <!-- 对于非teacher角色用户显示只读标签 -->
          <el-tag v-else :type="getStatusType(formData.taskStatus)">
            {{ getStatusText(formData.taskStatus) }}
          </el-tag>
        </el-form-item>

        <!-- 执行用户组 -->
        <el-form-item label="执行用户组" prop="participantUserIds">
          <div v-if="isReadOnlyUserGroup || !isHasTeacherRole" style="margin-bottom: 8px;">
            <el-tag type="info" size="small">
              <el-icon><InfoFilled /></el-icon>
              <span v-if="!isHasTeacherRole">
                <span v-if="!isChildTask">无权修改执行用户</span>
                <span v-else>该任务继承父任务的用户组，不可修改</span>
              </span>
              <span v-else>
                <span v-if="isChildTask">该任务继承父任务的用户组，不可修改</span>
              </span>
            </el-tag>
          </div>
          <el-select 
            v-model="formData.participantUserIds" 
            multiple 
            filterable 
            remote 
            reserve-keyword
            placeholder="请选择执行用户组" 
            style="width: 100%;"
            :remote-method="querySelectableUsers"
            :loading="userLoading"
            :disabled="isReadOnlyUserGroup || !isHasTeacherRole"
            @focus="handleSelectFocus"
          >
            <el-option
              v-for="user in ungraduatedUsers"
              :key="user.userId"
              :label="`${user.nickName}(${user.userName})`"
              :value="user.userId"
            />
          </el-select>
        </el-form-item>

        <!-- 预期完成时间 -->
        <el-form-item label="预期完成时间" prop="expectedFinishTime">
          <el-date-picker v-model="formData.expectedFinishTime" type="datetime" placeholder="请选择预期完成时间" style="width: 100%;" />
        </el-form-item>

        <!-- 实际完成时间 -->
        <el-form-item label="实际完成时间" prop="actualFinishTime">
          <el-date-picker v-model="formData.actualFinishTime" type="datetime" placeholder="请选择实际完成时间" style="width: 100%;" />
        </el-form-item>

        <!-- 任务备注 -->
        <el-form-item label="备注" prop="taskRemark">
          <el-input v-model="formData.taskRemark" type="textarea" placeholder="请输入备注信息" :rows="3" maxlength="255" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="handleFormClose">取消</el-button>
          <el-button type="primary" @click="handleFormSubmit">保存</el-button>
      </div>
    </template>
  </el-dialog>
</div>
</template>

<script setup>
import { ref, onMounted, reactive, toRefs } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getList, getSubTasks, getTaskDetail, addTask, updateTask, updateTaskStatus, deleteTask, getTaskParticipantUsers, getSelectableUsers } from '@/api/task/task'
import TaskItem from './components/TaskItem.vue'
import { parseTime, addDateRange } from '@/utils/ruoyi'
import { CaretRight,CaretBottom,Plus, MoreFilled,Switch, Delete, InfoFilled } from '@element-plus/icons-vue'
import useUserStore from '@/store/modules/user'

// 任务状态枚举
const TASK_STATUS = {
  PENDING: 1,
  PROCESSING: 2,
  FINISHED: 3,
  SKIPPED: 4
}

// 任务状态类型映射
const getStatusType = (status) => {
  // 将状态转换为数字类型进行比较
  const numStatus = parseInt(status)
  switch (numStatus) {
    case TASK_STATUS.PENDING:
      return 'info'
    case TASK_STATUS.PROCESSING:
      return 'warning'
    case TASK_STATUS.FINISHED:
      return 'success'
    case TASK_STATUS.SKIPPED:
      return 'danger'
    default:
      return 'info'
  }
}

// 任务状态文本映射
const getStatusText = (status) => {
  // 将状态转换为数字类型进行比较
  const numStatus = parseInt(status)
  switch (numStatus) {
    case TASK_STATUS.PENDING:
      return '未开始'
    case TASK_STATUS.PROCESSING:
      return '进行中'
    case TASK_STATUS.FINISHED:
      return '已完成'
    case TASK_STATUS.SKIPPED:
      return '已跳过'
    default:
      return '未知状态'
  }
}

// 使用后端返回的进度百分比
const getProgressPercentage = (task) => {
  // 确保task对象有效
  if (!task) return 0
  
  // 使用后端返回的percentage字段，如果不存在则默认为0%
  return task.percentage !== undefined ? task.percentage : 0
}

// 任务进度颜色
const getProgressColor = (task) => {
  // 确保task对象有效
  if (!task) return '#909399'
  
  // 根据任务状态决定颜色
  switch (task.taskStatus) {
    case TASK_STATUS.PENDING:
      return '#909399'
    case TASK_STATUS.PROCESSING:
      return '#E6A23C'
    case TASK_STATUS.FINISHED:
      return '#67C23A'
    case TASK_STATUS.SKIPPED:
      return '#F56C6C'
    default:
      return '#909399'
  }
}

// 任务进度状态
const getProgressStatus = (task) => {
  // 确保task对象有效
  if (!task) return 'normal'
  
  // 根据任务状态决定进度条状态
  switch (task.taskStatus) {
    case TASK_STATUS.FINISHED:
      return 'success'
    case TASK_STATUS.SKIPPED:
      return 'exception'
    case TASK_STATUS.PROCESSING:
      return 'active'
    default:
      return 'normal'
  }
}

// 父任务列表
const parentTasks = ref([])
// 任务详情对话框可见性
const dialogVisible = ref(false)
// 当前选中的任务
const currentTask = ref(null)

// 用户角色信息
const userStore = useUserStore()
const userRoles = ref([])
const isHasTeacherRole = ref(false)

// 检查用户是否含有teacher角色
const checkUserRoles = () => {
  userRoles.value = userStore.roles || []
  isHasTeacherRole.value = userRoles.value.some(role => 
    role === 'teacher' || 
    role.includes('teacher') || 
    role.roleName === 'teacher' ||
    role.roleKey === 'teacher'
  )
  console.log('用户角色:', userRoles.value)
  console.log('是否含有teacher角色:', isHasTeacherRole.value)
}
// 加载状态
const loading = ref(true)
// 日期范围
const dateRange = ref([])
// 新增/修改任务对话框可见性
const formVisible = ref(false)
// 表单标题
const formTitle = ref('新增任务')
// 表单引用
const formRef = ref(null)
// 是否为子任务
const isChildTask = ref(false)
// 用户组字段是否为只读（非一级父任务）
const isReadOnlyUserGroup = ref(false)
// 父任务ID
const parentTaskId = ref(0)
// 未毕业用户列表
const ungraduatedUsers = ref([])
// 用户加载状态
const userLoading = ref(false)

// 表单数据
const formData = reactive({
  taskId: undefined,
  parentTaskId: '0', // 默认一级任务
  taskName: '',
  taskDescription: '',
  taskStatus: '1', // 默认未开始
  participantUserIds: [], // 参与用户ID列表
  expectedFinishTime: null,
  actualFinishTime: null,
  taskRemark: ''
})
// 表单验证规则
const formRules = reactive({
  taskName: [
    { required: true, message: '请输入任务名称', trigger: 'blur' },
    { min: 1, max: 50, message: '长度在 1 到 50 个字符', trigger: 'blur' }
  ],
  taskStatus: [
    { required: true, message: '请选择任务状态', trigger: 'change' }
  ],
  participantUserIds: []
})

// 响应式数据
const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    taskName: undefined,
    taskStatus: 2
  },
  total: 0
})

const { queryParams, total } = toRefs(data)

// 保存展开任务ID的集合，作为组件状态的一部分
const expandedTaskIds = ref(new Set())

// 收集所有展开任务的ID（递归）
const collectExpandedTaskIds = (tasks) => {
  const ids = new Set()
  
  const traverse = (taskList) => {
    taskList.forEach(task => {
      if (task.expanded) {
        ids.add(task.taskId)
        // 如果有子任务且已加载，继续遍历
        if (task.subTasks && task.subTasks.length > 0) {
          traverse(task.subTasks)
        }
      }
    })
  }
  
  traverse(tasks)
  return ids
}

// 恢复任务的展开状态（递归）
const restoreExpandedStatus = async (tasks) => {
  for (const task of tasks) {
    if (expandedTaskIds.value.has(task.taskId)) {
      task.expanded = true
      // 自动加载子任务，保持展开状态
      await loadSubTasks(task)
      // 恢复子任务的展开状态
      if (task.subTasks && task.subTasks.length > 0) {
        await restoreExpandedStatus(task.subTasks)
      }
    }
  }
}

// 加载父任务列表（带分页）
const loadParentTasks = async () => {
  loading.value = true
  try {
    // 在重新加载前保存当前所有展开任务的ID
    expandedTaskIds.value = collectExpandedTaskIds(parentTasks.value)
    
    // 手动添加日期范围参数，使用后端期望的参数名
    const params = { ...queryParams.value };
    if (dateRange.value && dateRange.value.length === 2) {
      params.createTimeStart = dateRange.value[0];
      params.createTimeEnd = dateRange.value[1];
    }
    const response = await getList(params)
    // 为每个任务添加扩展属性，添加空值检查
    parentTasks.value = (response.rows || []).map((task) => ({
      ...task,
      expanded: false,
      loading: false,
      // 保留后端返回的hasSubTasks和percentage字段
      hasSubTasks: task.hasSubTasks !== undefined ? task.hasSubTasks : false,
      subTasks: []
    }))
    // 更新总条数
    total.value = response.total || 0
    
    // 恢复之前展开的任务状态
    await restoreExpandedStatus(parentTasks.value)
  } catch (error) {
    ElMessage.error('加载任务列表失败')
    console.error('加载任务列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 查询按钮操作
const handleQuery = () => {
  queryParams.value.pageNum = 1
  loadParentTasks()
}

// 重置按钮操作
const resetQuery = () => {
  dateRange.value = []
  queryParams.value = {
    pageNum: 1,
    pageSize: 10,
    taskName: undefined,
    taskStatus: undefined,
    visibleType: undefined,
    executeNickName: undefined
  }
  handleQuery()
}

// 获取可供选择的用户列表
const querySelectableUsers = async (query) => {
  userLoading.value = true
  try {
    const response = await getSelectableUsers({
      nickName: query
    })
    ungraduatedUsers.value = response.data || []
  } catch (error) {
    console.error('获取用户列表失败:', error)
  } finally {
    userLoading.value = false
  }
}

// 处理下拉框获取焦点事件（加载所有未毕业用户）
const handleSelectFocus = async () => {
  await querySelectableUsers('')
}

// 初始化用户列表
const initUserList = async () => {
  try {
    const response = await getSelectableUsers()
    ungraduatedUsers.value = response.data || []
  } catch (error) {
    console.error('初始化用户列表失败:', error)
  }
}

// 分页变化处理
const handleSizeChange = (newSize) => {
  queryParams.value.pageSize = newSize
  loadParentTasks()
}

const handleCurrentChange = (newNum) => {
  queryParams.value.pageNum = newNum
  loadParentTasks()
}

// 切换子任务显示/隐藏
const toggleSubTasks = async (task) => {
  if (!task.expanded) {
    // 加载子任务
    await loadSubTasks(task)
  }
  task.expanded = !task.expanded
  
  // 实时更新展开任务ID集合
  if (task.expanded) {
    expandedTaskIds.value.add(task.taskId)
  } else {
    expandedTaskIds.value.delete(task.taskId)
  }
}

// 处理子组件更新展开状态的事件
const handleUpdateExpanded = (data) => {
  if (data.expanded) {
    expandedTaskIds.value.add(data.taskId)
  } else {
    expandedTaskIds.value.delete(data.taskId)
  }
}

// 加载子任务
const loadSubTasks = async (parentTask) => {
  if (!parentTask.loading && parentTask.subTasks.length === 0) {
    try {
      parentTask.loading = true
      const response = await getSubTasks(parentTask.taskId)
      parentTask.subTasks = (response.data || []).map((task) => ({
        ...task,
        expanded: expandedTaskIds.value.has(task.taskId), // 检查是否在展开集合中
        loading: false,
        hasSubTasks: task.hasSubTasks !== undefined ? task.hasSubTasks : false, // 使用后端返回的值，默认false
        subTasks: [],
        parentTaskId: parentTask.taskId
      }))
    } catch (error) {
      ElMessage.error('加载子任务失败')
      console.error('加载子任务失败:', error)
    } finally {
      parentTask.loading = false
    }
  }
}

// 显示任务详情
const showTaskDetail = async (task) => {
  try {
    const response = await getTaskDetail(task.taskId)
    currentTask.value = response.data || null
    dialogVisible.value = true
  } catch (error) {
    ElMessage.error('加载任务详情失败')
    console.error('加载任务详情失败:', error)
  }
}

// 新增任务
const handleAdd = () => {
  // 重置表单
  resetForm()
  // 设置表单标题
  formTitle.value = '新增任务'
  // 设置为一级任务
  isChildTask.value = false
  isReadOnlyUserGroup.value = false // 一级任务的用户组字段可编辑
  parentTaskId.value = 0
  // 打开表单
  formVisible.value = true
}

// 删除任务
const handleDeleteTask = async (task) => {
  try {
    // 确认提示框
    await ElMessageBox.confirm('删除该任务会级联删除所有子任务', '删除确认', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    // 调用删除任务API
    await deleteTask(task.taskId)
    
    // 提示删除成功
    ElMessage.success('任务删除成功')
    
    // 重新加载任务列表
    await loadParentTasks()
  } catch (error) {
    // 如果是用户取消删除，则不显示错误提示
    if (error !== 'cancel') {
      ElMessage.error('任务删除失败: ' + (error.message || '未知错误'))
      console.error('删除任务失败:', error)
    }
  }
}

// 修改任务
const handleEdit = (task) => {
  // 关闭详情对话框
  dialogVisible.value = false
  // 重置表单
  resetForm()
  // 设置表单标题
  formTitle.value = '修改任务'
  
  // 判断是否为子任务（非一级父任务）
  const isSubTask = task.parentTaskId && task.parentTaskId !== '0'
  isChildTask.value = isSubTask
  
  // 非一级父任务（深度>1）的用户组字段为只读
  isReadOnlyUserGroup.value = isSubTask
  
  // 填充表单数据
  Object.assign(formData, {
    taskId: task.taskId,
    parentTaskId: task.parentTaskId || '0',
    taskName: task.taskName,
    taskDescription: task.taskDescription,
    taskStatus: String(task.taskStatus), 
    expectedFinishTime: task.expectedFinishTime ? new Date(task.expectedFinishTime) : null,
    actualFinishTime: task.actualFinishTime ? new Date(task.actualFinishTime) : null,
    taskRemark: task.taskRemark
  })
  
  // 加载任务的参与用户组
  loadTaskParticipantUsers(task.taskId)
  
  // 打开表单
  formVisible.value = true
}

// 加载任务的参与用户组
const loadTaskParticipantUsers = async (taskId) => {
  try {
    const response = await getTaskParticipantUsers(taskId)
    const participantUsers = response.data || []
    // 设置已选择的用户组
    formData.participantUserIds = participantUsers.map(user => user.userId)
  } catch (error) {
    console.error('加载任务参与用户组失败:', error)
  }
}

// 重置表单
const resetForm = () => {
  if (formRef.value) {
    formRef.value.resetFields()
  }
  // 重置表单数据
  Object.assign(formData, {
    taskId: undefined,
    parentTaskId: '0', // 默认一级任务
    taskName: '',
    taskDescription: '',
    taskStatus: '1',
    participantUserIds: [],
    expectedFinishTime: null,
    actualFinishTime: null,
    taskRemark: ''
  })
  // 重置用户组相关状态
  isChildTask.value = false
  isReadOnlyUserGroup.value = false
  parentTaskId.value = 0
}

// 关闭表单
const handleFormClose = () => {
  formVisible.value = false
  resetForm()
}

// 修改任务状态
const handleChangeStatus = async (task, newStatus) => {
  try {
    // 调用接口修改任务状态
    await updateTaskStatus({
      taskId: task.taskId,
      taskStatus: newStatus
    })
    // 显示成功消息
    ElMessage.success('任务状态修改成功')
    // 重新加载任务列表
    loadParentTasks()
  } catch (error) {
    ElMessage.error('任务状态修改失败')
    console.error('任务状态修改失败:', error)
  }
}



// 提交表单
const handleFormSubmit = async () => {
  if (!formRef.value) return
  try {
    // 表单验证
    await formRef.value.validate()
    // 准备提交数据
    const submitData = {
      ...formData,
      // 确保parentTaskId为0时是数字类型
      parentTaskId: formData.parentTaskId === '0' ? 0 : formData.parentTaskId
    }
    // 调用API
    if (formData.taskId) {
      // 修改任务
      await updateTask(submitData)
    } else {
      // 新增任务
      await addTask(submitData)
    }
    ElMessage.success('保存成功')
    // 关闭表单
    formVisible.value = false
    // 刷新任务列表
    loadParentTasks()
  } catch (error) {
    if (error === false) {
      // 表单验证失败，不处理
      return
    }
    ElMessage.error('保存失败：' + (error.message || '未知错误'))
    console.error('保存任务失败:', error)
  }
}

// 关闭对话框
const handleClose = () => {
  dialogVisible.value = false
  currentTask.value = null
}



// 新增子任务
const handleAddSubTask = async (parentTask) => {
  // 重置表单
  resetForm()
  // 设置表单标题
  formTitle.value = '新增子任务'
  // 设置为子任务
  isChildTask.value = true
  isReadOnlyUserGroup.value = true // 子任务的用户组字段为只读
  parentTaskId.value = parentTask.taskId
  // 设置父任务ID
  formData.parentTaskId = parentTask.taskId
  
  try {
    // 加载父任务的参与用户组
    const response = await getTaskParticipantUsers(parentTask.taskId)
    const participantUsers = response.data || []
    // 设置子任务继承父任务的用户组
    formData.participantUserIds = participantUsers.map(user => user.userId)
  } catch (error) {
    ElMessage.error('加载父任务用户组失败')
    console.error('加载父任务用户组失败:', error)
  }
  
  // 打开表单
  formVisible.value = true
}

// 页面加载时初始化数据
onMounted(async () => {
  loadParentTasks()
  await initUserList()
  checkUserRoles() // 检查用户角色权限
})
</script>

<style scoped>
.task-management {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.task-list {
  margin-top: 20px;
}

.task-item {
  margin-bottom: 10px;
}

.task-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background-color: #f9f9f9;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.task-row:hover {
  background-color: #f0f0f0;
}

.left-content {
  display: flex;
  align-items: center;
  flex: 1;
}

.right-buttons {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  gap: 8px;
}

.task-name {
  flex: 0 1 auto;
  margin: 0 16px 0 0;
  font-weight: 600;
  font-size: 16px;
  color: #2c3e50;
  min-width: 100px;
  max-width: 300px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.task-status {
  margin: 0 16px;
  width: 70px;
  text-align: center;
  flex-shrink: 0;
}

.expand-btn-container {
  width: 24px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
}

.progress-container {
  flex: 3.6;
  margin: 0 16px 0 0;
  min-width: 200px;
  max-width: 800px;
  animation: fadeIn 0.5s ease-in;
  flex-shrink: 1;
}

.sub-tasks {
  margin-left: 32px;
  margin-top: 8px;
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

/* 淡入动画 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.task-detail {
  padding: 10px 0;
}
</style>

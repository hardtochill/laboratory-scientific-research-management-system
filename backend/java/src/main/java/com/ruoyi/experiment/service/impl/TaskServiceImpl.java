package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.constant.TaskConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.enums.TaskStatusEnum;
import com.ruoyi.experiment.enums.UserGraduateFlagEnum;
import com.ruoyi.experiment.mapper.TaskExecutorMapper;
import com.ruoyi.experiment.mapper.TaskFileMapper;
import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.mapper.TaskReportFileMapper;
import com.ruoyi.experiment.mapper.TaskUserMapper;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.entity.TaskExecutor;
import com.ruoyi.experiment.pojo.vo.TaskDetailVO;
import com.ruoyi.experiment.pojo.vo.TaskListWithExpandVO;
import com.ruoyi.experiment.pojo.vo.TaskStatusStats;
import com.ruoyi.experiment.pojo.vo.TaskStatisticsVO;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.domain.dto.UserForSelectQueryDTO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.SetUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {
    private final TaskMapper taskMapper;
    private final SysUserMapper userMapper;
    private final TaskUserMapper taskUserMapper;
    private final TaskFileMapper taskFileMapper;
    private final TaskReportFileMapper taskReportFileMapper;
    private final ExperimentConfig experimentConfig;
    private final TaskExecutorMapper taskExecutorMapper;
    @Override
    public TaskStatisticsVO selectParentTaskListWithStatistics(TaskQueryDTO taskQueryDTO) {
        log.info("任务管理模块-查询父任务列表：{}",taskQueryDTO);
        // 1.获取分页的任务列表
        TaskListWithExpandVO listWithExpand = selectParentTaskListWithExpand(taskQueryDTO);
        List<TaskVO> tasks = listWithExpand.getTasks();
        List<Long> expandTaskIds = listWithExpand.getExpandTaskIds();
        
        // 2.为每个任务加载参与用户信息和执行人信息
        for (TaskVO task : tasks) {
            List<SysUser> participantUsers = taskUserMapper.selectUsersByTaskId(task.getTaskId());
            task.setParticipantUsers(participantUsers);
            
            // 加载执行人信息
            if (task.getExecutorUserId() != null) {
                SysUser executorUser = userMapper.selectUserById(task.getExecutorUserId());
                task.setExecutorUser(executorUser);
            }
        }

        // 3.统计各状态任务个数——依赖除任务状态外的查询条件
        Long pendingCount = 0L;
        Long processingCount = 0L;
        Long finishedCount = 0L;
        Long skippedCount = 0L;
        
        List<TaskVO> tasksForStatistics;
        
        // 如果提交的查询条件有任务状态，则先把任务状态置为null再依赖查询条件的结果进行统计
        if (taskQueryDTO.getTaskStatus() != null) {
            // 创建新的查询DTO，保留除任务状态外的其他所有条件
            TaskQueryDTO statisticsQueryDTO = new TaskQueryDTO();
            BeanUtils.copyProperties(taskQueryDTO, statisticsQueryDTO);
            statisticsQueryDTO.setTaskStatus(null);
            
            // 查询符合条件（除任务状态外）的所有任务用于统计
            tasksForStatistics = selectParentTaskListForStatistics(statisticsQueryDTO);
        } else {
            // 如果没有选择任务状态，则直接使用当前查询结果进行统计
            tasksForStatistics = tasks;
        }
        
        // 统计各状态任务个数
        for (TaskVO task : tasksForStatistics) {
            if(TaskStatusEnum.PENDING.getStatus().equals(task.getTaskStatus())){
                pendingCount++;
            }else if(TaskStatusEnum.PROCESSING.getStatus().equals(task.getTaskStatus())){
                processingCount++;
            }else if(TaskStatusEnum.FINISHED.getStatus().equals(task.getTaskStatus())){
                finishedCount++;
            }else if(TaskStatusEnum.SKIPPED.getStatus().equals(task.getTaskStatus())){
                skippedCount++;
            }
        }
        
        // 4.创建返回结果
        TaskStatisticsVO result = new TaskStatisticsVO();
        result.setList(tasks);
        result.setPendingCount(pendingCount);
        result.setProcessingCount(processingCount);
        result.setFinishedCount(finishedCount);
        result.setSkippedCount(skippedCount);
        result.setTotal((long) tasks.size());
        result.setExpandTaskIds(expandTaskIds);
        
        return result;
    }
    
    private TaskListWithExpandVO selectParentTaskListWithExpand(TaskQueryDTO taskQueryDTO) {
        List<Long> expandTaskIds = new ArrayList<>();
        Set<Long> targetExecutorTaskIds = new HashSet<>();
        Set<Long> targetCreatorTaskIds = new HashSet<>();
        List<TaskVO> tasks;
        
        // 检查是否是学生用户且有指定的任务类型
        if (SecurityUtils.isStudent() && taskQueryDTO.getStudentTaskType() != null) {
            Long userId = SecurityUtils.getUserId();
            switch (taskQueryDTO.getStudentTaskType()) {
                case "executor":
                    // 我执行的任务
                    tasks = getTasksForExecutor(userId, expandTaskIds, targetExecutorTaskIds);
                    break;
                case "creator":
                    // 我创建的任务
                    tasks = getTasksForCreator(userId, expandTaskIds, targetCreatorTaskIds);
                    break;
                case "participant":
                default:
                    // 我参与的任务（默认逻辑）
                    taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
                    taskQueryDTO.setUserId(userId);
                    tasks = taskMapper.select(taskQueryDTO);
                    // 清空展开列表，不展开任何任务
                    expandTaskIds.clear();
                    break;
            }
        } else {
            // 原有的逻辑
            taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
            if(SecurityUtils.isStudent()){
                taskQueryDTO.setUserId(SecurityUtils.getUserId());
            }
            tasks = taskMapper.select(taskQueryDTO);
        }
        
        // 2.计算子任务状态
        // calculateTaskList(tasks);
        
        // 更新percentage字段，直接使用taskPercentage
        for (TaskVO task : tasks) {
            task.setPercentage(task.getTaskPercentage() != null ? task.getTaskPercentage() : 0);
        }
        
        // 检查是否有子任务
        List<Long> parentIdsHaveSubTasks = taskMapper.selectParentIdsHaveSubTasks(tasks.stream().map(TaskVO::getTaskId).collect(Collectors.toList()));
        for (TaskVO task : tasks) {
            task.setHasSubTasks(parentIdsHaveSubTasks.contains(task.getTaskId()));
        }
        
        // 统计子任务状态数量和查询参与用户
        Long currentUserId = SecurityUtils.isStudent() ? SecurityUtils.getUserId() : null;
        for (TaskVO task : tasks) {
            TaskStatusStats stats = calculateSubTaskStatusStats(task.getTaskId());
            task.setSubTaskStatusStats(stats);
            
            // 查询参与用户
            List<SysUser> participants = taskUserMapper.selectUsersByTaskId(task.getTaskId());
            task.setParticipantUsers(participants);
            
            // 加载执行人信息
            if (task.getExecutorUserId() != null) {
                SysUser executorUser = userMapper.selectUserById(task.getExecutorUserId());
                task.setExecutorUser(executorUser);
            }
            
            // 为学生用户检查任务是否是当前用户执行的或创建的
            if (currentUserId != null) {
                if (task.getExecutorUserId() != null && task.getExecutorUserId().equals(currentUserId)) {
                    task.setIsCurrentUserExecutor(true);
                }
                if (task.getCreateUserId() != null && task.getCreateUserId().equals(currentUserId)) {
                    task.setIsCurrentUserCreator(true);
                }
            }
        }
        
        // 按任务状态自定义排序：进行中、未开始、已完成、已跳过
        tasks.sort((task1, task2) -> {
            Integer status1 = task1.getTaskStatus();
            Integer status2 = task2.getTaskStatus();
            
            // 定义状态优先级
            int priority1 = getStatusPriority(status1);
            int priority2 = getStatusPriority(status2);
            
            return Integer.compare(priority1, priority2);
        });
        
        return new TaskListWithExpandVO(tasks, expandTaskIds);
    }
    
    /**
     * 查询父任务列表（用于统计，只获取基础数据）
     */
    private List<TaskVO> selectParentTaskListForStatistics(TaskQueryDTO taskQueryDTO) {
        List<TaskVO> tasks;
        
        // 检查是否是学生用户且有指定的任务类型
        if (SecurityUtils.isStudent() && taskQueryDTO.getStudentTaskType() != null) {
            Long userId = SecurityUtils.getUserId();
            switch (taskQueryDTO.getStudentTaskType()) {
                case "executor":
                    // 我执行的任务（只获取顶级父任务，不展开，不添加标识）
                    tasks = getTasksForExecutorForStatistics(userId);
                    break;
                case "creator":
                    // 我创建的任务（只获取顶级父任务，不展开，不添加标识）
                    tasks = getTasksForCreatorForStatistics(userId);
                    break;
                case "participant":
                default:
                    // 我参与的任务（默认逻辑）
                    taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
                    taskQueryDTO.setUserId(userId);
                    tasks = taskMapper.select(taskQueryDTO);
                    break;
            }
        } else {
            // 原有的逻辑
            taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
            if(SecurityUtils.isStudent()){
                taskQueryDTO.setUserId(SecurityUtils.getUserId());
            }
            tasks = taskMapper.select(taskQueryDTO);
        }
        
        return tasks;
    }
    
    /**
     * 获取用户作为执行人的任务（用于统计）
     */
    private List<TaskVO> getTasksForExecutorForStatistics(Long userId) {
        List<TaskVO> executorTasks = taskMapper.selectTasksByExecutorUserId(userId);
        Set<Long> topParentIds = new HashSet<>();
        
        // 找出所有顶级父任务
        for (TaskVO task : executorTasks) {
            Long topParentId = findTopParentId(task.getTaskId());
            topParentIds.add(topParentId);
        }
        
        // 查询顶级父任务
        TaskQueryDTO queryDTO = new TaskQueryDTO();
        queryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        List<TaskVO> allTopTasks = taskMapper.select(queryDTO);
        
        // 只保留我们需要的顶级父任务
        return allTopTasks.stream()
                .filter(task -> topParentIds.contains(task.getTaskId()))
                .collect(Collectors.toList());
    }
    
    /**
     * 获取用户作为创建人的任务（用于统计）
     */
    private List<TaskVO> getTasksForCreatorForStatistics(Long userId) {
        List<TaskVO> creatorTasks = taskMapper.selectTasksByCreateUserId(userId);
        Set<Long> topParentIds = new HashSet<>();
        
        // 找出所有顶级父任务
        for (TaskVO task : creatorTasks) {
            Long topParentId = findTopParentId(task.getTaskId());
            topParentIds.add(topParentId);
        }
        
        // 查询顶级父任务
        TaskQueryDTO queryDTO = new TaskQueryDTO();
        queryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        List<TaskVO> allTopTasks = taskMapper.select(queryDTO);
        
        // 只保留我们需要的顶级父任务
        return allTopTasks.stream()
                .filter(task -> topParentIds.contains(task.getTaskId()))
                .collect(Collectors.toList());
    }

    /**
     * 获取用户作为执行人的任务
     */
    private List<TaskVO> getTasksForExecutor(Long userId, List<Long> expandTaskIds, Set<Long> targetExecutorTaskIds) {
        List<TaskVO> executorTasks = taskMapper.selectTasksByExecutorUserId(userId);
        Set<Long> topParentIds = new HashSet<>();
        
        // 找出所有顶级父任务
        for (TaskVO task : executorTasks) {
            Long topParentId = findTopParentId(task.getTaskId());
            topParentIds.add(topParentId);
            targetExecutorTaskIds.add(task.getTaskId());
            // 记录从顶级父任务到当前任务的路径上的所有任务ID，用于展开
            collectExpandPath(task.getTaskId(), expandTaskIds);
        }
        
        // 查询顶级父任务
        TaskQueryDTO queryDTO = new TaskQueryDTO();
        queryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        List<TaskVO> allTopTasks = taskMapper.select(queryDTO);
        
        // 只保留我们需要的顶级父任务
        List<TaskVO> result = allTopTasks.stream()
                .filter(task -> topParentIds.contains(task.getTaskId()))
                .collect(Collectors.toList());
        
        // 为所有任务添加标识
        markTargetTasks(result, targetExecutorTaskIds, "executor");
        
        return result;
    }

    /**
     * 获取用户作为创建人的任务
     */
    private List<TaskVO> getTasksForCreator(Long userId, List<Long> expandTaskIds, Set<Long> targetCreatorTaskIds) {
        List<TaskVO> creatorTasks = taskMapper.selectTasksByCreateUserId(userId);
        Set<Long> topParentIds = new HashSet<>();
        
        // 找出所有顶级父任务
        for (TaskVO task : creatorTasks) {
            Long topParentId = findTopParentId(task.getTaskId());
            topParentIds.add(topParentId);
            targetCreatorTaskIds.add(task.getTaskId());
            // 记录从顶级父任务到当前任务的路径上的所有任务ID，用于展开
            collectExpandPath(task.getTaskId(), expandTaskIds);
        }
        
        // 查询顶级父任务
        TaskQueryDTO queryDTO = new TaskQueryDTO();
        queryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        List<TaskVO> allTopTasks = taskMapper.select(queryDTO);
        
        // 只保留我们需要的顶级父任务
        List<TaskVO> result = allTopTasks.stream()
                .filter(task -> topParentIds.contains(task.getTaskId()))
                .collect(Collectors.toList());
        
        // 为所有任务添加标识
        markTargetTasks(result, targetCreatorTaskIds, "creator");
        
        return result;
    }

    /**
     * 为任务列表中的目标任务添加标识
     */
    private void markTargetTasks(List<TaskVO> tasks, Set<Long> targetTaskIds, String type) {
        for (TaskVO task : tasks) {
            if (targetTaskIds.contains(task.getTaskId())) {
                if ("executor".equals(type)) {
                    task.setIsCurrentUserExecutor(true);
                } else if ("creator".equals(type)) {
                    task.setIsCurrentUserCreator(true);
                }
            }
        }
    }

    /**
     * 查找任务的顶级父任务ID
     */
    private Long findTopParentId(Long taskId) {
        Long currentId = taskId;
        Task task;
        while (true) {
            task = taskMapper.selectTaskById(currentId);
            if (task == null || task.getParentTaskId() == null || 
                task.getParentTaskId().equals(TaskConstants.FIRST_PARENT_TASK_ID)) {
                return currentId;
            }
            currentId = task.getParentTaskId();
        }
    }

    /**
     * 收集从指定任务到顶级父任务路径上的所有任务ID，用于展开
     */
    private void collectExpandPath(Long taskId, List<Long> expandTaskIds) {
        Long currentId = taskId;
        Task task;
        while (true) {
            task = taskMapper.selectTaskById(currentId);
            if (task == null) {
                break;
            }
            expandTaskIds.add(currentId);
            if (task.getParentTaskId() == null || 
                task.getParentTaskId().equals(TaskConstants.FIRST_PARENT_TASK_ID)) {
                break;
            }
            currentId = task.getParentTaskId();
        }
    }

    private List<TaskVO> selectParentTaskList(TaskQueryDTO taskQueryDTO) {
        TaskListWithExpandVO result = selectParentTaskListWithExpand(taskQueryDTO);
        return result.getTasks();
    }
    
    /**
     * 获取任务状态的排序优先级
     * @param status 任务状态
     * @return 优先级数值，数值越小优先级越高
     */
    private int getStatusPriority(Integer status) {
        if (status == null) {
            return 999; // 空状态放最后
        }
        switch (status) {
            case 2: // 进行中
                return 1;
            case 1: // 未开始
                return 2;
            case 3: // 已完成
                return 3;
            case 4: // 已跳过
                return 4;
            default:
                return 999; // 其他状态放最后
        }
    }

    @Override
    public List<TaskVO> selectSubTaskList(Long parentTaskId) {
        log.info("任务管理模块-查询子任务列表：{}",parentTaskId);
        TaskQueryDTO taskQueryDTO = new TaskQueryDTO();
        taskQueryDTO.setParentTaskId(parentTaskId);
        // 学生用户只能查自己参与的任务；教师用户可以查所有任务
        Long currentUserId = null;
        if(SecurityUtils.isStudent()){
            currentUserId = SecurityUtils.getUserId();
            taskQueryDTO.setUserId(currentUserId);
        }
        taskQueryDTO.setOrderBy(TaskConstants.SUB_TASK_ORDER_BY);
        taskQueryDTO.setOrderDirection(TaskConstants.SUB_TASK_ORDER_DIRECTION);
        List<TaskVO> tasks = taskMapper.select(taskQueryDTO);
        // calculateTaskList(tasks);
        
        // 更新percentage字段，直接使用taskPercentage
        for (TaskVO task : tasks) {
            task.setPercentage(task.getTaskPercentage() != null ? task.getTaskPercentage() : 0);
        }
        
        // 检查是否有子任务
        List<Long> parentIdsHaveSubTasks = taskMapper.selectParentIdsHaveSubTasks(tasks.stream().map(TaskVO::getTaskId).collect(Collectors.toList()));
        for (TaskVO task : tasks) {
            task.setHasSubTasks(parentIdsHaveSubTasks.contains(task.getTaskId()));
        }
        
        // 统计子任务状态数量和查询参与用户
        for (TaskVO task : tasks) {
            TaskStatusStats stats = calculateSubTaskStatusStats(task.getTaskId());
            task.setSubTaskStatusStats(stats);
            
            // 查询参与用户
            List<SysUser> participants = taskUserMapper.selectUsersByTaskId(task.getTaskId());
            task.setParticipantUsers(participants);
            
            // 加载执行人信息
            if (task.getExecutorUserId() != null) {
                SysUser executorUser = userMapper.selectUserById(task.getExecutorUserId());
                task.setExecutorUser(executorUser);
            }
            
            // 为学生用户检查任务是否是当前用户执行的或创建的
            if (currentUserId != null) {
                if (task.getExecutorUserId() != null && task.getExecutorUserId().equals(currentUserId)) {
                    task.setIsCurrentUserExecutor(true);
                }
                if (task.getCreateUserId() != null && task.getCreateUserId().equals(currentUserId)) {
                    task.setIsCurrentUserCreator(true);
                }
            }
        }
        
        return tasks;
    }
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addTask(TaskDTO taskDTO) {
        log.info("任务管理模块-添加任务：{}",taskDTO);
        // 1.查出父任务
        Task parentTask = taskMapper.selectTaskById(taskDTO.getParentTaskId());
        if(taskDTO.getParentTaskId()>TaskConstants.FIRST_PARENT_TASK_ID && null==parentTask){
            throw new ServiceException("父任务不存在");
        }

        // 2.只有教师、父任务创建人、父任务执行人才能添加子任务
        boolean isTeacher = SecurityUtils.isTeacher();
        if (null != parentTask) {
            boolean isParentTaskCreator =SecurityUtils.getUserId().equals(parentTask.getCreateUserId());
            TaskExecutor parentTaskExecutor = taskExecutorMapper.selectByTaskId(parentTask.getTaskId());
            boolean isParentTaskExecutor = null!=parentTaskExecutor && SecurityUtils.getUserId().equals(parentTaskExecutor.getUserId());
            if(!isTeacher && !isParentTaskCreator && !isParentTaskExecutor){
                throw new ServiceException("只有教师、任务创建人、任务执行人有权添加任务");
            }
        }else{
            if(!isTeacher){
                throw new ServiceException("只有教师有权添加任务");
            }
        }

        // 验证任务进度：新增任务是叶子节点，必须手动设置任务进度
        if (taskDTO.getTaskPercentage() == null) {
            throw new ServiceException("请手动设置任务进度");
        }
        if (taskDTO.getTaskPercentage() < 0 || taskDTO.getTaskPercentage() > 100) {
            throw new ServiceException("任务进度范围必须在0到100之间");
        }

        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 3.1.检查并设置深度和顺序
        if(null!=parentTask){
            // 深度
            /*if(Objects.equals(parentTask.getTaskDepth(), TaskConstants.MAX_TASK_DEPTH)){
                throw new ServiceException("任务深度不能超过 "+TaskConstants.MAX_TASK_DEPTH);
            }*/
            task.setTaskDepth(parentTask.getTaskDepth()+1);
            // 顺序
            Integer lastSubTaskOrder = taskMapper.selectLastSubTaskOrder(parentTask.getTaskId());
            /*if(Objects.equals(lastSubTaskOrder,TaskConstants.MAX_TASK_ORDER)){
                throw new ServiceException("任务顺序不能超过 "+TaskConstants.MAX_TASK_ORDER);
            }*/
            task.setTaskOrder(lastSubTaskOrder==null?1:lastSubTaskOrder+1);
        }else{
            task.setTaskDepth(1);
            task.setTaskOrder(1);
        }

        // 3.2检查任务名称是否重复
        Task taskForNameQuery = new Task();
        taskForNameQuery.setParentTaskId(task.getParentTaskId());
        taskForNameQuery.setTaskDepth(task.getTaskDepth());
        taskForNameQuery.setTaskName(task.getTaskName());
        Long sameNameTaskId = taskMapper.selectSameNameTasks(taskForNameQuery);
        if(null!=sameNameTaskId){
            throw new ServiceException("该层级下已存在同名任务");
        }

        // 4.设置任务的创建人信息
        SysUser user = SecurityUtils.getLoginUser().getUser();
        task.setCreateUserId(user.getUserId());
        task.setCreateNickName(user.getNickName());

        // 5.新增任务
        taskMapper.insertTask(task);

        // 6.记录任务执行用户
        TaskExecutor taskExecutor = new TaskExecutor();
        taskExecutor.setTaskId(task.getTaskId());
        taskExecutor.setUserId(taskDTO.getExecutorUserId());
        taskExecutorMapper.insert(taskExecutor);

        // 7.记录任务参与用户组
        // 7.1 参与用户组自动添加任务创建人、任务执行人
        List<Long> participantUserIds = taskDTO.getParticipantUserIds();
        if(CollectionUtils.isEmpty(participantUserIds)){
            participantUserIds = new ArrayList<>();
        }
        if(!participantUserIds.contains(SecurityUtils.getUserId())){
            participantUserIds.add(SecurityUtils.getUserId());
        }
        if(!participantUserIds.contains(taskDTO.getExecutorUserId())){
            participantUserIds.add(taskDTO.getExecutorUserId());
        }
        // 7.2记录当前任务参与用户组
        taskUserMapper.insertTaskUserBatch(task.getTaskId(), participantUserIds);
        // 7.3.更新父任务的参与用户组
        updateParentTaskParticipantUserIds(task.getParentTaskId(),participantUserIds);

        // 8.递归更新父任务进度
        recalculateTaskPercentage(task.getParentTaskId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTask(TaskDTO taskDTO) {
        log.info("任务管理模块-更新任务：{}",taskDTO);
        // 1.查出原任务
        Task originTask = taskMapper.selectTaskById(taskDTO.getTaskId());
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        // 2.1.只有教师、创建人、执行人有权修改任务
        boolean isTeacher = SecurityUtils.isTeacher();
        boolean isCreator = SecurityUtils.getUserId().equals(originTask.getCreateUserId());
        TaskExecutor originTaskExecutor = taskExecutorMapper.selectByTaskId(taskDTO.getTaskId());
        boolean isExecutor = originTaskExecutor!=null && SecurityUtils.getUserId().equals(originTaskExecutor.getUserId());
        if(!isTeacher && !isExecutor && !isCreator){
            throw new ServiceException("只有教师、任务创建人、任务执行人有权修改任务");
        }
        // 2.2 只有任务创建人可以将任务状态更改为已完成或者已跳过
        if(!originTask.getTaskStatus().equals(taskDTO.getTaskStatus())
                && (TaskStatusEnum.FINISHED.getStatus().equals(taskDTO.getTaskStatus()) || TaskStatusEnum.SKIPPED.getStatus().equals(taskDTO.getTaskStatus()))
                && !isCreator){
            throw new ServiceException("只有任务创建人可以将任务状态更改为已完成或者已跳过");
        }
        
        // 判断任务是否有子任务
        boolean hasSubTasks = !isLeafTask(taskDTO.getTaskId());
        
        // 如果有子任务，不允许手动修改任务进度
        if (hasSubTasks && taskDTO.getTaskPercentage() != null) {
            throw new ServiceException("该任务有子任务，任务进度会自动计算，无需手动设置");
        }
        
        // 验证任务进度范围
        if (taskDTO.getTaskPercentage() != null) {
            if (taskDTO.getTaskPercentage() < 0 || taskDTO.getTaskPercentage() > 100) {
                throw new ServiceException("任务进度范围必须在0到100之间");
            }
        }

        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        
        // 处理实际完成时间
        handleActualFinishTime(task, taskDTO, originTask);
        
        // 3.修改任务
        taskMapper.updateTask(task);
        
        // 4.如果是叶子节点且修改了进度，递归更新父任务进度
        boolean isLeaf = isLeafTask(taskDTO.getTaskId());
        boolean percentageChanged = taskDTO.getTaskPercentage() != null && 
                                   !Objects.equals(taskDTO.getTaskPercentage(), originTask.getTaskPercentage());
        if (isLeaf && percentageChanged && taskDTO.getParentTaskId() > TaskConstants.FIRST_PARENT_TASK_ID) {
            recalculateTaskPercentage(taskDTO.getParentTaskId());
        }
        
        // 5.修改任务执行用户
        TaskExecutor taskExecutor = new TaskExecutor();
        taskExecutor.setTaskId(taskDTO.getTaskId());
        taskExecutor.setUserId(taskDTO.getExecutorUserId());
        if(null==originTaskExecutor){
            taskExecutorMapper.insert(taskExecutor);
        }else{
            if(!originTaskExecutor.getUserId().equals(taskDTO.getExecutorUserId())){
                taskExecutorMapper.updateByTaskId(taskExecutor);
            }
        }
        // 6.修改任务的参与用户组
        if(CollectionUtils.isEmpty(taskDTO.getParticipantUserIds())){
            taskDTO.setParticipantUserIds(new ArrayList<>());
        }
        // 6.1参与用户组自动添加任务创建人
        if(!taskDTO.getParticipantUserIds().contains(originTask.getCreateUserId())){
            taskDTO.getParticipantUserIds().add(originTask.getCreateUserId());
        }
        // 6.2参与用户组自动添加任务执行人
        if(!taskDTO.getParticipantUserIds().contains(taskDTO.getExecutorUserId())){
            taskDTO.getParticipantUserIds().add(taskDTO.getExecutorUserId());
        }
        // 6.3比较任务的参与用户组是否更改
        Set<Long> originParticipantUserIds = new HashSet<>(taskUserMapper.selectUserIdsByTaskId(task.getTaskId()));
        Set<Long> newParticipantUserIds = new HashSet<>(taskDTO.getParticipantUserIds());
        if(SetUtils.isEqualSet(originParticipantUserIds,newParticipantUserIds)){
            // 参与用户组未改变，无需更新
            return;
        }
        // 6.4 删除原参与用户组
        taskUserMapper.deleteTaskUsersByTaskId(task.getTaskId());
        // 6.5 插入新参与用户组
        taskUserMapper.insertTaskUserBatch(task.getTaskId(), taskDTO.getParticipantUserIds());
        // 6.6.修改父任务的参与用户组
        updateParentTaskParticipantUserIds(task.getParentTaskId(),taskDTO.getParticipantUserIds());
    }

    /**
     * 根据子任务的新参与用户组，更新父任务的参与用户组；使得父任务的参与用户组完全兼容子任务的参与用户组
     * @param parentTaskId
     * @param subParticipantUserIds
     */
    private void updateParentTaskParticipantUserIds(Long parentTaskId,List<Long> subParticipantUserIds){
        // 1. 一级任务，无需更新父任务参与用户组
        if(TaskConstants.FIRST_PARENT_TASK_ID.equals(parentTaskId)){
            return;
        }
        // 2.递归更新父任务
        Task parentTask = taskMapper.selectTaskById(parentTaskId);
        updateParentTaskParticipantUserIds(parentTask.getParentTaskId(),subParticipantUserIds);
        // 3. 父任务参与用户组对子任务参与用户组求差集
        HashSet<Long> hashSet = new HashSet<>(taskUserMapper.selectUserIdsByTaskId(parentTaskId));
        List<Long> differentUserIds = new ArrayList<>();
        for (Long subParticipantUserId : subParticipantUserIds) {
            if(!hashSet.contains(subParticipantUserId)){
                differentUserIds.add(subParticipantUserId);
            }
        }
        // 4 将差集添加到父任务参与用户组
        if(!CollectionUtils.isEmpty(differentUserIds)){
            taskUserMapper.insertTaskUserBatch(parentTaskId, differentUserIds);
        }
    }

    @Override
    public void updateTaskStatus(Long taskId,Integer status) {
        log.info("任务管理模块-更新任务状态：{},{}",taskId,status);
        // 查出原任务
        Task originTask = taskMapper.selectTaskById(taskId);
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        // 只有任务创建人可以将任务状态更改为已完成或者已跳过
        boolean isCreator = SecurityUtils.getUserId().equals(originTask.getCreateUserId());
        if(!originTask.getTaskStatus().equals(status)
                && (TaskStatusEnum.FINISHED.getStatus().equals(status) || TaskStatusEnum.SKIPPED.getStatus().equals(status))
                && !isCreator){
            throw new ServiceException("只有任务创建人可以将任务状态更改为已完成或者已跳过");
        }
        Task task = new Task();
        task.setTaskId(taskId);
        task.setTaskStatus(status);
        
        // 处理实际完成时间
        if (TaskStatusEnum.FINISHED.getStatus().equals(status)) {
            task.setActualFinishTime(LocalDateTime.now());
        } else if (TaskStatusEnum.FINISHED.getStatus().equals(originTask.getTaskStatus())) {
            task.setActualFinishTime(null);
        }
        
        // 更新任务状态
        taskMapper.updateTask(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteTask(Long taskId) {
        log.info("任务管理模块-删除任务：{}",taskId);
        Task task = taskMapper.selectTaskById(taskId);

        // 1.仅允许教师、任务创建人、任务执行人删除任务
        boolean isTeacher = SecurityUtils.isTeacher();
        boolean isCreator = SecurityUtils.getUserId().equals(task.getCreateUserId());
        TaskExecutor taskExecutor = taskExecutorMapper.selectByTaskId(taskId);
        boolean isExecutor = null!=taskExecutor && SecurityUtils.getUserId().equals(taskExecutor.getUserId());
        if(!isTeacher && !isCreator && !isExecutor){
            throw new ServiceException("仅教师、任务创建人、任务执行人有权删除任务");
        }
        
        // 保存父任务ID，用于后续更新父任务进度
        Long parentTaskId = task.getParentTaskId();
        
        // 2.获取当前任务的所有子任务
        List<Long> subTaskIds = taskMapper.selectSubTaskIds(taskId);
        // 3.递归删除所有子任务
        if(!CollectionUtils.isEmpty(subTaskIds)){
            // 递归删除子任务
            for(Long subTaskId : subTaskIds){
                deleteTask(subTaskId);
            }
        }
        // 4.删除当前任务
        taskMapper.deleteTask(taskId);
        // 5.删除任务执行人关联
        taskExecutorMapper.deleteByTaskId(taskId);
        // 6.删除任务用户关联
        taskUserMapper.deleteTaskUsersByTaskId(taskId);
        // 7.删除任务关联文件
        List<String> filePaths = taskFileMapper.selectFilePathsByTaskId(taskId);
        if(!CollectionUtils.isEmpty(filePaths)){
            try{
                for (String filePath : filePaths) {
                    Path path = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskBaseDir(),filePath));
                    if (Files.exists(path)) {
                        Files.delete(path);
                    }
                }
            }catch (Exception e){
                log.error("删除任务关联文件失败", e);
                throw new ServiceException("删除任务关联文件失败");
            }
            taskFileMapper.deleteByTaskId(taskId);
        }
        
        // 8.删除任务汇报关联文件
        List<String> taskReportFilePaths = taskReportFileMapper.selectFilePathsByTaskId(Collections.singletonList(taskId));
        if(!CollectionUtils.isEmpty(taskReportFilePaths)){
            try{
                for (String filePath : taskReportFilePaths) {
                    Path path = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getTaskReportBaseDir(),filePath));
                    if (Files.exists(path)) {
                        Files.delete(path);
                    }
                }
            }catch (Exception e){
                log.error("删除任务汇报关联文件失败", e);
            }
            taskReportFileMapper.deleteByTaskIds(Collections.singletonList(taskId));
        }
        
        // 9.递归更新父任务进度
        recalculateTaskPercentage(parentTaskId);
    }

    @Override
    public TaskDetailVO getTaskDetail(Long taskId) {
        log.info("任务管理模块-查询任务详情：{}",taskId);
        // 1.查询任务信息
        TaskDetailVO taskDetailVO = taskMapper.selectTaskDetailVOById(taskId);
        // 2.查询任务参与用户
        if(null!=taskDetailVO){
            taskDetailVO.setParticipantUsers(taskUserMapper.selectUsersByTaskId(taskId));
            // 3.判断是否有子任务
            List<Long> subTaskIds = taskMapper.selectSubTaskIds(taskId);
            taskDetailVO.setHasSubTasks(!CollectionUtils.isEmpty(subTaskIds));
        }
        return taskDetailVO;
    }
    @Override
    public List<SysUser> getParticipantUsersByTaskId(Long taskId) {
        log.info("任务管理模块-查询任务参与用户：{}",taskId);
        return taskUserMapper.selectUsersByTaskId(taskId);
    }

    @Override
    public List<UserForSelectVO> listUsersForSelect(String nickName) {
        log.info("任务管理模块-查询用户列表（用于前端用户选择）：{}",nickName);
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
        return userMapper.selectVOForSelect(queryDTO);
    }

    @Override
    public List<UserForSelectVO> listStudentsForSelect(String nickName) {
        log.info("任务管理模块-查询学生列表（用于前端用户选择）：{}",nickName);
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
        queryDTO.setRoleKey(RoleEnums.STUDENT.getRoleKey());
        return userMapper.selectVOForSelect(queryDTO);
    }

    /**
     * 计算任务的进度条及是否有子任务
     * @param tasks
     */
    private void calculateTaskList(List<TaskVO> tasks){
        // 过滤出存在子任务的父任务id列表
        List<Long> parentIdsHaveSubTasks = taskMapper.selectParentIdsHaveSubTasks(tasks.stream().map(TaskVO::getTaskId).collect(Collectors.toList()));
        // 对于PROCESSING的任务，需要计算完成进度
        for (TaskVO task : tasks) {
            if(parentIdsHaveSubTasks.contains(task.getTaskId())){
                task.setHasSubTasks(true);
                // 有子任务&&状态为PROCESSING
                if(TaskStatusEnum.PROCESSING.getStatus().equals(task.getTaskStatus())){
                    Map<String, Object> map = taskMapper.selectCalculatePercentage(task.getTaskId());
                    int completedSubTasks = safeToInt(map.get("completedSubTasks"));
                    int totalSubTasks = safeToInt(map.get("totalSubTasks"));
                    if(totalSubTasks > 0 && completedSubTasks < totalSubTasks){
                        task.setPercentage(completedSubTasks * 100 / totalSubTasks);
                    }else{
                        task.setPercentage(100);
                    }
                }else {
                    // 有子任务&&状态不为PROCESSING
                    task.setPercentage(task.getTaskStatus()>=TaskStatusEnum.FINISHED.getStatus()?100:0);
                }
            }else{
                // 没有子任务
                task.setHasSubTasks(false);
                task.setPercentage(task.getTaskStatus()>=TaskStatusEnum.FINISHED.getStatus()?100:0);
            }
        }
    }
    /**
     * 安全地将对象转换为int值
     * 支持Integer、Long、BigDecimal、Double、Float和String类型
     * @param value 要转换的对象
     * @return 转换后的int值，转换失败返回0
     */
    private int safeToInt(Object value) {
        if (value == null) {
            return 0;
        }
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof Long) {
            return ((Long) value).intValue();
        }
        if (value instanceof BigDecimal) {
            return ((BigDecimal) value).intValue();
        }
        if (value instanceof Double) {
            return ((Double) value).intValue();
        }
        if (value instanceof Float) {
            return ((Float) value).intValue();
        }
        if (value instanceof String) {
            try {
                return Integer.parseInt((String) value);
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        return 0;
    }
    
    /**
     * 计算子任务状态统计
     * @param taskId 任务ID
     * @return 子任务状态统计
     */
    private TaskStatusStats calculateSubTaskStatusStats(Long taskId) {
        TaskStatusStats stats = new TaskStatusStats();
        // 查询该任务的所有子任务状态
        List<TaskVO> subTasks = taskMapper.select(new TaskQueryDTO() {
            {
                setParentTaskId(taskId);
            }
        });
        
        // 统计各状态任务数量
        int pendingCount = 0;
        int processingCount = 0;
        int finishedCount = 0;
        int skippedCount = 0;
        
        for (TaskVO subTask : subTasks) {
            if (TaskStatusEnum.PENDING.getStatus().equals(subTask.getTaskStatus())) {
                pendingCount++;
            } else if (TaskStatusEnum.PROCESSING.getStatus().equals(subTask.getTaskStatus())) {
                processingCount++;
            } else if (TaskStatusEnum.FINISHED.getStatus().equals(subTask.getTaskStatus())) {
                finishedCount++;
            } else if (TaskStatusEnum.SKIPPED.getStatus().equals(subTask.getTaskStatus())) {
                skippedCount++;
            }
        }
        
        stats.setPendingCount(pendingCount);
        stats.setProcessingCount(processingCount);
        stats.setFinishedCount(finishedCount);
        stats.setSkippedCount(skippedCount);
        
        return stats;
    }
    
    /**
     * 处理实际完成时间
     * @param task 任务对象
     * @param taskDTO 任务DTO
     * @param originTask 原始任务
     */
    private void handleActualFinishTime(Task task, TaskDTO taskDTO, Task originTask) {
        // 如果状态改为已完成，设置实际完成时间
        if (TaskStatusEnum.FINISHED.getStatus().equals(taskDTO.getTaskStatus()) && 
            !TaskStatusEnum.FINISHED.getStatus().equals(originTask.getTaskStatus())) {
            task.setActualFinishTime(LocalDateTime.now());
        }
        // 如果状态从已完成改为其他状态，清除实际完成时间
        else if (!TaskStatusEnum.FINISHED.getStatus().equals(taskDTO.getTaskStatus()) && 
                 TaskStatusEnum.FINISHED.getStatus().equals(originTask.getTaskStatus())) {
            task.setActualFinishTime(null);
        }
        // 保持原有值
        else {
            task.setActualFinishTime(originTask.getActualFinishTime());
        }
    }

    /**
     * 递归计算并更新父任务的进度
     * @param taskId 任务ID
     */
    private void recalculateTaskPercentage(Long taskId) {
        if(null==taskId || taskId.equals(TaskConstants.FIRST_PARENT_TASK_ID)){
            return;
        }
        Task task = taskMapper.selectTaskById(taskId);
        if(null==task){
            return;
        }

        List<Task> subTasks = taskMapper.selectSubTasksByParentId(taskId);

        if (CollectionUtils.isEmpty(subTasks)) {
            return;
        }

        int totalPercentage = 0;
        int validCount = 0;
        for (Task subTask : subTasks) {
            if (subTask.getTaskPercentage() != null) {
                totalPercentage += subTask.getTaskPercentage();
                validCount++;
            }
        }

        int newPercentage = validCount > 0 ? totalPercentage / validCount : 0;

        Task taskForUpdate = new Task();
        taskForUpdate.setTaskId(taskId);
        taskForUpdate.setTaskPercentage(newPercentage);
        taskMapper.updateTask(taskForUpdate);

        recalculateTaskPercentage(task.getParentTaskId());
    }

    /**
     * 判断任务是否为叶子节点任务（没有子任务）
     * @param taskId 任务ID
     * @return 是否为叶子节点
     */
    private boolean isLeafTask(Long taskId) {
        List<Long> subTaskIds = taskMapper.selectSubTaskIds(taskId);
        return CollectionUtils.isEmpty(subTaskIds);
    }
}

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
import com.ruoyi.experiment.mapper.TaskUserMapper;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.entity.TaskExecutor;
import com.ruoyi.experiment.pojo.vo.TaskDetailVO;
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
    private final ExperimentConfig experimentConfig;
    private final TaskExecutorMapper taskExecutorMapper;
    @Override
    public TaskStatisticsVO selectParentTaskListWithStatistics(TaskQueryDTO taskQueryDTO) {
        log.info("任务管理模块-查询父任务列表：{}",taskQueryDTO);
        // 1.获取分页的任务列表
        List<TaskVO> tasks = selectParentTaskList(taskQueryDTO);
        
        // 2.为每个任务加载参与用户信息
        for (TaskVO task : tasks) {
            List<SysUser> participantUsers = taskUserMapper.selectUsersByTaskId(task.getTaskId());
            task.setParticipantUsers(participantUsers);
        }
        
        // 3.统计各状态任务个数
        Long pendingCount = 0L;
        Long processingCount = 0L;
        Long finishedCount = 0L;
        Long skippedCount = 0L;
        
        for (TaskVO task : tasks) {
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
        
        return result;
    }
    
    private List<TaskVO> selectParentTaskList(TaskQueryDTO taskQueryDTO) {
        taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        // 学生用户只能查自己参与的任务；教师用户可以查所有任务
        if(SecurityUtils.isStudent()){
            taskQueryDTO.setUserId(SecurityUtils.getUserId());
        }
        List<TaskVO> tasks = taskMapper.select(taskQueryDTO);
        // 2.计算子任务状态
        calculateTaskList(tasks);
        return tasks;
    }

    @Override
    public List<TaskVO> selectSubTaskList(Long parentTaskId) {
        log.info("任务管理模块-查询子任务列表：{}",parentTaskId);
        TaskQueryDTO taskQueryDTO = new TaskQueryDTO();
        taskQueryDTO.setParentTaskId(parentTaskId);
        // 学生用户只能查自己参与的任务；教师用户可以查所有任务
        if(SecurityUtils.isStudent()){
            taskQueryDTO.setUserId(SecurityUtils.getUserId());
        }
        taskQueryDTO.setOrderBy(TaskConstants.SUB_TASK_ORDER_BY);
        taskQueryDTO.setOrderDirection(TaskConstants.SUB_TASK_ORDER_DIRECTION);
        List<TaskVO> tasks = taskMapper.select(taskQueryDTO);
        calculateTaskList(tasks);
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

        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 3.1.检查并设置深度和顺序
        if(null!=parentTask){
            // 深度
            if(Objects.equals(parentTask.getTaskDepth(), TaskConstants.MAX_TASK_DEPTH)){
                throw new ServiceException("任务深度不能超过 "+TaskConstants.MAX_TASK_DEPTH);
            }
            task.setTaskDepth(parentTask.getTaskDepth()+1);
            // 顺序
            Integer lastSubTaskOrder = taskMapper.selectLastSubTaskOrder(parentTask.getTaskId());
            if(Objects.equals(lastSubTaskOrder,TaskConstants.MAX_TASK_ORDER)){
                throw new ServiceException("任务顺序不能超过 "+TaskConstants.MAX_TASK_ORDER);
            }
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
        // 2.只有教师、创建人、执行人有权修改任务
        boolean isTeacher = SecurityUtils.isTeacher();
        boolean isCreator = SecurityUtils.getUserId().equals(originTask.getCreateUserId());
        TaskExecutor originTaskExecutor = taskExecutorMapper.selectByTaskId(taskDTO.getTaskId());
        boolean isExecutor = originTaskExecutor!=null && SecurityUtils.getUserId().equals(originTaskExecutor.getUserId());
        if(!isTeacher && !isExecutor && !isCreator){
            throw new ServiceException("只有教师、任务创建人、任务执行人有权修改任务");
        }
        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 3.修改任务
        taskMapper.updateTask(task);
        // 4.修改任务执行用户
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
        // 5.修改任务的参与用户组
        if(CollectionUtils.isEmpty(taskDTO.getParticipantUserIds())){
            taskDTO.setParticipantUserIds(new ArrayList<>());
        }
        // 5.1参与用户组自动添加任务创建人
        if(!taskDTO.getParticipantUserIds().contains(originTask.getCreateUserId())){
            taskDTO.getParticipantUserIds().add(originTask.getCreateUserId());
        }
        // 5.2参与用户组自动添加任务执行人
        if(!taskDTO.getParticipantUserIds().contains(taskDTO.getExecutorUserId())){
            taskDTO.getParticipantUserIds().add(taskDTO.getExecutorUserId());
        }
        // 5.3比较任务的参与用户组是否更改
        Set<Long> originParticipantUserIds = new HashSet<>(taskUserMapper.selectUserIdsByTaskId(task.getTaskId()));
        Set<Long> newParticipantUserIds = new HashSet<>(taskDTO.getParticipantUserIds());
        if(SetUtils.isEqualSet(originParticipantUserIds,newParticipantUserIds)){
            // 参与用户组未改变，无需更新
            return;
        }
        // 5.4 删除原参与用户组
        taskUserMapper.deleteTaskUsersByTaskId(task.getTaskId());
        // 5.5 插入新参与用户组
        taskUserMapper.insertTaskUserBatch(task.getTaskId(), taskDTO.getParticipantUserIds());
        // 5.6.修改父任务的参与用户组
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
        Task task = new Task();
        task.setTaskId(taskId);
        task.setTaskStatus(status);
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
        if(CollectionUtils.isEmpty(filePaths)){
            return;
        }
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

    @Override
    public TaskDetailVO getTaskDetail(Long taskId) {
        log.info("任务管理模块-查询任务详情：{}",taskId);
        // 1.查询任务信息
        TaskDetailVO taskDetailVO = taskMapper.selectTaskDetailVOById(taskId);
        // 2.查询任务参与用户
        if(null!=taskDetailVO){
            taskDetailVO.setParticipantUsers(taskUserMapper.selectUsersByTaskId(taskId));
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
}

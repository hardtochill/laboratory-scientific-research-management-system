package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.constant.TaskConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.enums.TaskStatusEnum;
import com.ruoyi.experiment.enums.UserGraduateFlagEnum;
import com.ruoyi.experiment.mapper.TaskFileMapper;
import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.mapper.TaskUserMapper;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
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
    @Override
    public TaskStatisticsVO selectParentTaskListWithStatistics(TaskQueryDTO taskQueryDTO) {
        // 1.获取分页的任务列表
        List<TaskVO> tasks = selectParentTaskList(taskQueryDTO);
        
        // 2.统计各状态任务个数
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
        
        // 3.创建返回结果
        TaskStatisticsVO result = new TaskStatisticsVO();
        result.setList(tasks);
        result.setPendingCount(pendingCount);
        result.setProcessingCount(processingCount);
        result.setFinishedCount(finishedCount);
        result.setSkippedCount(skippedCount);
        result.setTotal((long) tasks.size());
        
        return result;
    }
    
    @Override
    public List<TaskVO> selectParentTaskList(TaskQueryDTO taskQueryDTO) {
        taskQueryDTO.setParentTaskId(TaskConstants.FIRST_PARENT_TASK_ID);
        taskQueryDTO.setUserId(SecurityUtils.getUserId());
        List<TaskVO> tasks = taskMapper.select(taskQueryDTO);
        // 2.计算子任务状态
        calculateTaskList(tasks);
        return tasks;
    }

    @Override
    public List<TaskVO> selectSubTaskList(Long parentTaskId) {
        TaskQueryDTO taskQueryDTO = new TaskQueryDTO();
        taskQueryDTO.setParentTaskId(parentTaskId);
        taskQueryDTO.setUserId(SecurityUtils.getUserId());
        taskQueryDTO.setOrderBy(TaskConstants.SUB_TASK_ORDER_BY);
        taskQueryDTO.setOrderDirection(TaskConstants.SUB_TASK_ORDER_DIRECTION);
        List<TaskVO> tasks = taskMapper.select(taskQueryDTO);
        calculateTaskList(tasks);
        return tasks;
    }
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addTask(TaskDTO taskDTO) {
        // 1.查出父任务
        Task parentTask = taskMapper.selectTaskById(taskDTO.getParentTaskId());
        if(taskDTO.getParentTaskId()>TaskConstants.FIRST_PARENT_TASK_ID && null==parentTask){
            throw new ServiceException("父任务不存在");
        }
        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 2.检查并设置深度和顺序
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
        // 3.参与用户组
        List<Long> subParticipantUserIds = taskDTO.getParticipantUserIds();
        if(CollectionUtils.isEmpty(subParticipantUserIds)){
            subParticipantUserIds = new ArrayList<>();
        }
        if(!subParticipantUserIds.contains(SecurityUtils.getUserId())){
            subParticipantUserIds.add(SecurityUtils.getUserId());
        }
        // 4.设置任务的创建人信息
        SysUser user = SecurityUtils.getLoginUser().getUser();
        task.setCreateUserId(user.getUserId());
        task.setCreateNickName(user.getNickName());
        // 5.新增任务
        taskMapper.insertTask(task);
        // 6.记录子任务参与用户组
        taskUserMapper.insertTaskUserBatch(task.getTaskId(), subParticipantUserIds);
        // 7.更新父任务的参与用户组
        updateParentTaskParticipantUserIds(task.getParentTaskId(),subParticipantUserIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTask(TaskDTO taskDTO) {
        // 1.查出原任务
        Task originTask = taskMapper.selectTaskById(taskDTO.getTaskId());
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        // 2.非教师角色不能修改任务状态
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        if(!isTeacher && !taskDTO.getTaskStatus().equals(originTask.getTaskStatus())){
            throw new ServiceException("非教师角色，无权限操作");
        }
        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 3.修改任务
        taskMapper.updateTask(task);
        // 4.修改任务的参与用户组
        // 4.1 比较参与用户组是否更改
        if(CollectionUtils.isEmpty(taskDTO.getParticipantUserIds())){
            taskDTO.setParticipantUserIds(new ArrayList<>());
            if(!taskDTO.getParticipantUserIds().contains(SecurityUtils.getUserId())){
                taskDTO.getParticipantUserIds().add(SecurityUtils.getUserId());
            }
        }
        Set<Long> originParticipantUserIds = new HashSet<>(taskUserMapper.selectUserIdsByTaskId(task.getTaskId()));
        Set<Long> newParticipantUserIds = new HashSet<>(taskDTO.getParticipantUserIds());
        if(SetUtils.isEqualSet(originParticipantUserIds,newParticipantUserIds)){
            // 参与用户组未改变，无需更新
            return;
        }
        // 4.2 删除原参与用户组
        taskUserMapper.deleteTaskUsersByTaskId(task.getTaskId());
        // 4.3 插入新参与用户组
        taskUserMapper.insertTaskUserBatch(task.getTaskId(), taskDTO.getParticipantUserIds());
        // 5.修改父任务的参与用户组
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
        Task task = new Task();
        task.setTaskId(taskId);
        task.setTaskStatus(status);
        // 更新任务状态
        taskMapper.updateTask(task);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteTask(Long taskId) {
        // 1.获取当前任务的所有子任务
        List<Long> subTaskIds = taskMapper.selectSubTaskIds(taskId);
        // 2.递归删除所有子任务
        if(!CollectionUtils.isEmpty(subTaskIds)){
            // 递归删除子任务
            for(Long subTaskId : subTaskIds){
                deleteTask(subTaskId);
            }
        }
        // 3.删除当前任务
        taskMapper.deleteTask(taskId);
        // 4.删除任务用户关联
        taskUserMapper.deleteTaskUsersByTaskId(taskId);
        // 5.删除任务关联文件
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
    public Task getTaskById(Long taskId) {
        // 1.查询任务信息
        Task task = taskMapper.selectTaskById(taskId);
        // 2.查询任务参与用户
        if(null!=task){
            task.setParticipantUsers(taskUserMapper.selectUsersByTaskId(taskId));
        }
        return task;
    }
    @Override
    public List<SysUser> getParticipantUsersByTaskId(Long taskId) {
        return taskUserMapper.selectUsersByTaskId(taskId);
    }

    @Override
    public List<UserForSelectVO> listUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
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

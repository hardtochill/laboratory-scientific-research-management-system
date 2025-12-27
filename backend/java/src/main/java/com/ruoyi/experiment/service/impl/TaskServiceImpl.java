package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.constant.TaskConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.enums.TaskStatusEnum;
import com.ruoyi.experiment.enums.UserGraduateFlagEnum;
import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.mapper.TaskUserMapper;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskStatisticsVO;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.web.domain.R;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {
    private final TaskMapper taskMapper;
    private final SysUserMapper sysUserMapper;
    private final TaskUserMapper taskUserMapper;
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
            switch (task.getTaskStatus()) {
                case 1: // 未开始
                    pendingCount++;
                    break;
                case 2: // 进行中
                    processingCount++;
                    break;
                case 3: // 已完成
                    finishedCount++;
                    break;
                case 4: // 已跳过
                    skippedCount++;
                    break;
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
        // 1.获取角色，对不同角色查询不同任务
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        List<TaskVO> tasks;
        if (isTeacher){ // 对教师：获取所有任务
            tasks = taskMapper.selectFirstParentTasksForTeacher(TaskConstants.FIRST_PARENT_TASK_ID,taskQueryDTO);
        }else{ // 对学生：获取所有自己参与的任务
            tasks = taskMapper.selectFirstParentTasksForStudent(TaskConstants.FIRST_PARENT_TASK_ID, SecurityUtils.getUserId(),taskQueryDTO);
        }
        // 2.计算子任务状态
        calculateTaskList(tasks);
        return tasks;
    }

    @Override
    public List<TaskVO> selectSubTaskList(Long parentTaskId) {
        // 二级及以下父任务，按任务顺序排序
        List<TaskVO> tasks = taskMapper.selectSubTasks(parentTaskId);
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
        // 3.验证参与用户组
        if (!CollectionUtils.isEmpty(taskDTO.getParticipantUserIds())) {
            List<Long> userIds = sysUserMapper.selectUserIdsByIds(taskDTO.getParticipantUserIds());
            if(null==userIds || userIds.size()!=taskDTO.getParticipantUserIds().size()){
                throw new ServiceException("参与用户不存在");
            }
        }
        // 4.设置任务的创建人信息
        SysUser user = SecurityUtils.getLoginUser().getUser();
        task.setCreateUserId(user.getUserId());
        task.setCreateNickName(user.getNickName());
        // 5.新增任务
        taskMapper.insertTask(task);
        // 6.处理用户组关联
        handleTaskUserAssociation(task.getTaskId(), taskDTO.getParticipantUserIds());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTask(TaskDTO taskDTO) {
        // 1.查出原任务
        Task originTask = taskMapper.selectTaskById(taskDTO.getTaskId());
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        // 2.只有教师才能修改任务状态
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        if(!isTeacher && !taskDTO.getTaskStatus().equals(originTask.getTaskStatus())){
            throw new ServiceException("非教师角色，无权限操作");
        }
        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 3.验证参与用户组
        if (!CollectionUtils.isEmpty(taskDTO.getParticipantUserIds())) {
            List<Long> userIds = sysUserMapper.selectUserIdsByIds(taskDTO.getParticipantUserIds());
            if(null==userIds || userIds.size()!=taskDTO.getParticipantUserIds().size()){
                throw new ServiceException("参与用户不存在");
            }
        }
        // todo 修改任务状态是否需要受前置任务限制
        // 4.修改任务
        taskMapper.updateTask(task);
        // 5.处理用户组关联
        handleTaskUserAssociation(task.getTaskId(), taskDTO.getParticipantUserIds());
    }

    @Override
    public void updateTaskStatus(Task task) {
        log.info("更新任务状态：task={}",task);
        // 1.检查任务是否存在
        Task originTask = taskMapper.selectTaskById(task.getTaskId());
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        // 2.检查任务状态是否合法
        if(null == TaskStatusEnum.getByStatus(task.getTaskStatus())){
            throw new ServiceException("任务状态不合法");
        }
        // todo 修改任务状态是否需要受前置任务限制
        // 3.更新任务状态
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
        taskUserMapper.deleteTaskUsers(taskId);
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
    public List<SysUser> getSelectableUsers(String nickName) {
        // 查询未毕业的用户（支持模糊匹配）
        return sysUserMapper.selectUsersByGraduateFlagAndNickName(UserGraduateFlagEnum.UNGRADUATED.getValue(), nickName);
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
     * 处理任务用户关联
     * @param taskId 任务ID
     * @param userIds 用户ID列表
     */
    private void handleTaskUserAssociation(Long taskId, List<Long> userIds) {
        // 1.递归更改子任务的任务关联
        List<Long> subTaskIds = taskMapper.selectSubTaskIds(taskId);
        if(!CollectionUtils.isEmpty(subTaskIds)){
            // 递归更改子任务的任务关联
            for(Long subTaskId : subTaskIds){
                handleTaskUserAssociation(subTaskId,userIds);
            }
        }
        // 2.删除旧的用户关联
        taskUserMapper.deleteTaskUsers(taskId);
        // 3.添加新的用户关联
        if (!CollectionUtils.isEmpty(userIds)) {
            taskUserMapper.insertTaskUserBatch(taskId,userIds);
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

package com.ruoyi.experiment.service.impl;

import com.ruoyi.experiment.constant.TaskConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.enums.TaskStatusEnum;
import com.ruoyi.experiment.enums.TaskVisibleTypeEnum;
import com.ruoyi.experiment.mapper.TaskMapper;
import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.experiment.service.TaskService;
import com.ruoyi.framework.web.exception.GlobalExceptionHandler;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
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
    @Override
    public List<TaskVO> selectParentTaskList(TaskQueryDTO taskQueryDTO) {
        // 获取仅自己可见+所有可见的任务
        Long userId = SecurityUtils.getUserId();
        // 一级父任务条件查询，按创建时间倒序
        List<TaskVO> tasks = taskMapper.selectFirstParentTasks(TaskConstants.FIRST_PARENT_TASK_ID,userId, taskQueryDTO);
        calculateTaskList(tasks);
        return tasks;
    }

    @Override
    public List<TaskVO> selectSubTaskList(Long parentTaskId) {
        // 获取仅自己可见+所有可见的任务
        Long userId = SecurityUtils.getUserId();
        // 二级及以下父任务，按任务顺序排序
        List<TaskVO> tasks = taskMapper.selectSubParentTasks(parentTaskId,userId);
        calculateTaskList(tasks);
        return tasks;
    }
    @Override
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
        // 3.检查用户的执行人
        if(null==sysUserMapper.selectUserById(task.getExecuteUserId())){
            throw new ServiceException("执行用户不存在");
        }
        // 4.设置任务的创建人信息
        SysUser user = SecurityUtils.getLoginUser().getUser();
        task.setCreateUserId(user.getUserId());
        task.setCreateNickName(user.getNickName());
        // 5.检查任务的可见范围
        // 如果任务的创建人!=执行人，则可见范围必须是所有人
        if(!(Objects.equals(task.getCreateUserId(),task.getExecuteUserId())) && TaskVisibleTypeEnum.ONLY_SELF.getType().equals(task.getVisibleType())){
            throw new ServiceException("若任务的创建人不为执行人，则可见范围必须是：所有人可见");
        }
        // 子任务跟父任务的可见范围必须保持一致
        if(null!=parentTask && !Objects.equals(parentTask.getVisibleType(),task.getVisibleType())){
            throw new ServiceException("子任务跟父任务的可见范围必须保持一致");
        }
        // 6.新增
        taskMapper.insertTask(task);
    }

    @Override
    public void updateTask(TaskDTO taskDTO) {
        // 1.查出原任务
        Task originTask = taskMapper.selectTaskById(taskDTO.getTaskId());
        if(null==originTask){
            throw new ServiceException("任务不存在");
        }
        Task task = new Task();
        BeanUtils.copyProperties(taskDTO,task);
        // 2.检查用户的执行人
        if(null==sysUserMapper.selectUserById(task.getExecuteUserId())){
            throw new ServiceException("执行用户不存在");
        }
        // 3.检查任务的可见范围
        // 如果任务的创建人!=执行人，则可见范围必须是所有人
        if(!(Objects.equals(originTask.getCreateUserId(),task.getExecuteUserId())) && TaskVisibleTypeEnum.ONLY_SELF.getType().equals(task.getVisibleType())){
            throw new ServiceException("若任务的创建人不为执行人，则可见范围必须是：所有人可见");
        }
        // 子任务跟父任务的可见范围必须保持一致
        Task parentTask = taskMapper.selectTaskById(task.getParentTaskId());
        if(null!=parentTask && !Objects.equals(parentTask.getVisibleType(),task.getVisibleType())){
            throw new ServiceException("子任务的可见范围必须保持一致");
        }
        // todo 搁置，修改任务状态是否需要受前置任务限制

        // 4.修改
        taskMapper.updateTask(task);
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
        // todo 搁置，修改任务状态是否需要受前置任务限制
        // 3.更新任务状态
        taskMapper.updateTask(task);
    }

    @Override
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
    }

    @Override
    public Task getTaskById(Long taskId) {
        return taskMapper.selectTaskById(taskId);
    }

    /**
     * 计算任务的进度条及是否有子任务
     * @param tasks
     */
    private void calculateTaskList(List<TaskVO> tasks){
        // 过滤出存在子任务的父任务id列表
        List<Long> parentIdsWithSubTasks = taskMapper.selectParentIdsWithSubTasks(tasks.stream().map(TaskVO::getTaskId).collect(Collectors.toList()));
        // 对于PROCESSING的任务，需要计算完成进度
        for (TaskVO task : tasks) {
            if(parentIdsWithSubTasks.contains(task.getTaskId())){
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
                    task.setPercentage(100);
                }
            }else{
                task.setHasSubTasks(false);
                // 没有子任务，进度条拉满
                task.setPercentage(100);
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

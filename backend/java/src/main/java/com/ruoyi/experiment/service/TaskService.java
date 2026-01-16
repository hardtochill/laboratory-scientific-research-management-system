package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskStatisticsVO;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;

import java.util.List;

public interface TaskService {

    /**
     * 根据条件查询父任务列表和统计数据
     * @param taskQueryDTO 查询条件
     * @return 包含统计数据的任务列表
     */
    TaskStatisticsVO selectParentTaskListWithStatistics(TaskQueryDTO taskQueryDTO);
    
    /**
     * 根据条件查询父任务列表（兼容旧版本）
     * @param taskQueryDTO 查询条件
     * @return 父任务列表
     */
    List<TaskVO> selectParentTaskList(TaskQueryDTO taskQueryDTO);

    /**
     * 根据父任务ID查询子任务列表
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    List<TaskVO> selectSubTaskList(Long parentTaskId);

    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    Task getTaskById(Long taskId);
    /**
     * 添加任务
     * @param taskDTO 任务DTO
     */
    void addTask(TaskDTO taskDTO);

    /**
     * 更新任务
     * @param taskDTO 任务DTO
     */
    void updateTask(TaskDTO taskDTO);
    /**
     * 更新任务状态
     */
    void updateTaskStatus(Long taskId,Integer status);
    /**
     * 删除任务
     */
    void deleteTask(Long taskId);
    
    /**
     * 根据任务ID获取参与用户组
     * @param taskId 任务ID
     * @return 参与用户列表
     */
    List<SysUser> getParticipantUsersByTaskId(Long taskId);

     /**
      * 获取用户列表（用于前端用户选择）
      */
    List<UserForSelectVO> listUsersForSelect(String nickName);
}

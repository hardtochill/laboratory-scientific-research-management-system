package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.TaskDTO;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import com.ruoyi.project.system.domain.SysUser;

import java.util.List;

public interface TaskService {

    /**
     * 根据条件查询父任务列表
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
    void updateTaskStatus(Task task);
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
     * 根据父任务ID获取参与用户组（用于子任务继承）
     * @param parentTaskId 父任务ID
     * @return 参与用户列表
     */
    List<SysUser> getParticipantUsersByParentTaskId(Long parentTaskId);
    
    /**
     * 查询未毕业的用户（用于前端用户选择）
     */
    List<SysUser> selectUngraduatedUsers(String nickName);
}

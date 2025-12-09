package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.entity.Task;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TaskMapper {
    /**
     * 获取所有父任务（parentTaskId为null或0的任务）
     * @return 父任务列表
     */
    List<Task> selectParentTasks();

    /**
     * 根据父任务ID获取子任务列表
     * @param parentTaskId 父任务ID
     * @return 子任务列表
     */
    List<Task> selectSubTasksByParentId(@Param("parentTaskId") Long parentTaskId);

    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    Task selectTaskById(@Param("taskId") Long taskId);
}

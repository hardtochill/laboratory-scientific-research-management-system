package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.TaskQueryDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskDetailVO;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface TaskMapper {

    List<TaskVO> select(TaskQueryDTO taskQueryDTO);

    /**
     * 计算子任务的完成情况
     */
    Map<String, Object> selectCalculatePercentage(Long parentTaskId);
    /**
     * 过滤出存在子任务的parentIds
     */
    List<Long> selectParentIdsHaveSubTasks(List<Long> parentIds);
    /**
     * 根据任务ID获取任务
     */
    @Select("select * from task where task_id = #{taskId}")
    Task selectTaskById(Long taskId);
    /**
     * 根据任务ID获取任务详情
     */
    TaskDetailVO selectTaskDetailVOById(Long taskId);
    /**
     * 根据父任务id获取其最大子任务
     */
    @Select("select task_order from task where parent_task_id=#{parentTaskId} order by task_order desc limit 1")
     Integer selectLastSubTaskOrder(Long parentTaskId);

    /**
     * 查询是否有同名子任务
     */
    @Select("select task_id from task where parent_task_id=#{parentTaskId} and task_depth=#{taskDepth} and task_name=#{taskName} limit 1")
    Long selectSameNameTasks(Task task);

    /**
     * 新增任务
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insertTask(Task task);
     /**
     * 更新任务
     */
     @AutoFill(OperationTypeEnum.UPDATE)
    void updateTask(Task task);

    /**
     * 删除任务
     */
    @Delete("delete from task where task_id = #{taskId}")
    void deleteTask(Long taskId);
    /**
     * 获取所有子任务Id
     */
    @Select("select task_id from task where parent_task_id = #{parentTaskId}")
    List<Long> selectSubTaskIds(Long parentTaskId);
}

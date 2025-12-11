package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.dto.TaskDTO;
import com.ruoyi.experiment.pojo.entity.Task;
import com.ruoyi.experiment.pojo.vo.TaskVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Mapper
public interface TaskMapper {
    /**
     * 获取一级父任务
     * @return
     */
    List<TaskVO> selectFirstParentTasks(Long parentTaskId,Long userId,TaskDTO taskDTO);
    
    /**
     * 获取二级及以下父任务
     * @return
     */
    List<TaskVO> selectSubParentTasks(Long parentTaskId,Long userId);

    /**
     * 计算子任务的完成情况
     */
    Map<String, Object> selectCalculatePercentage(Long parentTaskId);
    /**
     * 过滤出存在子任务的parentIds
     */
    List<Long> selectParentIdsWithSubTasks(List<Long> parentIds);
    /**
     * 根据任务ID获取任务详情
     * @param taskId 任务ID
     * @return 任务详情
     */
    Task selectTaskById(@Param("taskId") Long taskId);

}

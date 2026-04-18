package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.UnreportedTaskQueryDTO;
import com.ruoyi.experiment.pojo.vo.UnreportedTaskVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 待汇报任务Mapper
 */
@Mapper
public interface UnreportedTaskMapper {

    /**
     * 查询待汇报任务列表
     *
     * @param queryDTO 查询条件
     * @return 任务列表
     */
    List<UnreportedTaskVO> selectUnreportedTaskList(UnreportedTaskQueryDTO queryDTO);

    /**
     * 根据任务ID查询单个任务详情
     *
     * @param taskId 任务ID
     * @return 任务详情
     */
    UnreportedTaskVO selectTaskById(@Param("taskId") Long taskId);

    /**
     * 根据任务ID查询任务的所有父任务（从顶级父任务到当前任务的父任务）
     *
     * @param taskId 任务ID
     * @return 父任务列表（按层级从低到高排序）
     */
    List<UnreportedTaskVO> selectParentTasksByTaskId(@Param("taskId") Long taskId);
}

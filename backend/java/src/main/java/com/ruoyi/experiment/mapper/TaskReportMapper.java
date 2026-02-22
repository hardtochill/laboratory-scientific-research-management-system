package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.TaskReport;
import com.ruoyi.experiment.pojo.vo.TaskReportVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 任务汇报Mapper接口
 *
 * @author ruoyi
 */
@Mapper
public interface TaskReportMapper {

    /**
     * 查询任务汇报列表
     *
     * @param taskId    任务id
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return 任务汇报列表
     */
    List<TaskReportVo> selectTaskReportList(@Param("taskId") Long taskId, 
                                            @Param("startTime") LocalDateTime startTime, 
                                            @Param("endTime") LocalDateTime endTime);

    /**
     * 新增任务汇报
     *
     * @param taskReport 任务汇报
     * @return 结果
     */
    @AutoFill(OperationTypeEnum.INSERT)
    int insertTaskReport(TaskReport taskReport);

    /**
     * 删除任务汇报
     *
     * @param reportId 汇报id
     * @return 结果
     */
    int deleteTaskReportById(Long reportId);
}

package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.TaskExecutor;
import org.apache.ibatis.annotations.*;

@Mapper
public interface TaskExecutorMapper {

    @Select("select * from task_executor where task_id=#{taskId}")
    TaskExecutor selectByTaskId(Long taskId);

    @AutoFill(OperationTypeEnum.INSERT)
    void insert(TaskExecutor taskExecutor);
    @AutoFill(OperationTypeEnum.UPDATE)
    void updateByTaskId(TaskExecutor taskExecutor);

    @Delete("delete from task_executor where task_id=#{taskId}")
    void deleteByTaskId(Long taskId);
}

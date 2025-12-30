package com.ruoyi.experiment.mapper;

import com.ruoyi.project.system.domain.SysUser;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TaskUserMapper {
    /**
     * 删除任务用户关联
     */
    @Delete("delete from task_user where task_id = #{taskId}")
    void deleteTaskUsersByTaskId(Long taskId);

    /**
     * 批量插入任务用户关联
     */
    void insertTaskUserBatch(Long taskId, List<Long> userIds);
    /**
     * 根据任务ID查询参与用户
     */
    List<SysUser> selectUsersByTaskId(Long taskId);
    /**
     * 根据任务ID查询参与用户id
     */
    @Select("select user_id from task_user where task_id = #{taskId}")
     List<Long> selectUserIdsByTaskId(Long taskId);

}

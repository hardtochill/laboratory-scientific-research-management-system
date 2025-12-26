package com.ruoyi.experiment.mapper;

import com.ruoyi.project.system.domain.SysUser;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface TaskUserMapper {
    /**
     * 删除任务用户关联
     */
    @Delete("delete from task_user where task_id = #{taskId}")
    void deleteTaskUsers(Long taskId);

    /**
     * 批量插入任务用户关联
     */
    void insertTaskUserBatch(Long taskId, List<Long> userIds);
    /**
     * 根据任务ID查询参与用户
     */
    List<SysUser> selectUsersByTaskId(Long taskId);
}

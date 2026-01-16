package com.ruoyi.experiment.mapper;

import com.ruoyi.project.system.domain.SysUser;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SubmissionPlanUserMapper {
    /**
     * 批量插入投稿计划参与用户
     * @param planId 投稿计划ID
     * @param participantUserIds 参与用户ID列表
     */
    void insertBatch(Long planId, List<Long> participantUserIds);
     /**
      * 根据计划ID删除参与用户
      * @param planId 投稿计划ID
      */
     @Delete("delete from submission_plan_user where plan_id = #{planId}")
    void deleteByPlanId(Long planId);

    /**
     * 查询计划参与用户
     * @param id
     * @return
     */
    List<SysUser> selectUsersByPlanId(Long id);
}

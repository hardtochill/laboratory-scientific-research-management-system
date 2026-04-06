package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.TaskReportFile;
import com.ruoyi.experiment.pojo.vo.TaskReportFileVO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 任务汇报文件Mapper接口
 */
@Mapper
public interface TaskReportFileMapper {
    /**
     * 根据任务汇报ID查询文件列表
     * @param taskReportId 任务汇报ID
     * @return 文件列表
     */
    @Select("select * from task_report_file where task_report_id = #{taskReportId}")
    List<TaskReportFileVO> selectVOByTaskReportId(Long taskReportId);

    /**
     * 根据任务汇报ID查询文件列表
     * @param taskReportId 任务汇报ID
     * @return 文件列表
     */
    @Select("select * from task_report_file where task_report_id = #{taskReportId}")
    List<TaskReportFile> selectByTaskReportId(Long taskReportId);

    /**
     * 新增任务汇报文件
     * @param taskReportFile 任务汇报文件
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(TaskReportFile taskReportFile);

    /**
     * 根据文件ID查询文件路径
     * @param fileId 文件ID
     * @return 文件路径
     */
    @Select("select file_path from task_report_file where id = #{fileId}")
    String selectFilePathById(Long fileId);

    /**
     * 根据任务汇报ID查询所有文件路径
     * @param taskReportId 任务汇报ID
     * @return 文件路径列表
     */
    @Select("select file_path from task_report_file where task_report_id = #{taskReportId}")
    List<String> selectFilePathsByTaskReportId(Long taskReportId);

    /**
     * 根据文件ID查询文件
     * @param fileId 文件ID
     * @return 任务汇报文件
     */
    @Select("select * from task_report_file where id = #{fileId}")
    TaskReportFile selectById(Long fileId);

    /**
     * 根据文件ID删除文件
     * @param fileId 文件ID
     */
    @Delete("delete from task_report_file where id = #{fileId}")
    void deleteById(Long fileId);

    /**
     * 根据任务汇报ID删除文件
     * @param taskReportId 任务汇报ID
     */
    @Delete("delete from task_report_file where task_report_id = #{taskReportId}")
    void deleteByTaskReportId(Long taskReportId);

    /**
     * 批量新增任务汇报文件
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insertBatch(List<TaskReportFile> taskReportFileList);

    /**
     * 根据任务ID列表批量删除文件
     * @param taskIds 任务ID列表
     */
    @Delete("<script>delete from task_report_file where task_report_id in (select id from task_report where task_id in " +
            "<foreach collection='taskIds' item='taskId' open='(' separator=',' close=')'>#{taskId}</foreach>)</script>")
    void deleteByTaskIds(List<Long> taskIds);

    /**
     * 根据任务ID列表查询所有文件路径
     * @param taskIds 任务ID列表
     * @return 文件路径列表
     */
    @Select("<script>select file_path from task_report_file where task_report_id in (select id from task_report where task_id in " +
            "<foreach collection='taskIds' item='taskId' open='(' separator=',' close=')'>#{taskId}</foreach>)</script>")
    List<String> selectFilePathsByTaskId(List<Long> taskIds);
}

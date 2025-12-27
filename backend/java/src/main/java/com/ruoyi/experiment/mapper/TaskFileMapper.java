package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.TaskFile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface TaskFileMapper {

    /**
     * 根据任务ID查询文件列表
     *
     * @param taskId 任务ID
     * @return 文件列表
     */
    @Select("SELECT * FROM task_file WHERE task_id = #{taskId} ORDER BY upload_time ASC")
    List<TaskFile> selectByTaskId(@Param("taskId") Long taskId);

    /**
     * 根据ID查询文件
     *
     * @param id 文件ID
     * @return 文件对象
     */
    @Select("SELECT * FROM task_file WHERE id = #{id}")
    TaskFile selectById(@Param("id") Long id);

    /**
     * 插入文件记录
     *
     * @param taskFile 文件对象
     * @return 影响的行数
     */
    @AutoFill(OperationTypeEnum.INSERT)
    int insert(TaskFile taskFile);

    /**
     * 根据ID删除文件
     *
     * @param id 文件ID
     * @return 影响的行数
     */
    int deleteById(@Param("id") Long id);

    /**
     * 根据ID查询文件名
     *
     * @param id 文件ID
     * @return 文件名
     */
    @Select("SELECT file_path FROM task_file WHERE id = #{id}")
    String selectFilePathById(@Param("id") Long id);
}

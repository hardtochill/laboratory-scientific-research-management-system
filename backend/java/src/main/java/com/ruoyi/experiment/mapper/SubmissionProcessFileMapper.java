package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessFileVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 投稿流程文件Mapper接口
 */
@Mapper
public interface SubmissionProcessFileMapper {

     /**
     * 查询文件详情
     * @param id 文件ID
     * @return 文件详情
     */
     @Select("select * from submission_process_file where id = #{id}")
    SubmissionProcessFile selectByFileId(@Param("id") Long id);
    /**
     * 查询投稿流程的所有文件
     * @param processId 投稿流程ID
     * @return 投稿流程文件列表
     */
    @Select("select * from submission_process_file where process_id = #{processId}")
    List<SubmissionProcessFile> selectByProcessId(Long processId);

    /**
     * 查询投稿流程的所有文件
     * @param processId 投稿流程ID
     * @return 投稿流程文件列表
     */
    List<SubmissionProcessFileVO> selectVOListByProcessId(@Param("processId") Long processId);

    /**
     * 查询文件路径
     */
    @Select("select file_path from submission_process_file where id = #{id}")
    String selectFilePathById(Long id);

    /**
     * 新增投稿流程文件
     * @param submissionProcessFile 投稿流程文件信息
     * @return 影响行数
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(SubmissionProcessFile submissionProcessFile);
    
    /**
     * 删除投稿流程文件
     * @param id 投稿流程文件ID
     * @return 影响行数
     */
    int delete(@Param("id") Long id);

}

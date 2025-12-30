package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.CommentFile;
import com.ruoyi.experiment.pojo.vo.CommentFileVO;
import com.ruoyi.experiment.service.CommentFileService;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 文献评论文件Mapper接口
 */
@Mapper
public interface CommentFileMapper {
    /**
     * 根据评论ID查询文献评论文件
     * @param commentId 评论ID
     * @return 文献评论文件列表
     */
    @Select("select * from comment_file where comment_id = #{commentId}")
    List<CommentFileVO> selectByCommentId(Long commentId);

    /**
     * 新增文献评论文件
     * @param commentFile 文献评论文件
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(CommentFile commentFile);

    /**
     * 根据文件ID查询文件路径
     * @param fileId 文件ID
     * @return 文件路径
     */
    @Select("select file_path from comment_file where id = #{fileId}")
    String selectFilePathById(Long fileId);
     /**
     * 根据评论ID查询评论关联的所有文件的额文件路径
     * @param commentId 评论ID
     * @return 文件路径列表
     */
    @Select("select file_path from comment_file where comment_id = #{commentId}")
    List<String> selectFilePathsByCommentId(Long commentId);

     /**
     * 根据文件ID查询文献评论文件
     * @param fileId 文件ID
     * @return 文献评论文件
     */
    @Select("select * from comment_file where id = #{fileId}")
    CommentFile selectById(Long fileId);

     /**
      * 根据文件ID删除文献评论文件
      * @param fileId 文件ID
      */
     @Delete("delete from comment_file where id = #{fileId}")
    void deleteById(Long fileId);

     /**
      * 根据评论ID删除文献评论文件
      * @param commentId 评论ID
      */
    @Delete("delete from comment_file where comment_id = #{commentId}")
    void deleteByCommentId(Long commentId);
}

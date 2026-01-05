package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.pojo.entity.Comment;
import com.ruoyi.experiment.pojo.vo.CommentVO;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 文献评论Mapper接口
 */
@Mapper
public interface CommentMapper {
    /**
     * 查询父评论列表(教师端)
     */
    List<CommentVO> selectParentCommentListForTeacher(CommentQueryDTO commentQueryDTO);
    /**
     * 查询父评论列表(学生端)
     */
    List<CommentVO> selectParentCommentListForStudent(CommentQueryDTO commentQueryDTO);

    /**
     * 查询子评论列表(教师端)
     */
    List<CommentVO> selectChildCommentListForTeacher(CommentQueryDTO commentQueryDTO);
    /**
     * 查询子评论列表(学生端)
     */
    List<CommentVO> selectChildCommentListForStudent(CommentQueryDTO commentQueryDTO);

    /**
     * 根据评论ID查询评论
     */
    @Select("SELECT * FROM comment WHERE id = #{commentId}")
    Comment selectById(Long commentId);

     /**
      * 更新评论点赞数量
      */
     @Update("update comment set like_count = like_count + #{i} where id = #{commentId}")
    void updateLikeCount(Long commentId, int i);
    /**
     * 查询评论是否有子评论
     */
    @Select("select id from comment where parent_id = #{id} limit 1")
    Integer hasChildComments(Long id);
    /**
     * 查询子评论id列表
     */
     @Select("select id from comment where parent_id = #{id}")
     List<Long> selectChildIds(Long id);
     /**
      * 根据评论ID删除评论
      */
     @Delete("delete from comment where id = #{commentId}")
    void deleteById(Long commentId);

    /**
     * 插入评论
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(Comment comment);
    /**
     * 更新评论可见状态
     */
    @Update("update comment set visible_type = #{visibleType} where id = #{commentId}")
    void updateVisibleType(Long commentId, Integer visibleType);
}

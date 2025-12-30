package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.entity.CommentLike;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 文献评论点赞Mapper接口
 */
@Mapper
public interface CommentLikeMapper {
    /**
     * 查询用户点赞的评论id
     */
    @Select("select comment_id from comment_like where user_id = #{userId}")
    List<Long> selectCommentIdsByUserId(Long userId);

    /**
     * 根据评论ID和用户ID查询评论点赞
     */
    @Select("select * from comment_like where comment_id = #{commentId} and user_id = #{userId} limit 1")
    CommentLike selectByCommentIdAndUserId(Long commentId, Long userId);
     /**
      * 插入评论点赞
      */
     @Insert("insert into comment_like(comment_id, user_id) values(#{commentId}, #{userId})")
    void insert(CommentLike commentLike);
    /**
     * 根据ID删除评论点赞
     */
    @Delete("delete from comment_like where id = #{id}")
    void deleteById(Long id);
    /**
     * 根据评论ID删除评论点赞
     */
    @Delete("delete from comment_like where comment_id = #{commentId}")
    void deleteByCommentId(Long commentId);
}

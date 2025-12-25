package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NoteMapper {
    /**
     * 查询文献心得列表
     */
    List<LiteratureNote> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO);
    
    /**
     * 查询用户点赞的心得ID列表
     */
    List<Long> selectUserLikedNoteIds(@Param("userId") Long userId, @Param("noteIds") List<Long> noteIds);
    
    /**
     * 添加心得点赞
     */
    int addNoteLike(@Param("userId") Long userId, @Param("noteId") Long noteId);
    
    /**
     * 取消心得点赞
     */
    int deleteNoteLike(@Param("userId") Long userId, @Param("noteId") Long noteId);
    
    /**
     * 更新心得点赞数
     */
    int updateNoteLikeCount(@Param("noteId") Long noteId, @Param("delta") int delta);
}

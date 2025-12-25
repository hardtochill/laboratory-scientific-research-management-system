package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.NoteMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureNoteQueryDTO;
import com.ruoyi.experiment.pojo.entity.LiteratureNote;
import com.ruoyi.experiment.pojo.vo.LiteratureNoteVO;
import com.ruoyi.experiment.service.NoteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NoteServiceImpl implements NoteService {
    private final NoteMapper noteMapper;
    
    @Override
    public List<LiteratureNoteVO> selectLiteratureNoteList(LiteratureNoteQueryDTO literatureNoteQueryDTO) {
        // 排序字段转化
        if("publishTime".equals(literatureNoteQueryDTO.getSortField())){
            literatureNoteQueryDTO.setSortField("publish_time");
        }else if("likeCount".equals(literatureNoteQueryDTO.getSortField())){
            literatureNoteQueryDTO.setSortField("like_count");
        }else if(null!=literatureNoteQueryDTO.getSortField()){
            throw new ServiceException("排序字段错误");
        }
        
        // 查询原始心得列表
        List<LiteratureNote> noteList = noteMapper.selectLiteratureNoteList(literatureNoteQueryDTO);
        List<LiteratureNoteVO> voList = new ArrayList<>();
        
        // 如果没有心得，直接返回空列表
        if (noteList.isEmpty()) {
            return voList;
        }
        
        // 获取当前用户ID
        Long currentUserId = SecurityUtils.getUserId();
        
        // 获取所有心得ID
        List<Long> noteIds = noteList.stream()
                .map(LiteratureNote::getId)
                .collect(Collectors.toList());
        
        // 查询当前用户点赞的心得ID列表
        List<Long> likedNoteIds = noteMapper.selectUserLikedNoteIds(currentUserId, noteIds);
        Set<Long> likedNoteIdSet = new HashSet<>(likedNoteIds);
        
        // 转换为VO并设置likeFlag
        for (LiteratureNote note : noteList) {
            LiteratureNoteVO vo = new LiteratureNoteVO();
            vo.setId(note.getId());
            vo.setLiteratureId(note.getLiteratureId());
            vo.setUserId(note.getUserId());
            vo.setUserNickName(note.getUserNickName());
            vo.setNoteContent(note.getNoteContent());
            vo.setLikeCount(note.getLikeCount());
            vo.setVisibleType(note.getVisibleType());
            vo.setPublishTime(note.getPublishTime());
            // 设置是否点赞的标志
            vo.setLikeFlag(likedNoteIdSet.contains(note.getId()));
            voList.add(vo);
        }
        
        return voList;
    }
    
    @Override
    public boolean toggleNoteLike(Long noteId) {
        // 获取当前用户ID
        Long currentUserId = SecurityUtils.getUserId();
        
        // 查询用户是否已经点赞
        List<Long> noteIdList = new ArrayList<>();
        noteIdList.add(noteId);
        List<Long> likedNoteIds = noteMapper.selectUserLikedNoteIds(currentUserId, noteIdList);
        boolean isLiked = !likedNoteIds.isEmpty();
        
        if (isLiked) {
            // 已点赞，取消点赞
            noteMapper.deleteNoteLike(currentUserId, noteId);
            noteMapper.updateNoteLikeCount(noteId, -1);
            return false;
        } else {
            // 未点赞，添加点赞
            noteMapper.addNoteLike(currentUserId, noteId);
            noteMapper.updateNoteLikeCount(noteId, 1);
            return true;
        }
    }
}

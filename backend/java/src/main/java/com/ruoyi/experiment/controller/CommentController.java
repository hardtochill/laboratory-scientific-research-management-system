package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.CommentDTO;
import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController extends BaseController {
    private final CommentService commentService;

    /**
     * 查询父评论列表
     */
    @GetMapping("/listParent")
    public TableDataInfo listParentComments(CommentQueryDTO commentQueryDTO) {
        startPage();
        return getDataTable(commentService.listParentComments(commentQueryDTO));
    }
    /**
     * 查询子评论列表
     */
    @GetMapping("/listChild")
    public TableDataInfo listChildComments(@RequestParam("parentId") Long parentId) {
        startPage();
        return getDataTable(commentService.listChildComments(parentId));
    }

    /**
     * 删除评论
     */
    @DeleteMapping("/delete/{commentId}")
    public AjaxResult deleteComment(@PathVariable("commentId") Long commentId) {
        commentService.deleteComment(commentId);
        return success();
    }

    /**
     * 切换评论点赞状态
     */
    @PostMapping("/toggleLike/{commentId}")
    public AjaxResult toggleLike(@PathVariable("commentId") Long commentId) {
        boolean newLikeStatus = commentService.toggleCommentLike(commentId);
        return success(newLikeStatus);
    }
    /**
     * 发表评论
     */
     @PostMapping("/add")
    public AjaxResult addComment(
            @RequestParam("parentId") Long parentId,
            @RequestParam("literatureId") Long literatureId,
            @RequestParam("commentContent") String commentContent,
            @RequestParam("visibleType") Integer visibleType,
            @RequestParam(value="fileList", required = false) List<MultipartFile> fileList
     ) {
         CommentDTO commentDTO = new CommentDTO();
         commentDTO.setParentId(parentId);
         commentDTO.setLiteratureId(literatureId);
         commentDTO.setCommentContent(commentContent);
         commentDTO.setVisibleType(visibleType);
         commentDTO.setFileList(fileList);
         commentService.addComment(commentDTO);
        return success();
    }
}

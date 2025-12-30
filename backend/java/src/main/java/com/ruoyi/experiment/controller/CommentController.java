package com.ruoyi.experiment.controller;

import com.ruoyi.experiment.pojo.dto.CommentQueryDTO;
import com.ruoyi.experiment.service.CommentService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

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
}

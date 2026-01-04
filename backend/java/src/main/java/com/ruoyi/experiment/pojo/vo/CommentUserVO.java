package com.ruoyi.experiment.pojo.vo;

import com.ruoyi.project.system.domain.SysRole;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 评论用户VO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentUserVO {
    private Long userId;
    private String userName;
    private String userNickName;
    private List<SysRole> roles;
    private String email;
    private String phone;
}

package com.ruoyi.project.system.domain.vo;

import com.ruoyi.project.system.domain.SysRole;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailVO {
    private Long userId;
    private String userName;
    private String userNickName;
    private List<SysRole> roles;
    private String email;
    private String phone;
}

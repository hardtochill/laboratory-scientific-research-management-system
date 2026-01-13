package com.ruoyi.project.system.domain.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserForSelectVO {
    private Long userId;
    private String userName;
    private String nickName;
}

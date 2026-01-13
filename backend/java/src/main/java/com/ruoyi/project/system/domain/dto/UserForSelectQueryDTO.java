package com.ruoyi.project.system.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserForSelectQueryDTO {
    private String nickName;
    private Integer graduateFlag;
    private String roleKey;
}

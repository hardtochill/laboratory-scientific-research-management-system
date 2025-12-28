package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordDTO {
    /**
     * 关键词id
     */
    @NotNull
    private Long id;
    
    /**
     * 关键词名称
     */
    @NotBlank(message = "关键词名称不能为空")
    @Size(max = 100, message = "关键词名称长度不能超过100个字符")
    private String keywordName;
    
    /**
     * 关键词描述
     */
    @Size(max = 500, message = "关键词描述长度不能超过500个字符")
    private String description;
}

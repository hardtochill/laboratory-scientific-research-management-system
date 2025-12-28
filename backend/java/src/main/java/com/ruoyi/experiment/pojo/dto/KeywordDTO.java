package com.ruoyi.experiment.pojo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KeywordDTO {
    /**
     * 关键词id
     */
    @NotNull
    private Long keywordId;
     /**
      * 关键词名称
      */
     @NotBlank
    private String keywordName;
     /**
      * 关键词描述
      */
    private String description;
}

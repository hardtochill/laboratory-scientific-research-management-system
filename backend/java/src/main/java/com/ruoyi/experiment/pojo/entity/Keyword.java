package com.ruoyi.experiment.pojo.entity;

import com.fasterxml.jackson.databind.ser.Serializers;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Keyword extends BaseEntity {
    /**
     * id
     */
    private Long id;
    /**
     * 关键词名称
     */
    private String keywordName;
     /**
      * 关键词描述
      */
    private String description;
    /**
     * 使用次数
     */
     private Integer usageCount;
}

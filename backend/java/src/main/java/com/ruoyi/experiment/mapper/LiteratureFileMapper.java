package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.LiteratureFile;
import com.ruoyi.experiment.pojo.entity.TaskFile;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface LiteratureFileMapper {
    /**
     * 根据文献id查询文献文件路径
     */
    @Select("select file_path from literature_file where literature_id = #{id}")
    String selectFilePathById(Long id);
    /**
     * 新增文献文件
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(LiteratureFile literatureFile);
}

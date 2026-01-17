package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import com.ruoyi.experiment.pojo.entity.LiteratureFile;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface LiteratureFileMapper {
    /**
     * 根据文献id查询文献文件路径
     */
    @Select("select file_path from literature_file where literature_id = #{id}")
    String selectFilePathByLiteratureId(Long id);
    /**
     * 新增文献文件
     */
    @AutoFill(OperationTypeEnum.INSERT)
    void insert(LiteratureFile literatureFile);
     /**
      * 根据文献id删除文献文件
      */
     @Delete("delete from literature_file where literature_id = #{literatureId}")
    void deleteByLiteratureId(Long literatureId);
}

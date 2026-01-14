package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.LiteratureStatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LiteratureStatisticMapper {
    List<StudentReadStatisticsVO> selectStudentReadingStatistics(@Param("queryDTO") LiteratureStatisticQueryDTO queryDTO);

    List<StudentReadStatisticsVO.LiteratureReadDetail> selectStudentLiteratureDetail(
            @Param("userId") Long userId,
            @Param("startTime") java.time.LocalDateTime startTime,
            @Param("endTime") java.time.LocalDateTime endTime);

    List<LiteratureReadStatisticsVO> selectLiteratureReadingStatistics(@Param("queryDTO") LiteratureStatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO.StudentReadDetail> selectLiteratureStudentDetail(
            @Param("literatureId") Long literatureId,
            @Param("startTime") java.time.LocalDateTime startTime,
            @Param("endTime") java.time.LocalDateTime endTime);

    List<StudentReadStatisticsVO> selectStudentStatisticsForExport(@Param("queryDTO") LiteratureStatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO> selectLiteratureStatisticsForExport(@Param("queryDTO") LiteratureStatisticQueryDTO queryDTO);
}

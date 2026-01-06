package com.ruoyi.experiment.mapper;

import com.ruoyi.experiment.pojo.dto.StatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StatisticMapper {
    List<StudentReadStatisticsVO> selectStudentReadingStatistics(@Param("queryDTO") StatisticQueryDTO queryDTO);

    List<StudentReadStatisticsVO.LiteratureReadDetail> selectStudentLiteratureDetail(
            @Param("userId") Long userId,
            @Param("startTime") java.time.LocalDateTime startTime,
            @Param("endTime") java.time.LocalDateTime endTime);

    List<LiteratureReadStatisticsVO> selectLiteratureReadingStatistics(@Param("queryDTO") StatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO.StudentReadDetail> selectLiteratureStudentDetail(
            @Param("literatureId") Long literatureId,
            @Param("startTime") java.time.LocalDateTime startTime,
            @Param("endTime") java.time.LocalDateTime endTime);

    List<StudentReadStatisticsVO> selectStudentStatisticsForExport(@Param("queryDTO") StatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO> selectLiteratureStatisticsForExport(@Param("queryDTO") StatisticQueryDTO queryDTO);
}

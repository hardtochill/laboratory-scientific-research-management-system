package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.StatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import com.ruoyi.framework.web.page.TableDataInfo;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.util.List;

public interface StatisticService {
    List<StudentReadStatisticsVO> selectStudentReadingStatistics(StatisticQueryDTO queryDTO);

    List<StudentReadStatisticsVO.LiteratureReadDetail> selectStudentLiteratureDetail(Long studentId, LocalDateTime startTime, LocalDateTime endTime);

    List<LiteratureReadStatisticsVO> selectLiteratureReadingStatistics(StatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO.StudentReadDetail> selectLiteratureStudentDetail(Long literatureId, LocalDateTime startTime, LocalDateTime endTime);

    void exportStatistics(StatisticQueryDTO queryDTO, HttpServletResponse response);
}

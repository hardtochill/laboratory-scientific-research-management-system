package com.ruoyi.experiment.service;

import com.ruoyi.experiment.pojo.dto.StatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.util.List;

public interface StatisticService {
    List<StudentReadStatisticsVO> selectStudentReadingStatistics(StatisticQueryDTO queryDTO);

    List<StudentReadStatisticsVO.LiteratureReadDetail> selectStudentLiteratureDetail(Long studentId, LocalDateTime startTime, LocalDateTime endTime);

    List<LiteratureReadStatisticsVO> selectLiteratureReadingStatistics(StatisticQueryDTO queryDTO);

    List<LiteratureReadStatisticsVO.StudentReadDetail> selectLiteratureStudentDetail(Long literatureId, LocalDateTime startTime, LocalDateTime endTime);

    void exportStatistics(StatisticQueryDTO queryDTO, HttpServletResponse response);

    /**
     * 获取用户列表（用于前端用户选择）
     */
    List<UserForSelectVO> listUsersForSelect(String nickName);
}

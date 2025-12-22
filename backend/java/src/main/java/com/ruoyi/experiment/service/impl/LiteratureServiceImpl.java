package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.experiment.mapper.LiteratureMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.entity.LiteratureScore;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import com.ruoyi.experiment.service.LiteratureService;
import com.ruoyi.project.system.domain.SysUser;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Slf4j
public class LiteratureServiceImpl implements LiteratureService {
    private final LiteratureMapper literatureMapper;

    // 从配置文件中获取文献存储路径
    @Value("${experiment.literature.path}")
    private String literaturePath;
    
    @Override
    public List<LiteratureVO> selectLiteratureList(LiteratureQueryDTO queryDTO) {
        queryDTO.setUserId(SecurityUtils.getUserId());
        // 排序字段转化
        if("publishTime".equals(queryDTO.getSortField())){
            queryDTO.setSortField("publish_time");
        }else if("downloadCount".equals(queryDTO.getSortField())){
            queryDTO.setSortField("download_count");
        }else if ("finalScore".equals(queryDTO.getSortField())){
            queryDTO.setSortField("final_score");
        }
        return literatureMapper.selectLiteratureList(queryDTO);
    }
    
    @Override
    public Literature selectLiteratureDetail(Long id) {
        return literatureMapper.selectLiteratureById(id);
    }

    @Override
    public Integer getUserLiteratureScore(Long literatureId, Long userId) {
        LiteratureScore literatureScore = literatureMapper.selectLiteratureScore(literatureId, userId);
        return literatureScore != null ? literatureScore.getScore() : null;
    }
    
    @Override
    public void downloadLiterature(Long id,HttpServletResponse response) {
        // 更新下载数
        literatureMapper.updateDownloadCount(id);
        
        // 返回文献对象
        Literature literature = literatureMapper.selectLiteratureById(id);
        // 构建文件路径：配置的存储路径 + 文献id + .pdf
        String filePath = literaturePath + id + ".pdf";
        File file = new File(filePath);

        // 检查文件是否存在
        if (!file.exists()) {
            throw new ServiceException("文件已失效，请重新上传");
        }

        // 设置响应头
        String fileName = literature.getTitle() + ".pdf";
        try{
            FileUtils.setAttachmentResponseHeader(response, fileName);
            FileUtils.writeBytes(filePath, response.getOutputStream());
        }catch (Exception e){
            throw new ServiceException("下载文件失败");
        }
    }

    @Override
    public void scoreLiterature(LiteratureScoreDTO scoreDTO) {
        Long userId = SecurityUtils.getUserId();
        Long literatureId = scoreDTO.getLiteratureId();
        Integer score = scoreDTO.getScore();
        
        // 验证评分范围
        if (score < 0 || score > 10) {
            throw new ServiceException("评分必须在0-10之间");
        }
        
        // 查询用户是否已经评分
        LiteratureScore literatureScore = literatureMapper.selectLiteratureScore(literatureId, userId);
        
        if (literatureScore == null) {
            // 新增评分记录
            literatureScore = new LiteratureScore();
            literatureScore.setLiteratureId(literatureId);
            literatureScore.setUserId(userId);
            literatureScore.setScore(score);
            literatureMapper.insertLiteratureScore(literatureScore);
        } else {
            // 更新评分记录
            literatureScore.setScore(score);
            literatureMapper.updateLiteratureScore(literatureScore);
        }

        boolean isTeacher = SecurityUtils.hasRole("teacher");

        // todo 更新评分和计算评分改为定时任务触发
        // 更新文献的评分统计信息
        updateLiteratureScoreStatistics(literatureId, isTeacher);
        // 重新计算最终评分
        calculateFinalScore(literatureId);
    }
    
    /**
     * 更新文献的评分统计信息
     */
    private void updateLiteratureScoreStatistics(Long literatureId, boolean isTeacher) {
        if (isTeacher) {
            // 更新教师评分统计
            Map<String, Object> statistics = literatureMapper.selectTeacherScoreStatistics(literatureId);
            if (statistics != null) {
                Double avgScore = statistics.get("avgScore") != null ? Double.parseDouble(statistics.get("avgScore").toString()) : 0.0;
                Integer count = statistics.get("count") != null ? Integer.parseInt(statistics.get("count").toString()) : 0;
                literatureMapper.updateTeacherScore(literatureId, avgScore, count);
            }
        } else {
            // 更新学生评分统计
            Map<String, Object> statistics = literatureMapper.selectStudentScoreStatistics(literatureId);
            if (statistics != null) {
                Double avgScore = statistics.get("avgScore") != null ? Double.parseDouble(statistics.get("avgScore").toString()) : 0.0;
                Integer count = statistics.get("count") != null ? Integer.parseInt(statistics.get("count").toString()) : 0;
                literatureMapper.updateStudentScore(literatureId, avgScore, count);
            }
        }
    }
    
    /**
     * 计算文献的最终评分
     */
    private void calculateFinalScore(Long literatureId) {
        // 查询文献信息
        Literature literature = literatureMapper.selectLiteratureById(literatureId);
        if (literature == null) {
            return;
        }
        
        // 获取各维度的评分
        Double teacherScoreAvg = literature.getTeacherScoreAvg() != null ? literature.getTeacherScoreAvg().doubleValue() : 0;
        Integer teacherScoreCount = literature.getTeacherScoreCount() != null ? literature.getTeacherScoreCount() : 0;
        
        Double studentScoreAvg = literature.getStudentScoreAvg() != null ? literature.getStudentScoreAvg().doubleValue() : 0;
        Integer studentScoreCount = literature.getStudentScoreCount() != null ? literature.getStudentScoreCount() : 0;
        
        Integer downloadCount = literature.getDownloadCount() != null ? literature.getDownloadCount() : 0;
        
        // 计算下载数归一化得分
        Integer maxDownloadCount = literatureMapper.selectMaxDownloadCount();
        if (maxDownloadCount == null) {
            maxDownloadCount = 1; // 避免分母为0
        }
        Double dScore = (double) downloadCount / maxDownloadCount * 10;
        
        // 计算各维度的权重
        double teacherWeight = 0.6;
        double studentWeight = 0.3;
        double downloadWeight = 0.1;
        
        // 调整权重（如果某维度无数据，将该维度权重按比例分配给其他维度）
        double totalWeight = 0;
        if (teacherScoreCount > 0) {
            totalWeight += teacherWeight;
        }
        if (studentScoreCount > 0) {
            totalWeight += studentWeight;
        }
        if (downloadCount > 0) {
            totalWeight += downloadWeight;
        }
        
        double finalScore = 0;
        if (totalWeight > 0) {
            if (teacherScoreCount > 0) {
                finalScore += teacherScoreAvg * (teacherWeight / totalWeight);
            }
            if (studentScoreCount > 0) {
                finalScore += studentScoreAvg * (studentWeight / totalWeight);
            }
            if (downloadCount > 0) {
                finalScore += dScore * (downloadWeight / totalWeight);
            }
        }
        
        // 保留1位小数
        DecimalFormat df = new DecimalFormat("#.#");
        finalScore = Double.parseDouble(df.format(finalScore));
        
        // 更新文献的最终得分
        literatureMapper.updateFinalScore(literatureId, finalScore);
    }
}
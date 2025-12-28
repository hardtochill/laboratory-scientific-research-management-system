package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.mapper.KeywordMapper;
import com.ruoyi.experiment.mapper.LiteratureKeywordMapper;
import com.ruoyi.experiment.mapper.LiteratureMapper;
import com.ruoyi.experiment.mapper.LiteratureScoreMapper;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.entity.LiteratureScore;
import com.ruoyi.experiment.pojo.vo.LiteratureDetailVO;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import com.ruoyi.experiment.pojo.vo.KeywordVO;
import com.ruoyi.experiment.service.LiteratureService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class LiteratureServiceImpl implements LiteratureService {
    private final LiteratureMapper literatureMapper;
    private final LiteratureKeywordMapper literatureKeywordMapper;
    private final LiteratureScoreMapper literatureScoreMapper;
    private final KeywordMapper keywordMapper;
    private final ExperimentConfig experimentConfig;
    
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
    public LiteratureDetailVO selectLiteratureDetail(Long id) {
        // 查询文献基本信息
        LiteratureDetailVO literatureDetail = literatureMapper.selectLiteratureDetail(id);
        if (literatureDetail == null) {
            return null;
        }
        
        // 查询关键词列表
        List<KeywordVO> keywords = keywordMapper.selectKeywordsByLiteratureId(id);
        literatureDetail.setKeywords(keywords);
        
        // 查询用户评分
        Long userId = SecurityUtils.getUserId();
        Integer userScore = literatureScoreMapper.selectUserScore(id, userId);
        literatureDetail.setUserScore(userScore);
        
        return literatureDetail;
    }

    @Override
    public void downloadLiterature(Long id,HttpServletResponse response) {
        // 更新下载数
        literatureMapper.updateDownloadCount(id);

        String filePath = literatureMapper.selectFilePathById(id);
        if(null==filePath){
            throw new ServiceException("文献不存在");
        }
        try{
            FileUtils.downloadFile(experimentConfig.getLiteratureBaseDir(), filePath, response);
        }catch (Exception e){
            log.error("文献下载失败", e);
            throw new ServiceException("文献下载失败");
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
            literatureScoreMapper.insertLiteratureScore(literatureScore);
        } else {
            // 更新评分记录
            literatureScore.setScore(score);
            literatureScoreMapper.updateLiteratureScore(literatureScore);
        }

        boolean isTeacher = SecurityUtils.hasRole("teacher");

        // todo 更新评分和计算评分改为定时任务触发
        // 更新文献的评分统计信息
        updateLiteratureScoreStatistics(literatureId, isTeacher);
        // 重新计算最终评分
        calculateFinalScore(literatureId);
    }

    @Transactional
    public void updateLiteratureKeywords(Long literatureId, List<Long> keywordIds) {
        // 首先移除所有现有的关键词关联
        removeKeywordsFromLiterature(literatureId,keywordIds);

        // 然后添加新的关键词关联
        if (!CollectionUtils.isEmpty(keywordIds)) {
            addKeywordsToLiterature(literatureId, keywordIds);
        }
    }
    private void removeKeywordsFromLiterature(Long literatureId, List<Long> keywordIds) {
        // 批量移除关键词关联
        literatureKeywordMapper.deleteBatch(literatureId);
        // 批量更新关键词的使用次数
        keywordMapper.updateUsageCountBatch(keywordIds,-1);
    }
    private void addKeywordsToLiterature(Long literatureId, List<Long> keywordIds) {
        // 批量添加关键词关联
        literatureKeywordMapper.insertBatch(literatureId, keywordIds);
        // 批量更新关键词的使用次数
        keywordMapper.updateUsageCountBatch(keywordIds,1);
    }

    /**
     * 更新文献的评分统计信息
     */
    private void updateLiteratureScoreStatistics(Long literatureId, boolean isTeacher) {
        if (isTeacher) {
            // 更新教师评分统计
            Map<String, Object> statistics = literatureScoreMapper.selectTeacherScoreStatistics(literatureId);
            if (statistics != null) {
                Double avgScore = statistics.get("avgScore") != null ? Double.parseDouble(statistics.get("avgScore").toString()) : 0.0;
                Integer count = statistics.get("count") != null ? Integer.parseInt(statistics.get("count").toString()) : 0;
                literatureMapper.updateTeacherScore(literatureId, avgScore, count);
            }
        } else {
            // 更新学生评分统计
            Map<String, Object> statistics = literatureScoreMapper.selectStudentScoreStatistics(literatureId);
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
        double teacherScoreAvg = literature.getTeacherScoreAvg() != null ? literature.getTeacherScoreAvg().doubleValue() : 0;
        int teacherScoreCount = literature.getTeacherScoreCount() != null ? literature.getTeacherScoreCount() : 0;

        double studentScoreAvg = literature.getStudentScoreAvg() != null ? literature.getStudentScoreAvg().doubleValue() : 0;
        int studentScoreCount = literature.getStudentScoreCount() != null ? literature.getStudentScoreCount() : 0;

        int downloadCount = literature.getDownloadCount() != null ? literature.getDownloadCount() : 0;

        // 计算下载数归一化得分
        Integer maxDownloadCount = literatureMapper.selectMaxDownloadCount();
        if (maxDownloadCount == null) {
            maxDownloadCount = 1; // 避免分母为0
        }
        double dScore = (double) downloadCount / maxDownloadCount * 10;

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
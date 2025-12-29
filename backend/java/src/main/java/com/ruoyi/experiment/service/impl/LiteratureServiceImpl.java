package com.ruoyi.experiment.service.impl;

import com.github.promeg.pinyinhelper.Pinyin;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.experiment.mapper.*;
import com.ruoyi.experiment.pojo.dto.LiteratureDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.entity.Literature;
import com.ruoyi.experiment.pojo.entity.LiteratureFile;
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
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class LiteratureServiceImpl implements LiteratureService {
    private final LiteratureMapper literatureMapper;
    private final LiteratureKeywordMapper literatureKeywordMapper;
    private final LiteratureScoreMapper literatureScoreMapper;
    private final LiteratureFileMapper literatureFileMapper;
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
    @Override
    public void addLiterature(LiteratureDTO literatureDTO) {
        // 1.文献名称重复校验
        String identifier = getIdentifier(literatureDTO.getTitle());
        if(null != literatureMapper.selectIdentifier(identifier)){
            throw new ServiceException("文献已上传");
        }
        // 2.bean构造
        Literature literature = new Literature();
        BeanUtils.copyProperties(literatureDTO,literature);
        literature.setIdentifier(identifier);
        literature.setDownloadCount(0);
        literature.setTeacherScoreAvg(BigDecimal.ZERO);
        literature.setTeacherScoreCount(0);
        literature.setStudentScoreAvg(BigDecimal.ZERO);
        literature.setStudentScoreCount(0);
        literature.setFinalScore(BigDecimal.ZERO);
        literature.setUploadUserId(SecurityUtils.getUserId());
        literature.setUploadUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        literature.setUploadTime(LocalDateTime.now());
        // 3.插入literature记录
        literatureMapper.insertLiterature(literature);
        // 4.插入keyword记录
        addKeywordsToLiterature(literature.getId(),literatureDTO.getKeywordIds());
        // 5.保存文件
        uploadLiterature(literature.getId(),literatureDTO.getTitle(),literatureDTO.getFile());
    }

    public void uploadLiterature(Long literatureId, String fileName,MultipartFile file){
        // 1.保存文件到本地
        String filePath;
        try{
            filePath = FileUtils.uploadLiteratureFile(experimentConfig.getLiteratureBaseDir(), file);
        }catch (Exception e){
            log.error("文献文件上传失败", e);
            throw new ServiceException("文献文件上传失败");
        }
        // 2.插入数据库记录
        LiteratureFile literatureFile = new LiteratureFile();
        literatureFile.setLiteratureId(literatureId);
        literatureFile.setFileName(fileName);
        literatureFile.setFilePath(filePath);
        literatureFile.setFileType(FileUploadUtils.getExtension(file));
        literatureFile.setFileSize(file.getSize());
        literatureFile.setUploadUserId(SecurityUtils.getUserId());
        literatureFile.setUploadTime(LocalDateTime.now());
        literatureFileMapper.insert(literatureFile);
    }

    @Override
    public void downloadLiterature(Long id,HttpServletResponse response) {
        // 更新下载数
        literatureMapper.updateDownloadCount(id);

        String filePath = literatureFileMapper.selectFilePathById(id);
        if(null==filePath){
            throw new ServiceException("文献文件按不存在");
        }
        try{
            FileUtils.downloadFile(experimentConfig.getLiteratureBaseDir(), filePath, response);
        }catch (Exception e){
            log.error("文献文件下载失败", e);
            throw new ServiceException("文献文件下载失败");
        }
    }
    private void removeKeywordsFromLiterature(Long literatureId, List<Long> keywordIds) {
        if(CollectionUtils.isEmpty(keywordIds)){
            return;
        }
        // 批量移除关键词关联
        literatureKeywordMapper.deleteBatch(literatureId);
        // 批量更新关键词的使用次数
        keywordMapper.updateUsageCountBatch(keywordIds,-1);
    }
    private void addKeywordsToLiterature(Long literatureId, List<Long> keywordIds) {
        if(CollectionUtils.isEmpty(keywordIds)){
            return;
        }
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

    /**
     * 获取文献的唯一标识符
     * @return
     */
    private String getIdentifier(String title){
        // 1. 去除所有空格和连接符号（只保留字母、数字和中文）
        title = title.replaceAll("[^a-zA-Z0-9\\u4e00-\\u9fa5]", "");

        // 2. 处理中文转拼音大写和英文转大写
        StringBuilder identifier = new StringBuilder();
        for (char c : title.toCharArray()) {
            // 中文转拼音大写
            if (Character.toString(c).matches("[\\u4e00-\\u9fa5]")) {
                String pinyin = Pinyin.toPinyin(c);
                identifier.append(pinyin);
            } else {
                // 英文转大写
                identifier.append(Character.toUpperCase(c));
            }
        }
        return identifier.toString();
    }

}
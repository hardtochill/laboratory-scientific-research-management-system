package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.enums.*;
import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.mapper.ReviewMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessFileMapper;
import com.ruoyi.experiment.pojo.dto.SubmissionProcessDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessFileVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessVO;
import com.ruoyi.experiment.service.SubmissionProcessService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import com.ruoyi.project.system.domain.dto.UserForSelectQueryDTO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class SubmissionProcessServiceImpl implements SubmissionProcessService {
    private final SubmissionProcessMapper submissionProcessMapper;
    private final SubmissionPlanMapper submissionPlanMapper;
    private final ReviewMapper reviewMapper;
    private final SubmissionProcessFileMapper submissionProcessFileMapper;
    private final SysUserMapper userMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<SubmissionProcessVO> listSubmissionProcessesByPlanId(Long planId) {
        List<SubmissionProcessVO> submissionProcessVOs = submissionProcessMapper.selectByPlanId(planId);
        for (SubmissionProcessVO submissionProcessVO : submissionProcessVOs) {
            // 关联文件列表
            List<SubmissionProcessFileVO> submissionProcessFiles = submissionProcessFileMapper.selectVOListByProcessId(
                    submissionProcessVO.getId());
            // 文件分类
            if(SubmissionProcessNameEnum.FIRST_REVIEW.getName().equals(submissionProcessVO.getName())){ // 一审
                // 提交给期刊的文件
                List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
                // 原始数据与程序
                List<SubmissionProcessFileVO> rawDataAndProgramFiles = new ArrayList<>();
                for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                    if(SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())){
                        journalSubmissionFiles.add(submissionProcessFile);
                    }else if(SubmissionProcessFileTagEnum.RAW_DATA_AND_PROGRAM.getTag().equals(submissionProcessFile.getTag())){
                        rawDataAndProgramFiles.add(submissionProcessFile);
                    }
                }
                submissionProcessVO.setJournalSubmissionFiles(journalSubmissionFiles);
                submissionProcessVO.setRawDataAndProgramFiles(rawDataAndProgramFiles);
            }else if(SubmissionProcessNameEnum.JOURNAL_EDITOR_REVIEW.getName().equals(submissionProcessVO.getName())){ // 校稿
                // 最终稿
                submissionProcessVO.setFinalDraftFiles(submissionProcessFiles);
            }else{ // n审
                // 审稿意见
                List<SubmissionProcessFileVO> reviewCommentsFiles = new ArrayList<>();
                // 提交给期刊的文件
                List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
                // 补充数据
                List<SubmissionProcessFileVO> supplementaryDataFiles = new ArrayList<>();
                for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                    if(SubmissionProcessFileTagEnum.REVIEW_COMMENTS.getTag().equals(submissionProcessFile.getTag())){
                        reviewCommentsFiles.add(submissionProcessFile);
                    }else if(SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())){
                        journalSubmissionFiles.add(submissionProcessFile);
                    }else if(SubmissionProcessFileTagEnum.SUPPLEMENTARY_DATA.getTag().equals(submissionProcessFile.getTag())){
                        supplementaryDataFiles.add(submissionProcessFile);
                    }
                }
                submissionProcessVO.setReviewCommentsFiles(reviewCommentsFiles);
                submissionProcessVO.setJournalSubmissionFiles(journalSubmissionFiles);
                submissionProcessVO.setSupplementaryDataFiles(supplementaryDataFiles);
            }
        }
        return submissionProcessVOs;
    }

    @Override
    public void createSubmissionProcess(SubmissionProcessDTO submissionProcessDTO) {
        // 1. 校验投稿计划是否存在
        SubmissionPlan submissionPlan = submissionPlanMapper.selectById(submissionProcessDTO.getPlanId());
        if (submissionPlan == null) {
            throw new RuntimeException("投稿计划不存在");
        }
        // 2.校验审核人是否存在
        if(null==userMapper.selectUserById(submissionProcessDTO.getReviewerUserId())){
            throw new RuntimeException("审核人不存在");
        }
        SubmissionProcess submissionProcess = new SubmissionProcess();
        BeanUtils.copyProperties(submissionProcessDTO, submissionProcess);
        // 3.初始状态必须为待发起内部审核
        submissionProcess.setStatus(SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue());
        // 4. 流程创建时间
        submissionProcess.setProcessCreateTime(LocalDateTime.now());
        // 5.保存投稿流程
        submissionProcessMapper.insert(submissionProcess);
    }

    @Override
    public void updateSubmissionProcess(SubmissionProcessDTO submissionProcessDTO) {
        // 1.查出原流程
        SubmissionProcess originProcess = submissionProcessMapper.selectByProcessId(submissionProcessDTO.getId());
        if(null==originProcess){
            throw new ServiceException("投稿流程不存在");
        }
        // 2.投稿任务是否合法
        if(null!=originProcess.getPlanId() && !originProcess.getPlanId().equals(submissionProcessDTO.getPlanId())){
            throw new ServiceException("投稿任务异常");
        }
        // 3.审核人是否合法
        if(null!=originProcess.getReviewerUserId()
                 && !originProcess.getReviewerUserId().equals(submissionProcessDTO.getReviewerUserId())
                && null==userMapper.selectUserById(submissionProcessDTO.getReviewerUserId())){
            throw new ServiceException("审核人异常");
        }
        SubmissionProcess submissionProcess = new SubmissionProcess();
        BeanUtils.copyProperties(submissionProcessDTO, submissionProcess);
        submissionProcessMapper.update(submissionProcess);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSubmissionProcess(Long id) {
        List<SubmissionProcessFile> submissionProcessFiles = submissionProcessFileMapper.selectByProcessId(id);

        // 1.删除关联文件记录
        submissionProcessFileMapper.deleteByProcessId(id);

        // 2.删除投稿流程记录
        submissionProcessMapper.deleteByProcessId(id);

        // 3.删除物理文件
        for (SubmissionProcessFile submissionProcessFile : submissionProcessFiles) {
            Path filePath = Paths.get(FileUtils.getFileAbsolutePath(experimentConfig.getSubmissionBaseDir(), submissionProcessFile.getFilePath()));
            try {
                if (Files.exists(filePath)) {
                    Files.delete(filePath);
                }
            } catch (Exception e) {
                log.error("文件删除失败", e);
                throw new ServiceException("文件删除失败");
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitForReview(Long processId, String reviewedRemark) {
        // 1. 查询投稿流程信息
        SubmissionProcess submissionProcess = submissionProcessMapper.selectByProcessId(processId);
        if (null==submissionProcess) {
            throw new RuntimeException("投稿流程不存在");
        }
        // 2.校验审核人是否存在
        if(null==submissionProcess.getReviewerUserId()){
            throw new ServiceException("请先指定审核人");
        }
        // 3.只有“待发起内部审核”和“内部审核不通过”才能发起审核流程
        if(!ArrayUtils.contains(
                new int[]{SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue(),SubmissionProcessStatusEnum.REVIEW_FAILED.getValue()}
                ,submissionProcess.getStatus())){
                throw new ServiceException("投稿流程状态异常，仅“待发起内部审核”和“内部审核不通过”状态下才能发起审核流程");
        }
        // 4. 更新投稿流程状态为"内部审核中"
        submissionProcessMapper.updateStatus(processId,SubmissionProcessStatusEnum.REVIEWING.getValue());
        
        // 4. 创建审核记录
        Review review = new Review();
        review.setPlanId(submissionProcess.getPlanId());
        review.setProcessId(processId);
        review.setReviewedUserId(SecurityUtils.getUserId());
        review.setReviewedUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        review.setReviewerUserId(submissionProcess.getReviewerUserId());
        review.setReviewerUserNickName(submissionProcess.getReviewerUserNickName());
        review.setStatus(ReviewStatusEnum.PENDING.getValue());
        review.setReviewedRemark(reviewedRemark);
        review.setReviewerRemark(null);
        review.setReviewCreateTime(LocalDateTime.now());
        review.setReviewFinishTime(null);
        reviewMapper.insert(review);
    }

    @Override
    public SubmissionProcessDetailVO getSubmissionProcessDetail(Long id) {
        SubmissionProcessDetailVO vo = submissionProcessMapper.selectDetailByProcessId(id);
        // 关联文件列表
        List<SubmissionProcessFileVO> submissionProcessFiles = submissionProcessFileMapper.selectVOListByProcessId(id);
        // 文件分类
        if(SubmissionProcessNameEnum.FIRST_REVIEW.getName().equals(vo.getName())){ // 一审
            // 提交给期刊的文件
            List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
            // 原始数据与程序
            List<SubmissionProcessFileVO> rawDataAndProgramFiles = new ArrayList<>();
            for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                if(SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())){
                    journalSubmissionFiles.add(submissionProcessFile);
                }else if(SubmissionProcessFileTagEnum.RAW_DATA_AND_PROGRAM.getTag().equals(submissionProcessFile.getTag())){
                    rawDataAndProgramFiles.add(submissionProcessFile);
                }
            }
            vo.setJournalSubmissionFiles(journalSubmissionFiles);
            vo.setRawDataAndProgramFiles(rawDataAndProgramFiles);
        }else if(SubmissionProcessNameEnum.JOURNAL_EDITOR_REVIEW.getName().equals(vo.getName())){ // 校稿
            // 最终稿
            vo.setFinalDraftFiles(submissionProcessFiles);
        }else{ // n审
            // 审稿意见
            List<SubmissionProcessFileVO> reviewCommentsFiles = new ArrayList<>();
            // 提交给期刊的文件
            List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
            // 补充数据
            List<SubmissionProcessFileVO> supplementaryDataFiles = new ArrayList<>();
            for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                if(SubmissionProcessFileTagEnum.REVIEW_COMMENTS.getTag().equals(submissionProcessFile.getTag())){
                    reviewCommentsFiles.add(submissionProcessFile);
                }else if(SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())){
                    journalSubmissionFiles.add(submissionProcessFile);
                }else if(SubmissionProcessFileTagEnum.SUPPLEMENTARY_DATA.getTag().equals(submissionProcessFile.getTag())){
                    supplementaryDataFiles.add(submissionProcessFile);
                }
            }
            vo.setReviewCommentsFiles(reviewCommentsFiles);
            vo.setJournalSubmissionFiles(journalSubmissionFiles);
            vo.setSupplementaryDataFiles(supplementaryDataFiles);
        }
        return vo;
    }

    @Override
    public List<UserForSelectVO> listReviewerUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        queryDTO.setGraduateFlag(UserGraduateFlagEnum.UNGRADUATED.getValue());
        queryDTO.setRoleKey(RoleEnums.TEACHER.getRoleKey());
        return userMapper.selectVOForSelect(queryDTO);
    }
}
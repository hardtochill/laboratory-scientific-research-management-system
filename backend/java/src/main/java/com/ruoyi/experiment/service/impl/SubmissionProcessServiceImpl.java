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
import com.ruoyi.experiment.pojo.dto.SubmitReviewDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.Review;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanDetailVO;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;

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
        log.info("投稿流程模块-查询投稿计划下的投稿流程列表：{}", planId);
        List<SubmissionProcessVO> submissionProcessVOs = submissionProcessMapper.selectByPlanId(planId);

        if (submissionProcessVOs.isEmpty()) {
            return submissionProcessVOs;
        }

        List<Long> processIds = submissionProcessVOs.stream()
                .map(SubmissionProcessVO::getId)
                .collect(Collectors.toList());

        List<SubmissionProcessFile> allFiles = submissionProcessFileMapper.selectByProcessIds(processIds);

        Map<Long, List<SubmissionProcessFile>> filesByProcessId = allFiles.stream()
                .collect(Collectors.groupingBy(SubmissionProcessFile::getProcessId));

        Map<Long, List<SubmissionProcessFileVO>> voFilesByProcessId = new HashMap<>();
        for (Map.Entry<Long, List<SubmissionProcessFile>> entry : filesByProcessId.entrySet()) {
            Long processId = entry.getKey();
            List<SubmissionProcessFile> files = entry.getValue();
            List<SubmissionProcessFileVO> voFiles = files.stream()
                    .map(file -> {
                        SubmissionProcessFileVO vo = new SubmissionProcessFileVO();
                        BeanUtils.copyProperties(file, vo);
                        return vo;
                    })
                    .collect(Collectors.toList());
            voFilesByProcessId.put(processId, voFiles);
        }

        for (SubmissionProcessVO submissionProcessVO : submissionProcessVOs) {
            Long processId = submissionProcessVO.getId();
            List<SubmissionProcessFileVO> processFiles = voFilesByProcessId.getOrDefault(processId, Collections.emptyList());

            if (SubmissionProcessNameEnum.FIRST_REVIEW.getName().equals(submissionProcessVO.getName())) {
                List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
                List<SubmissionProcessFileVO> rawDataAndProgramFiles = new ArrayList<>();
                for (SubmissionProcessFileVO submissionProcessFile : processFiles) {
                    if (SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())) {
                        journalSubmissionFiles.add(submissionProcessFile);
                    } else if (SubmissionProcessFileTagEnum.RAW_DATA_AND_PROGRAM.getTag().equals(submissionProcessFile.getTag())) {
                        rawDataAndProgramFiles.add(submissionProcessFile);
                    }
                }
                submissionProcessVO.setJournalSubmissionFiles(journalSubmissionFiles);
                submissionProcessVO.setRawDataAndProgramFiles(rawDataAndProgramFiles);
            } else if (SubmissionProcessNameEnum.JOURNAL_EDITOR_REVIEW.getName().equals(submissionProcessVO.getName())) {
                submissionProcessVO.setFinalDraftFiles(processFiles);
            } else {
                List<SubmissionProcessFileVO> reviewCommentsFiles = new ArrayList<>();
                List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
                List<SubmissionProcessFileVO> supplementaryDataFiles = new ArrayList<>();
                for (SubmissionProcessFileVO submissionProcessFile : processFiles) {
                    if (SubmissionProcessFileTagEnum.REVIEW_COMMENTS.getTag().equals(submissionProcessFile.getTag())) {
                        reviewCommentsFiles.add(submissionProcessFile);
                    } else if (SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())) {
                        journalSubmissionFiles.add(submissionProcessFile);
                    } else if (SubmissionProcessFileTagEnum.SUPPLEMENTARY_DATA.getTag().equals(submissionProcessFile.getTag())) {
                        supplementaryDataFiles.add(submissionProcessFile);
                    }
                }
                submissionProcessVO.setReviewCommentsFiles(reviewCommentsFiles);
                submissionProcessVO.setJournalSubmissionFiles(journalSubmissionFiles);
                submissionProcessVO.setSupplementaryDataFiles(supplementaryDataFiles);
            }

            List<Review> latestReviews = reviewMapper.selectLatestReviewsByProcessId(processId);
            for (Review review : latestReviews) {
                if (ReviewTypeEnum.STUDENT.getValue().equals(review.getType())) {
                    com.ruoyi.experiment.pojo.vo.ReviewVO studentReviewVO = new com.ruoyi.experiment.pojo.vo.ReviewVO();
                    BeanUtils.copyProperties(review, studentReviewVO);
                    submissionProcessVO.setStudentReview(studentReviewVO);
                } else if (ReviewTypeEnum.TEACHER.getValue().equals(review.getType())) {
                    com.ruoyi.experiment.pojo.vo.ReviewVO teacherReviewVO = new com.ruoyi.experiment.pojo.vo.ReviewVO();
                    BeanUtils.copyProperties(review, teacherReviewVO);
                    submissionProcessVO.setTeacherReview(teacherReviewVO);
                }
            }
        }
        return submissionProcessVOs;
    }

    @Override
    public void createSubmissionProcess(SubmissionProcessDTO submissionProcessDTO) {
        log.info("投稿流程模块-创建投稿流程：{}", submissionProcessDTO);
        SubmissionPlanDetailVO submissionPlan = submissionPlanMapper.selectById(submissionProcessDTO.getPlanId());
        if (submissionPlan == null) {
            throw new RuntimeException("投稿计划不存在");
        }
        SubmissionProcess submissionProcess = new SubmissionProcess();
        BeanUtils.copyProperties(submissionProcessDTO, submissionProcess);
        submissionProcess.setStatus(SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue());
        submissionProcess.setProcessCreateTime(LocalDateTime.now());
        submissionProcessMapper.insert(submissionProcess);
    }

    @Override
    public void updateSubmissionProcess(SubmissionProcessDTO submissionProcessDTO) {
        log.info("投稿流程模块-更新投稿流程：{}", submissionProcessDTO);
        SubmissionProcess originProcess = submissionProcessMapper.selectByProcessId(submissionProcessDTO.getId());
        if (null == originProcess) {
            throw new ServiceException("投稿流程不存在");
        }
        if (null != originProcess.getPlanId() && !originProcess.getPlanId().equals(submissionProcessDTO.getPlanId())) {
            throw new ServiceException("投稿任务异常");
        }
        SubmissionProcess submissionProcess = new SubmissionProcess();
        BeanUtils.copyProperties(submissionProcessDTO, submissionProcess);
        submissionProcessMapper.update(submissionProcess);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSubmissionProcess(Long id) {
        log.info("投稿流程模块-删除投稿流程：{}", id);
        List<SubmissionProcessFile> submissionProcessFiles = submissionProcessFileMapper.selectByProcessId(id);

        submissionProcessFileMapper.deleteByProcessId(id);
        reviewMapper.deleteReviewByProcessId(id);
        submissionProcessMapper.deleteByProcessId(id);

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
    public void submitForReview(SubmitReviewDTO submitReviewDTO) {
        log.info("投稿流程模块-提交审核：{}", submitReviewDTO);
        Long processId = submitReviewDTO.getProcessId();
        Long studentReviewerUserId = submitReviewDTO.getStudentReviewerUserId();
        Long teacherReviewerUserId = submitReviewDTO.getTeacherReviewerUserId();
        String reviewedRemark = submitReviewDTO.getReviewedRemark();

        SubmissionProcess submissionProcess = submissionProcessMapper.selectByProcessId(processId);
        if (null == submissionProcess) {
            throw new RuntimeException("投稿流程不存在");
        }

        if (!Arrays.asList(
                SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue(),
                SubmissionProcessStatusEnum.REVIEW_FAILED.getValue()
        ).contains(submissionProcess.getStatus())) {
            throw new ServiceException("投稿流程状态异常，仅\"待发起内部审核\"和\"内部审核不通过\"状态下才能发起审核流程");
        }

        if (SubmissionProcessNameEnum.FIRST_REVIEW.getName().equals(submissionProcess.getName())) {
            SubmissionProcessFile journalSubmissionFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag());
            if (null == journalSubmissionFile) {
                throw new ServiceException("请上传提交给期刊的文件");
            }
            SubmissionProcessFile rawDataAndProgramFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.RAW_DATA_AND_PROGRAM.getTag());
            if (null == rawDataAndProgramFile) {
                throw new ServiceException("请上传原始数据与程序文件");
            }
        } else if (SubmissionProcessNameEnum.JOURNAL_EDITOR_REVIEW.getName().equals(submissionProcess.getName())) {
            SubmissionProcessFile finalDraftFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.FINAL_DRAFT.getTag());
            if (null == finalDraftFile) {
                throw new ServiceException("请上传最终稿");
            }
        } else {
            SubmissionProcessFile reviewOpinionFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.REVIEW_COMMENTS.getTag());
            if (null == reviewOpinionFile) {
                throw new ServiceException("请上传审稿意见");
            }
            SubmissionProcessFile journalSubmissionFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag());
            if (null == journalSubmissionFile) {
                throw new ServiceException("请上传提交给期刊的文件");
            }
            SubmissionProcessFile supplementaryDataFile = submissionProcessFileMapper.existByProcessIdAndTag(processId, SubmissionProcessFileTagEnum.SUPPLEMENTARY_DATA.getTag());
            if (null == supplementaryDataFile) {
                throw new ServiceException("请上传补充数据");
            }
        }

        com.ruoyi.project.system.domain.SysUser studentReviewerSysUser = userMapper.selectUserById(studentReviewerUserId);
        if (studentReviewerSysUser == null) {
            throw new ServiceException("学生审核人不存在");
        }
        UserForSelectVO studentReviewer = new UserForSelectVO(
            studentReviewerSysUser.getUserId(),
            studentReviewerSysUser.getUserName(),
            studentReviewerSysUser.getNickName()
        );

        com.ruoyi.project.system.domain.SysUser teacherReviewerSysUser = userMapper.selectUserById(teacherReviewerUserId);
        if (teacherReviewerSysUser == null) {
            throw new ServiceException("教师审核人不存在");
        }
        UserForSelectVO teacherReviewer = new UserForSelectVO(
            teacherReviewerSysUser.getUserId(),
            teacherReviewerSysUser.getUserName(),
            teacherReviewerSysUser.getNickName()
        );

        submissionProcessMapper.updateStatus(processId, SubmissionProcessStatusEnum.REVIEWING.getValue());

        Integer maxVersion = reviewMapper.selectMaxVersionByProcessId(processId);
        Integer newVersion = (maxVersion == null ? 0 : maxVersion) + 1;
        LocalDateTime now = LocalDateTime.now();

        Review studentReview = new Review();
        studentReview.setPlanId(submissionProcess.getPlanId());
        studentReview.setProcessId(processId);
        studentReview.setReviewedUserId(SecurityUtils.getUserId());
        studentReview.setReviewedUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        studentReview.setReviewerUserId(studentReviewerUserId);
        studentReview.setReviewerUserNickName(studentReviewer.getNickName());
        studentReview.setStatus(ReviewStatusEnum.PENDING.getValue());
        studentReview.setType(ReviewTypeEnum.STUDENT.getValue());
        studentReview.setVersion(newVersion);
        studentReview.setReviewedRemark(reviewedRemark);
        studentReview.setReviewCreateTime(now);
        reviewMapper.insert(studentReview);

        Review teacherReview = new Review();
        teacherReview.setPlanId(submissionProcess.getPlanId());
        teacherReview.setProcessId(processId);
        teacherReview.setReviewedUserId(SecurityUtils.getUserId());
        teacherReview.setReviewedUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        teacherReview.setReviewerUserId(teacherReviewerUserId);
        teacherReview.setReviewerUserNickName(teacherReviewer.getNickName());
        teacherReview.setStatus(ReviewStatusEnum.PENDING.getValue());
        teacherReview.setType(ReviewTypeEnum.TEACHER.getValue());
        teacherReview.setVersion(newVersion);
        teacherReview.setReviewedRemark(reviewedRemark);
        reviewMapper.insert(teacherReview);
    }

    @Override
    public SubmissionProcessDetailVO getSubmissionProcessDetail(Long id) {
        log.info("投稿流程模块-查询投稿流程详情：{}", id);
        SubmissionProcessDetailVO vo = submissionProcessMapper.selectDetailByProcessId(id);
        if (vo == null) {
            return null;
        }
        List<SubmissionProcessFileVO> submissionProcessFiles = submissionProcessFileMapper.selectVOListByProcessId(id);
        if (SubmissionProcessNameEnum.FIRST_REVIEW.getName().equals(vo.getName())) {
            List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
            List<SubmissionProcessFileVO> rawDataAndProgramFiles = new ArrayList<>();
            for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                if (SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())) {
                    journalSubmissionFiles.add(submissionProcessFile);
                } else if (SubmissionProcessFileTagEnum.RAW_DATA_AND_PROGRAM.getTag().equals(submissionProcessFile.getTag())) {
                    rawDataAndProgramFiles.add(submissionProcessFile);
                }
            }
            vo.setJournalSubmissionFiles(journalSubmissionFiles);
            vo.setRawDataAndProgramFiles(rawDataAndProgramFiles);
        } else if (SubmissionProcessNameEnum.JOURNAL_EDITOR_REVIEW.getName().equals(vo.getName())) {
            vo.setFinalDraftFiles(submissionProcessFiles);
        } else {
            List<SubmissionProcessFileVO> reviewCommentsFiles = new ArrayList<>();
            List<SubmissionProcessFileVO> journalSubmissionFiles = new ArrayList<>();
            List<SubmissionProcessFileVO> supplementaryDataFiles = new ArrayList<>();
            for (SubmissionProcessFileVO submissionProcessFile : submissionProcessFiles) {
                if (SubmissionProcessFileTagEnum.REVIEW_COMMENTS.getTag().equals(submissionProcessFile.getTag())) {
                    reviewCommentsFiles.add(submissionProcessFile);
                } else if (SubmissionProcessFileTagEnum.JOURNAL_SUBMISSION.getTag().equals(submissionProcessFile.getTag())) {
                    journalSubmissionFiles.add(submissionProcessFile);
                } else if (SubmissionProcessFileTagEnum.SUPPLEMENTARY_DATA.getTag().equals(submissionProcessFile.getTag())) {
                    supplementaryDataFiles.add(submissionProcessFile);
                }
            }
            vo.setReviewCommentsFiles(reviewCommentsFiles);
            vo.setJournalSubmissionFiles(journalSubmissionFiles);
            vo.setSupplementaryDataFiles(supplementaryDataFiles);
        }

        List<Review> latestReviews = reviewMapper.selectLatestReviewsByProcessId(id);
        for (Review review : latestReviews) {
            if (ReviewTypeEnum.STUDENT.getValue().equals(review.getType())) {
                com.ruoyi.experiment.pojo.vo.ReviewVO studentReviewVO = new com.ruoyi.experiment.pojo.vo.ReviewVO();
                BeanUtils.copyProperties(review, studentReviewVO);
                vo.setStudentReview(studentReviewVO);
            } else if (ReviewTypeEnum.TEACHER.getValue().equals(review.getType())) {
                com.ruoyi.experiment.pojo.vo.ReviewVO teacherReviewVO = new com.ruoyi.experiment.pojo.vo.ReviewVO();
                BeanUtils.copyProperties(review, teacherReviewVO);
                vo.setTeacherReview(teacherReviewVO);
            }
        }

        return vo;
    }

    @Override
    public List<UserForSelectVO> listReviewerUsersForSelect(Long planId, String nickName) {
        return submissionPlanMapper.selectUserVOForSelect(planId, nickName);
    }
}

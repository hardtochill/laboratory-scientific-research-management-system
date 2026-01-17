package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.bean.BeanUtils;
import com.ruoyi.experiment.constant.SubmissionConstants;
import com.ruoyi.experiment.enums.RoleEnums;
import com.ruoyi.experiment.enums.SubmissionPlanStatusEnum;
import com.ruoyi.experiment.enums.SubmissionProcessStatusEnum;
import com.ruoyi.experiment.enums.UserGraduateFlagEnum;
import com.ruoyi.experiment.mapper.SubmissionPlanMapper;
import com.ruoyi.experiment.mapper.SubmissionPlanUserMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessFileMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanDTO;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionPlanUser;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessDetailVO;
import com.ruoyi.experiment.pojo.vo.SubmissionProcessVO;
import com.ruoyi.experiment.service.SubmissionPlanService;
import com.ruoyi.experiment.utils.FileUtils;
import com.ruoyi.framework.config.ExperimentConfig;
import com.ruoyi.project.system.domain.dto.UserForSelectQueryDTO;
import com.ruoyi.project.system.domain.vo.UserForSelectVO;
import com.ruoyi.project.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

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
public class SubmissionPlanServiceImpl implements SubmissionPlanService {
    private final SubmissionPlanMapper submissionPlanMapper;
    private final SubmissionProcessMapper submissionProcessMapper;
    private final SubmissionProcessFileMapper submissionProcessFileMapper;
    private final SubmissionPlanUserMapper submissionPlanUserMapper;
    private final SysUserMapper userMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<SubmissionPlan> listSubmissionPlans(SubmissionPlanQueryDTO submissionPlanQueryDTO) {
        log.info("投稿计划模块-查询投稿计划列表：{}",submissionPlanQueryDTO);
        submissionPlanQueryDTO.setParticipantUserId(SecurityUtils.getUserId());
        return submissionPlanMapper.selectSubmissionPlanList(submissionPlanQueryDTO);
    }

    @Override
    public SubmissionPlanDetailVO getSubmissionPlanById(Long id) {
        log.info("投稿计划模块-查询投稿计划详情：{}",id);
        SubmissionPlanDetailVO submissionPlanDetailVO = submissionPlanMapper.selectById(id);
        submissionPlanDetailVO.setParticipantUsers(submissionPlanUserMapper.selectUsersByPlanId(id));
        return submissionPlanDetailVO;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {
        log.info("投稿计划模块-创建投稿计划：{}",submissionPlanDTO);
        SubmissionPlan submissionPlan = new SubmissionPlan();
        BeanUtils.copyProperties(submissionPlanDTO, submissionPlan);

        // 1.设置用户信息
        submissionPlan.setCreateUserId(SecurityUtils.getUserId());
        submissionPlan.setCreateUserNickName(SecurityUtils.getLoginUser().getUser().getNickName());
        // 2.设置投稿状态
        submissionPlan.setStatus(SubmissionPlanStatusEnum.WAITING_REVIEW.getValue());
        // 3.设置投稿创建时间
        submissionPlan.setSubmissionCreateTime(LocalDateTime.now());
        // 4.保存投稿计划
        submissionPlanMapper.insert(submissionPlan);

        // 5.保存参与用户
        List<Long> participantUserIds = submissionPlanDTO.getParticipantUserIds();
        if(CollectionUtils.isEmpty(participantUserIds)){
            participantUserIds = new ArrayList<>();
        }
        if(!participantUserIds.contains(SecurityUtils.getUserId())){
            participantUserIds.add(SecurityUtils.getUserId());
        }
        submissionPlanUserMapper.insertBatch(submissionPlan.getId(),participantUserIds);

        // 6.自动创建第一个投稿流程（一审）
        SubmissionProcess submissionProcess = new SubmissionProcess();
        submissionProcess.setPlanId(submissionPlan.getId());
        submissionProcess.setName(SubmissionConstants.FIRST_PROCESS_NAME);
        submissionProcess.setStatus(SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue());
        submissionProcess.setProcessCreateTime(LocalDateTime.now());
        // 7.保存投稿流程
        submissionProcessMapper.insert(submissionProcess);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {
        log.info("投稿计划模块-更新投稿计划：{}",submissionPlanDTO);
        // 1.更改投稿计划
        SubmissionPlan submissionPlan = new SubmissionPlan();
        BeanUtils.copyProperties(submissionPlanDTO, submissionPlan);
        submissionPlanMapper.update(submissionPlan);
        // 2.更改投稿计划参与用户
        submissionPlanUserMapper.deleteByPlanId(submissionPlan.getId());
        List<Long> participantUserIds = submissionPlanDTO.getParticipantUserIds();
        if(CollectionUtils.isEmpty(participantUserIds)){
            participantUserIds = new ArrayList<>();
        }
        if(!participantUserIds.contains(SecurityUtils.getUserId())){
            participantUserIds.add(SecurityUtils.getUserId());
        }
        submissionPlanUserMapper.insertBatch(submissionPlan.getId(),participantUserIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSubmissionPlan(Long id) {
        log.info("投稿计划模块-删除投稿计划：{}",id);
        // 1.查出所有关联投稿流程
        List<SubmissionProcessVO> submissionProcessList = submissionProcessMapper.selectByPlanId(id);
        if(CollectionUtils.isEmpty(submissionProcessList)){
            submissionPlanMapper.deleteById(id);
            submissionPlanUserMapper.deleteByPlanId(id);
            return;
        }
        // 2.查出所有关联文件
        List<SubmissionProcessFile> submissionProcessFileList = submissionProcessFileMapper.selectByProcessIds(submissionProcessList.stream().map(SubmissionProcessVO::getId).collect(Collectors.toList()));
        // 3.删除投稿计划
        submissionPlanMapper.deleteById(id);
        // 4.删除所有关联投稿流程
        submissionProcessMapper.deleteByPlanId(id);
        // 5.删除所有关联投稿计划参与用户
        submissionPlanUserMapper.deleteByPlanId(id);
        // 6.删除所有关联文件
        if(CollectionUtils.isEmpty(submissionProcessFileList)){
            return;
        }
        submissionProcessFileMapper.deleteByIds(submissionProcessFileList.stream().map(SubmissionProcessFile::getId).collect(Collectors.toList()));
        for (SubmissionProcessFile submissionProcessFile : submissionProcessFileList) {
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
    public List<SubmissionPlanVO> listSubmissionPlansForSelect(String name) {
        return submissionPlanMapper.selectVOList(name,SecurityUtils.getUserId());
    }

    @Override
    public List<UserForSelectVO> listCreateUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        return userMapper.selectVOForSelect(queryDTO);
    }
}
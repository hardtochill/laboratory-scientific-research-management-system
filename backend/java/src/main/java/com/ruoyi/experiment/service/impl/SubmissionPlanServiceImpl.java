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
import com.ruoyi.experiment.mapper.SubmissionProcessFileMapper;
import com.ruoyi.experiment.mapper.SubmissionProcessMapper;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanDTO;
import com.ruoyi.experiment.pojo.dto.SubmissionPlanQueryDTO;
import com.ruoyi.experiment.pojo.entity.SubmissionPlan;
import com.ruoyi.experiment.pojo.entity.SubmissionProcess;
import com.ruoyi.experiment.pojo.entity.SubmissionProcessFile;
import com.ruoyi.experiment.pojo.vo.SubmissionPlanVO;
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

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class SubmissionPlanServiceImpl implements SubmissionPlanService {
    private final SubmissionPlanMapper submissionPlanMapper;
    private final SubmissionProcessMapper submissionProcessMapper;
    private final SubmissionProcessFileMapper submissionProcessFileMapper;
    private final SysUserMapper userMapper;
    private final ExperimentConfig experimentConfig;

    @Override
    public List<SubmissionPlan> listSubmissionPlans(SubmissionPlanQueryDTO submissionPlanQueryDTO) {
        return submissionPlanMapper.selectSubmissionPlanList(submissionPlanQueryDTO);
    }

    @Override
    public SubmissionPlan getSubmissionPlanById(Long id) {
        return submissionPlanMapper.selectById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {

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

        // 5.自动创建第一个投稿流程（一审）
        SubmissionProcess submissionProcess = new SubmissionProcess();
        submissionProcess.setPlanId(submissionPlan.getId());
        submissionProcess.setName(SubmissionConstants.FIRST_PROCESS_NAME);
        submissionProcess.setStatus(SubmissionProcessStatusEnum.WAITING_SUBMIT_REVIEW.getValue());
        submissionProcess.setProcessCreateTime(LocalDateTime.now());
        // 6.保存投稿流程
        submissionProcessMapper.insert(submissionProcess);
    }

    @Override
    public void updateSubmissionPlan(SubmissionPlanDTO submissionPlanDTO) {
        SubmissionPlan submissionPlan = new SubmissionPlan();
        BeanUtils.copyProperties(submissionPlanDTO, submissionPlan);
        submissionPlanMapper.update(submissionPlan);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSubmissionPlan(Long id) {
        // 1.查出所有关联投稿流程
        List<SubmissionProcessVO> submissionProcessList = submissionProcessMapper.selectByPlanId(id);
        // 2.查出所有关联文件
        List<SubmissionProcessFile> submissionProcessFileList = submissionProcessFileMapper.selectByProcessIds(submissionProcessList.stream().map(SubmissionProcessVO::getId).collect(Collectors.toList()));
        // 3.删除投稿计划
        submissionPlanMapper.deleteById(id);
        // 4.删除所有关联投稿流程
        submissionProcessMapper.deleteByPlanId(id);
        // 5.删除所有关联文件
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
        return submissionPlanMapper.selectVOList(name);
    }

    @Override
    public List<UserForSelectVO> listCreateUsersForSelect(String nickName) {
        UserForSelectQueryDTO queryDTO = new UserForSelectQueryDTO();
        queryDTO.setNickName(nickName);
        return userMapper.selectVOForSelect(queryDTO);
    }
}
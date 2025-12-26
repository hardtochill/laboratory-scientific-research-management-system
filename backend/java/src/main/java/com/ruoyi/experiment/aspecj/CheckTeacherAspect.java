package com.ruoyi.experiment.aspecj;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.experiment.enums.RoleEnums;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

/**
 * 教师角色校验切面
 */
@Component
@Aspect
public class CheckTeacherAspect {

    @Pointcut("execution(* com.ruoyi.experiment.controller..*.*(..)) && @annotation(com.ruoyi.experiment.annotations.CheckTeacher)")
    public void pointcut() {}

    @Before("pointcut()")
    public void intercept() {
        // 校验教师角色逻辑
        boolean isTeacher = SecurityUtils.hasRole(RoleEnums.TEACHER.getRoleKey());
        if (!isTeacher) {
            throw new IllegalArgumentException("非教师角色，无权限操作");
        }
    }
}

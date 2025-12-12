package com.ruoyi.experiment.aspecj;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.exception.base.BaseException;
import com.ruoyi.experiment.annotations.AutoFill;
import com.ruoyi.experiment.constant.AutoFillConstants;
import com.ruoyi.experiment.enums.OperationTypeEnum;
import org.apache.commons.lang3.ArrayUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.util.List;

@Aspect
@Component
public class AutoFillAspect {
    @Pointcut("execution(* com.ruoyi.experiment.mapper.*.*(..)) && @annotation(com.ruoyi.experiment.annotations.AutoFill)")
    public void pointcut(){}

    /**
     * 填充公共字段
     * @param joinPoint
     */
    @Before("pointcut()")
    public void autoFill(JoinPoint joinPoint){
        try{
            // 读取方法前面，获取其上注解
            MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
            AutoFill autoFillAnnotation = methodSignature.getMethod().getAnnotation(AutoFill.class);
            // 操作类型
            OperationTypeEnum operationTypeEnum = autoFillAnnotation.value();
            // 获取方法形参表
            Object[] args = joinPoint.getArgs();
            if (ArrayUtils.isEmpty(args)){
                return;
            }
            // 约定要填充字段的对象位于形参表首尾
            Object object = args[0];
            LocalDateTime now = LocalDateTime.now();
            // 插入
            if (OperationTypeEnum.INSERT==operationTypeEnum){
                // 批量插入
                if (object instanceof List<?>){
                    List<?> objectList = (List<?>) object;
                    for (Object o : objectList) {
                        Method setCreateTime = o.getClass().getMethod(AutoFillConstants.SET_CREATE_TIME, LocalDateTime.class);
                        Method setUpdateTime = o.getClass().getMethod(AutoFillConstants.SET_UPDATE_TIME, LocalDateTime.class);
                        setCreateTime.invoke(o,now);
                        setUpdateTime.invoke(o,now);
                    }
                }else{ // 单个插入
                    Method setCreateTime = object.getClass().getMethod(AutoFillConstants.SET_CREATE_TIME, LocalDateTime.class);
                    Method setUpdateTime = object.getClass().getMethod(AutoFillConstants.SET_UPDATE_TIME, LocalDateTime.class);
                    setCreateTime.invoke(object,now);
                    setUpdateTime.invoke(object,now);
                }
            } else if (OperationTypeEnum.UPDATE==operationTypeEnum) { // 修改
                if (object instanceof List<?>){ // 批量修改
                    List<?> objectList = (List<?>) object;
                    for (Object o : objectList) {
                        Method setUpdateTime = o.getClass().getMethod(AutoFillConstants.SET_UPDATE_TIME, LocalDateTime.class);
                        setUpdateTime.invoke(o,now);
                    }
                }else{ // 单个修改
                    Method setUpdateTime = object.getClass().getMethod(AutoFillConstants.SET_UPDATE_TIME,LocalDateTime.class);
                    setUpdateTime.invoke(object,now);
                }
            }
        }catch (Exception e){
            throw new ServiceException("数据库操作公共字段填充异常");
        }
    }
}

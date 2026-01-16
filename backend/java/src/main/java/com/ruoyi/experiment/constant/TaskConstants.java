package com.ruoyi.experiment.constant;

public class TaskConstants {
    /**
     * 一级父任务ID
     */
    public static final Long FIRST_PARENT_TASK_ID = 0L;
    /**
     * 任务最大深度（一级父任务深度为1）
     */
    public static final Integer MAX_TASK_DEPTH = 5;
    /**
     * 任务最大广度（从1开始）
     */
    public static final Integer MAX_TASK_ORDER = 10;
    /**
     * 子任务排序字段
     */
    public static final String SUB_TASK_ORDER_BY = "task_order";
     /**
      * 子任务排序方向
      */
     public static final String SUB_TASK_ORDER_DIRECTION = "asc";
}

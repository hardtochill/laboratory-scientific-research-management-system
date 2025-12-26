package com.ruoyi.experiment.enums;

public enum RoleEnums {
    /** 教师角色 */
    TEACHER("teacher"),
    /** 学生角色 */
    STUDENT("student");;
    private final String roleKey;
    RoleEnums(String roleKey) {
        this.roleKey = roleKey;
    }
    public String getRoleKey() {
        return roleKey;
    }
}

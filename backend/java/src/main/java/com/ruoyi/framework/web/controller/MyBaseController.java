package com.ruoyi.framework.web.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ruoyi.common.constant.HttpStatus;
import com.ruoyi.framework.web.page.PageDomain;
import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.framework.web.page.TableSupport;
import org.apache.commons.lang3.StringUtils;

/**
 * mybatisPlus的增强
 *
 * @author liqiao
 */
public class MyBaseController extends BaseController {
    /*
     * @Description: 根据请求信息组成分页对象
     * @author: LiQiao
     */
    protected <T> Page<T> assemblePage() {
        Page<T> page = new Page<>();
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Integer pageNum = pageDomain.getPageNum();
        Integer pageSize = pageDomain.getPageSize();
        page.setCurrent(pageNum);
        page.setSize(pageSize);
        if (StringUtils.isNotBlank(pageDomain.getOrderBy())) {
            if ("asc".equals(pageDomain.getIsAsc())) {
                page.addOrder(OrderItem.asc(pageDomain.getOrderBy()));
            } else {
                page.addOrder(OrderItem.desc(pageDomain.getOrderBy()));
            }
        }
        return page;
    }

    /*
     * @Description: 将mp分页数据对象对象转化成若依使用的分页数据对象
     * @author LiQiao
     * @param ipage: MybatisPlus分页数据对象
     * @return 若依分页数据对象
     */
    protected TableDataInfo getDataTableByIPage(IPage<?> ipage) {
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setRows(ipage.getRecords());
        rspData.setMsg("查询成功");
        rspData.setTotal(ipage.getTotal());
        return rspData;
    }
}

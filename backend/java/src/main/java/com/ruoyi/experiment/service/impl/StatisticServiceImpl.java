package com.ruoyi.experiment.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.experiment.mapper.StatisticMapper;
import com.ruoyi.experiment.pojo.dto.StatisticQueryDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureReadStatisticsVO;
import com.ruoyi.experiment.pojo.vo.StudentReadStatisticsVO;
import com.ruoyi.experiment.service.StatisticService;
import com.ruoyi.framework.web.page.TableDataInfo;
import com.ruoyi.framework.web.page.TableSupport;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StatisticServiceImpl implements StatisticService {
    private final StatisticMapper statisticMapper;

    @Override
    public List<StudentReadStatisticsVO> selectStudentReadingStatistics(StatisticQueryDTO queryDTO) {
        return statisticMapper.selectStudentReadingStatistics(queryDTO);
    }

    @Override
    public List<StudentReadStatisticsVO.LiteratureReadDetail> selectStudentLiteratureDetail(Long studentId, LocalDateTime startTime, LocalDateTime endTime) {
        return statisticMapper.selectStudentLiteratureDetail(studentId, startTime, endTime);
    }

    @Override
    public List<LiteratureReadStatisticsVO> selectLiteratureReadingStatistics(StatisticQueryDTO queryDTO) {
        return statisticMapper.selectLiteratureReadingStatistics(queryDTO);
    }

    @Override
    public List<LiteratureReadStatisticsVO.StudentReadDetail> selectLiteratureStudentDetail(Long literatureId, LocalDateTime startTime, LocalDateTime endTime) {
        return statisticMapper.selectLiteratureStudentDetail(literatureId, startTime, endTime);
    }

    @Override
    public void exportStatistics(StatisticQueryDTO queryDTO, HttpServletResponse response) {
        try {
            List<StudentReadStatisticsVO> studentList = statisticMapper.selectStudentStatisticsForExport(queryDTO);
            List<LiteratureReadStatisticsVO> literatureList = statisticMapper.selectLiteratureStatisticsForExport(queryDTO);

            String fileName = "文献阅读统计_" +
                    queryDTO.getStartTime().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" +
                    queryDTO.getEndTime().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "_" +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".xlsx";

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, StandardCharsets.UTF_8.name()));

            Workbook workbook = new XSSFWorkbook();
            Sheet studentSheet = workbook.createSheet("按学生统计");
            Sheet literatureSheet = workbook.createSheet("按文献统计");

            createStudentSheetHeader(studentSheet);
            createLiteratureSheetHeader(literatureSheet);

            int studentRowNum = 1;
            for (StudentReadStatisticsVO student : studentList) {
                Row row = studentSheet.createRow(studentRowNum++);
                row.createCell(0).setCellValue(student.getUserNickName());
                row.createCell(1).setCellValue(student.getLiteratureCount());

                List<StudentReadStatisticsVO.LiteratureReadDetail> details = statisticMapper.selectStudentLiteratureDetail(
                        student.getUserId(), queryDTO.getStartTime(), queryDTO.getEndTime());

                StringBuilder literatureInfo = new StringBuilder();
                for (StudentReadStatisticsVO.LiteratureReadDetail detail : details) {
                    if (literatureInfo.length() > 0) {
                        literatureInfo.append("\n");
                    }
                    literatureInfo.append("文献: ").append(detail.getTitle())
                            .append("\n  关键词: ").append(StringUtils.isEmpty(detail.getKeywords()) ? "无" : detail.getKeywords())
                            .append("\n  阅读次数: ").append(detail.getReadCount())
                            .append("\n  最后阅读时间: ").append(detail.getLastReadTime() != null ?
                                    detail.getLastReadTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "");
                }
                row.createCell(2).setCellValue(literatureInfo.toString());
            }

            int literatureRowNum = 1;
            for (LiteratureReadStatisticsVO literature : literatureList) {
                Row row = literatureSheet.createRow(literatureRowNum++);
                row.createCell(0).setCellValue(literature.getTitle());
                row.createCell(1).setCellValue(literature.getKeywords());
                row.createCell(2).setCellValue(literature.getStudentCount());

                List<LiteratureReadStatisticsVO.StudentReadDetail> details = statisticMapper.selectLiteratureStudentDetail(
                        literature.getLiteratureId(), queryDTO.getStartTime(), queryDTO.getEndTime());

                StringBuilder studentInfo = new StringBuilder();
                for (LiteratureReadStatisticsVO.StudentReadDetail detail : details) {
                    if (studentInfo.length() > 0) {
                        studentInfo.append("\n");
                    }
                    studentInfo.append("学生: ").append(detail.getUserNickName())
                            .append("\n  阅读次数: ").append(detail.getReadCount())
                            .append("\n  最后阅读时间: ").append(detail.getLastReadTime() != null ?
                                    detail.getLastReadTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "");
                }
                row.createCell(3).setCellValue(studentInfo.toString());
            }

            for (int i = 0; i < 3; i++) {
                studentSheet.autoSizeColumn(i);
            }
            for (int i = 0; i < 4; i++) {
                literatureSheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            throw new ServiceException("导出统计失败: " + e.getMessage());
        }
    }

    private void createStudentSheetHeader(Sheet sheet) {
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = sheet.getWorkbook().createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        Cell cell0 = headerRow.createCell(0);
        cell0.setCellValue("学生昵称");
        cell0.setCellStyle(headerStyle);

        Cell cell1 = headerRow.createCell(1);
        cell1.setCellValue("阅读文献数量");
        cell1.setCellStyle(headerStyle);

        Cell cell2 = headerRow.createCell(2);
        cell2.setCellValue("阅读文献详情");
        cell2.setCellStyle(headerStyle);
    }

    private void createLiteratureSheetHeader(Sheet sheet) {
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = sheet.getWorkbook().createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        Cell cell0 = headerRow.createCell(0);
        cell0.setCellValue("文献名称");
        cell0.setCellStyle(headerStyle);

        Cell cell1 = headerRow.createCell(1);
        cell1.setCellValue("关键词");
        cell1.setCellStyle(headerStyle);

        Cell cell2 = headerRow.createCell(2);
        cell2.setCellValue("阅读学生数量");
        cell2.setCellStyle(headerStyle);

        Cell cell3 = headerRow.createCell(3);
        cell3.setCellValue("阅读学生详情");
        cell3.setCellStyle(headerStyle);
    }
}

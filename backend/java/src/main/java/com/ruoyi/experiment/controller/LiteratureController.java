package com.ruoyi.experiment.controller;


import com.ruoyi.experiment.pojo.dto.LiteratureDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureQueryDTO;
import com.ruoyi.experiment.pojo.dto.LiteratureScoreDTO;
import com.ruoyi.experiment.pojo.vo.LiteratureVO;
import com.ruoyi.experiment.service.LiteratureService;
import com.ruoyi.framework.web.controller.BaseController;
import com.ruoyi.framework.web.domain.AjaxResult;
import com.ruoyi.framework.web.page.TableDataInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 文献管理Controller
 *
 * @author ruoyi
 * @date 2023-10-15
 */
@RestController
@RequestMapping("/literature")
public class LiteratureController extends BaseController {
    @Autowired
    private LiteratureService literatureService;
    
    /**
     * 查询文献列表
     */
    @GetMapping("/list")
    public TableDataInfo list(LiteratureQueryDTO literatureQueryDTO) {
        startPage();
        List<LiteratureVO> list = literatureService.selectLiteratureList(literatureQueryDTO);
        return getDataTable(list);
    }

    /**
     * 获取文献详情
     */
    @GetMapping("/detail/{id}")
    public AjaxResult detail(@PathVariable("id") Long id) {
        return AjaxResult.success(literatureService.selectLiteratureDetail(id));
    }

    /**
     * 下载文献
     */
    @PostMapping("/download/{id}")
    public void download(@PathVariable("id") Long id, HttpServletResponse response){
        literatureService.downloadLiterature(id,response);
    }

    /**
     * 评分文献
     */
    @PostMapping("/score")
    public AjaxResult score(@RequestBody LiteratureScoreDTO literatureScoreDTO) {
        literatureService.scoreLiterature(literatureScoreDTO);
        return AjaxResult.success("评分成功");
    }
    /**
     * 添加文献
     */
    @PostMapping("/add")
    public AjaxResult add(
            @RequestParam("title") String title,
            @RequestParam(value = "authors", required = false) String authors,
            @RequestParam(value = "journal", required = false) String journal,
            @RequestParam(value = "publishTime", required = false) LocalDate publishTime,
            @RequestParam(value = "abstract", required = false) String abstractText,
            @RequestParam(value = "keywordIds", required = false) List<Long> keywordIds,
            @RequestParam("file") MultipartFile file) {

        LiteratureDTO literatureDTO = new LiteratureDTO();
        literatureDTO.setTitle(title);
        literatureDTO.setAuthors(authors);
        literatureDTO.setJournal(journal);
        literatureDTO.setPublishTime(publishTime);
        literatureDTO.setAbstractText(abstractText);
        literatureDTO.setKeywordIds(keywordIds);
        literatureDTO.setFile(file);

        literatureService.addLiterature(literatureDTO);
        return AjaxResult.success("添加成功");
    }
    /**
     * 修改文献
     */
    @PostMapping("/update")
    public AjaxResult update(@RequestBody LiteratureDTO literatureDTO) {
        literatureService.updateLiterature(literatureDTO);
        return AjaxResult.success("修改成功");
    }
}
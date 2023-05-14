package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.LichPhongVan;
import com.haivn.common_api.LopHoc;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.LichPhongVanDto;
import com.haivn.mapper.LichPhongVanMapper;
import com.haivn.service.LichPhongVanService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/lich-phong-van")
@RestController
@Slf4j
@Api("lich-phong-van")
public class LichPhongVanController {
    private final LichPhongVanService lichPhongVanService;

    public LichPhongVanController(LichPhongVanService lichPhongVanService) {
        this.lichPhongVanService = lichPhongVanService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated LichPhongVanDto lichPhongVanDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(lichPhongVanDto.getTitle())){
            result.put("result", "Thiếu tiêu đề");
            result.put("success", false);
        } else if (lichPhongVanDto.getStatus()==null || lichPhongVanDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getDiaDiem())){
            result.put("result", "Thiếu địa điểm");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getThanhPhanThamDu())){
            result.put("result", "Thiếu thành phần tham dự");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getSinhVienPv())){
            result.put("result", "Thiếu sinh viên phỏng vấn");
            result.put("success", false);
        }else if (lichPhongVanDto.getThoiGian()==null){
            result.put("result", "Thiếu thời gian pv");
            result.put("success", false);
        }else {
            try{
                LichPhongVanDto item = lichPhongVanService.save(lichPhongVanDto);
                result.put("result", item.getId());
                result.put("success",true);
            }
            catch (Exception e){
                result.put("result",e.getMessage());
                result.put("success",false);
            }
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            LichPhongVanDto lichPhongVan = lichPhongVanService.findById(id);
            result.put("result",lichPhongVan);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);

    }
    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(lichPhongVanService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        lichPhongVanService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<LichPhongVan> spec, @PageableDefault(sort = "id", direction = Sort.Direction.DESC) Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<LichPhongVanDto> lichPhongVanPage = lichPhongVanService.findByCondition(spec, pageable);
            result.put("result",lichPhongVanPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated LichPhongVanDto lichPhongVanDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(lichPhongVanDto.getTitle())){
            result.put("result", "Thiếu tiêu đề");
            result.put("success", false);
        } else if (lichPhongVanDto.getStatus()==null || lichPhongVanDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getDiaDiem())){
            result.put("result", "Thiếu địa điểm");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getThanhPhanThamDu())){
            result.put("result", "Thiếu thành phần tham dự");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(lichPhongVanDto.getSinhVienPv())){
            result.put("result", "Thiếu sinh viên phỏng vấn");
            result.put("success", false);
        }else if (lichPhongVanDto.getThoiGian()==null){
            result.put("result", "Thiếu thời gian pv");
            result.put("success", false);
        }else {
            try{
                lichPhongVanDto.setId(id);
                LichPhongVanDto item = lichPhongVanService.update(lichPhongVanDto, id);
                result.put("result", item.getId());
                result.put("success",true);
            }
            catch (Exception e){
                result.put("result",e.getMessage());
                result.put("success",false);
            }
        }
        return ResponseEntity.ok(result);
    }
}
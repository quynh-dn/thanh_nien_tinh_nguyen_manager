package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.ChucVu;
import com.haivn.common_api.LopHoc;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.LopHocDto;
import com.haivn.mapper.LopHocMapper;
import com.haivn.service.LopHocService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import io.swagger.v3.oas.annotations.Operation;
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

@RequestMapping("/api/lop-hoc")
@RestController
@Slf4j
@Api("lop-hoc")
public class LopHocController {
    private final LopHocService lopHocService;

    public LopHocController(LopHocService lopHocService) {
        this.lopHocService = lopHocService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated LopHocDto lopHocDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(lopHocDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (lopHocDto.getStatus()==null || lopHocDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else {
            try{
                LopHocDto item = lopHocService.save(lopHocDto);
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
            LopHocDto lopHoc = lopHocService.findById(id);
            result.put("result",lopHoc);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @DeleteMapping("/del/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable("id") Long id) {
        Boolean result= false;
        try {
            Optional.ofNullable(lopHocService.findById(id)).orElseThrow(() -> {
                log.error("Unable to delete non-existent data！");
                return new FileSystemNotFoundException();
            });
            lopHocService.deleteById(id);
            result=true;
        }catch (Exception e){
            result= false;
        }
        return ResponseEntity.ok(result);
    }
    @Operation(summary = "Lấy theo các tiêu chí")
    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<LopHoc> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<LopHocDto> lopHocPage = lopHocService.findByCondition(spec, pageable);
            result.put("result", lopHocPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity< Map<String, Object>> update(@RequestBody @Validated LopHocDto lopHocDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(lopHocDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (lopHocDto.getStatus()==null || lopHocDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }{
            try{
                lopHocDto.setId(id);
                LopHocDto item = lopHocService.update(lopHocDto, id);
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
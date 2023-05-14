package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.ChucVu;
import com.haivn.common_api.TnvPtsk;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.TnvPtskDto;
import com.haivn.mapper.TnvPtskMapper;
import com.haivn.service.TnvPtskService;
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

@RequestMapping("/api/tnv-ptsk")
@RestController
@Slf4j
@Api("tnv-ptsk")
public class TnvPtskController {
    private final TnvPtskService tnvPtskService;

    public TnvPtskController(TnvPtskService tnvPtskService) {
        this.tnvPtskService = tnvPtskService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated TnvPtskDto tnvPtskDto) {
        Map<String, Object> result = new HashMap<>();
        if(tnvPtskDto.getIdTnv()==null || tnvPtskDto.getIdTnv()<=0){
            result.put("result", "Thiếu id tinh nguyen vien");
            result.put("success", false);
        } else if (tnvPtskDto.getStatus()==null || tnvPtskDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (tnvPtskDto.getIdPtsk()==null || tnvPtskDto.getIdPtsk()<=0){
            result.put("result", "Thieu id phong trao su kien");
            result.put("success", false);
        }else{
            try{
                TnvPtskDto item = tnvPtskService.save(tnvPtskDto);
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
            TnvPtskDto tnvPtsk = tnvPtskService.findById(id);
            result.put("result",tnvPtsk);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(tnvPtskService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        tnvPtskService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<TnvPtsk> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<TnvPtskDto> tnvPtskPage = tnvPtskService.findByCondition(spec, pageable);
            result.put("result", tnvPtskPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated TnvPtskDto tnvPtskDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(tnvPtskDto.getIdTnv()==null || tnvPtskDto.getIdTnv()<=0){
            result.put("result", "Thiếu id tinh nguyen vien");
            result.put("success", false);
        } else if (tnvPtskDto.getStatus()==null || tnvPtskDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (tnvPtskDto.getIdPtsk()==null || tnvPtskDto.getIdPtsk()<=0){
            result.put("result", "Thieu id phong trao su kien");
            result.put("success", false);
        }else{
            try{
                tnvPtskDto.setId(id);
                TnvPtskDto item =  tnvPtskService.update(tnvPtskDto, id);
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
    @GetMapping("/approve/{id}")
    public ResponseEntity<Map<String, Object>> appproveItem(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Short statusApprove=1;
            TnvPtskDto tnvPtsk = tnvPtskService.findById(id);
            tnvPtsk.setStatus(statusApprove);
            tnvPtskService.update(tnvPtsk,id);
            result.put("result",true);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}


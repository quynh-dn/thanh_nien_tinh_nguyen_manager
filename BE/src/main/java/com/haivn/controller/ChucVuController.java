package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.ChucVu;
import com.haivn.dto.ChucVuDto;
import com.haivn.service.ChucVuService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RequestMapping("/api/chuc-vu")
@RestController
@Slf4j
@Api("chuc-vu")
public class ChucVuController {
    private final ChucVuService chucVuService;

    public ChucVuController(ChucVuService chucVuService) {
        this.chucVuService = chucVuService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated ChucVuDto chucVuDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(chucVuDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (chucVuDto.getStatus()==null || chucVuDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else{
            try{
                ChucVuDto item = chucVuService.save(chucVuDto);
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
            ChucVuDto chucVu = chucVuService.findById(id);
            result.put("result",chucVu);
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
           Optional.ofNullable(chucVuService.findById(id)).orElseThrow(() -> {
               log.error("Unable to delete non-existent data！");
               return new FileSystemNotFoundException();
           });
           chucVuService.deleteById(id);
           result= true;
       }catch (Exception e){
           result= false;
       }
        return ResponseEntity.ok(result);
    }
    @Operation(summary = "Lấy theo các tiêu chí")
    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<ChucVu> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<ChucVuDto> chucVuPage = chucVuService.findByCondition(spec, pageable);
            result.put("result", chucVuPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated ChucVuDto chucVuDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(chucVuDto.getName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (chucVuDto.getStatus()==null || chucVuDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }{
            try{
                chucVuDto.setId(id);
                ChucVuDto item = chucVuService.update(chucVuDto, id);
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
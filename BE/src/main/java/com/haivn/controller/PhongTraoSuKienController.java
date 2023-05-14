package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.PhongTraoSuKien;
import com.haivn.common_api.TnvPtsk;
import com.haivn.dto.PhongTraoSuKienDto;
import com.haivn.dto.TnvPtskDto;
import com.haivn.service.PhongTraoSuKienService;
import com.haivn.service.TnvPtskService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
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
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RequestMapping("/api/phong-trao-su-kien")
@RestController
@Slf4j
@Api("phong-trao-su-kien")
public class PhongTraoSuKienController {

    private final PhongTraoSuKienService phongTraoSuKienService;
    private final TnvPtskService tnvPtskService;

    public PhongTraoSuKienController(PhongTraoSuKienService phongTraoSuKienService,TnvPtskService tnvPtskService) {
        this.phongTraoSuKienService = phongTraoSuKienService;
        this.tnvPtskService =tnvPtskService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated PhongTraoSuKienDto phongTraoSuKienDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(phongTraoSuKienDto.getTitle())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (phongTraoSuKienDto.getStatus()==null || phongTraoSuKienDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getSoLuongHoTro()==null || phongTraoSuKienDto.getSoLuongHoTro()<0){
            result.put("result", "Thieu so nguoi ho tro");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getDiaDiem())){
            result.put("result", "Thieu dia diem");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getKinhPhi())){
            result.put("result", "Thieu kinh phi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getNguoiPhuTrach())){
            result.put("result", "Thieu nguoi phu trach");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getStartDate()==null){
            result.put("result", "Thieu ngay bat dau");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getEndDate()==null){
            result.put("result", "Thieu ngay ket thuc");
            result.put("success", false);
        }else {
            try{
                PhongTraoSuKienDto item = phongTraoSuKienService.save(phongTraoSuKienDto);
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
            PhongTraoSuKienDto phongTraoSuKien = phongTraoSuKienService.findById(id);
            result.put("result",phongTraoSuKien);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);

    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(phongTraoSuKienService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        phongTraoSuKienService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<PhongTraoSuKien> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<PhongTraoSuKienDto> phongTraoSuKienPage = phongTraoSuKienService.findByCondition(spec, pageable);
            result.put("result",phongTraoSuKienPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated PhongTraoSuKienDto phongTraoSuKienDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(phongTraoSuKienDto.getTitle())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (phongTraoSuKienDto.getStatus()==null || phongTraoSuKienDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getSoLuongHoTro()==null || phongTraoSuKienDto.getSoLuongHoTro()<0){
            result.put("result", "Thieu so nguoi ho tro");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getDiaDiem())){
            result.put("result", "Thieu dia diem");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getKinhPhi())){
            result.put("result", "Thieu kinh phi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(phongTraoSuKienDto.getNguoiPhuTrach())){
            result.put("result", "Thieu nguoi phu trach");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getStartDate()==null){
            result.put("result", "Thieu ngay bat dau");
            result.put("success", false);
        }else if (phongTraoSuKienDto.getEndDate()==null){
            result.put("result", "Thieu ngay ket thuc");
            result.put("success", false);
        }else {
            try{
                phongTraoSuKienDto.setId(id);
                PhongTraoSuKienDto item =  phongTraoSuKienService.update(phongTraoSuKienDto, id);
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

    @GetMapping("/get/soluongtnv/{id}")
    public ResponseEntity<Integer> findByIdPtskAndStatus(@PathVariable("id") Long id) {
        Integer count =0;
        Short status=1;
       try {
           List<TnvPtskDto> tnvPtsks = tnvPtskService.findByIdPtskAndStatus(id,status);
           count= tnvPtsks.size();
       }catch (Exception e){}


        return ResponseEntity.ok(count);

    }
}
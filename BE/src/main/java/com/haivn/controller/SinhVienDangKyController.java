package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.ChucVu;
import com.haivn.common_api.SinhVienDangKy;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.SinhVienDangKyDto;
import com.haivn.mapper.SinhVienDangKyMapper;
import com.haivn.service.SinhVienDangKyService;
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

@RequestMapping("/api/sinh-vien-dang-ky")
@RestController
@Slf4j
@Api("sinh-vien-dang-ky")
public class SinhVienDangKyController {
    private final SinhVienDangKyService sinhVienDangKyService;

    public SinhVienDangKyController(SinhVienDangKyService sinhVienDangKyService) {
        this.sinhVienDangKyService = sinhVienDangKyService;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated SinhVienDangKyDto sinhVienDangKyDto) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(sinhVienDangKyDto.getFullName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (sinhVienDangKyDto.getStatus()==null || sinhVienDangKyDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getDiaChi())){
            result.put("result", "Thieu dia chi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getEmail())){
            result.put("result", "Thieu email");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getNgaySinh()==null){
            result.put("result", "Thieu ngay sinh");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getIdLop()==null || sinhVienDangKyDto.getIdLop()<=0){
            result.put("result", "Thieu id lop");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getSdt())){
            result.put("result", "Thieu sdt");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getGioiTinh()==null){
            result.put("result", "Thieu gioi tinh");
            result.put("success", false);
        }else {
            try{
                SinhVienDangKyDto item = sinhVienDangKyService.save(sinhVienDangKyDto);
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
            SinhVienDangKyDto sinhVienDangKy = sinhVienDangKyService.findById(id);
            result.put("result",sinhVienDangKy);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(sinhVienDangKyService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        sinhVienDangKyService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<SinhVienDangKy> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<SinhVienDangKyDto> sinhVienDangKyPage = sinhVienDangKyService.findByCondition(spec, pageable);
            result.put("result", sinhVienDangKyPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated SinhVienDangKyDto sinhVienDangKyDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        if(Strings.isNullOrEmpty(sinhVienDangKyDto.getFullName())){
            result.put("result", "Thiếu tên");
            result.put("success", false);
        } else if (sinhVienDangKyDto.getStatus()==null || sinhVienDangKyDto.getStatus()<0){
            result.put("result", "Trạng thái thiếu hoặc không đúng định dạng");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getDiaChi())){
            result.put("result", "Thieu dia chi");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getEmail())){
            result.put("result", "Thieu email");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getNgaySinh()==null){
            result.put("result", "Thieu ngay sinh");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getIdLop()==null || sinhVienDangKyDto.getIdLop()<=0){
            result.put("result", "Thieu id lop");
            result.put("success", false);
        }else if (Strings.isNullOrEmpty(sinhVienDangKyDto.getSdt())){
            result.put("result", "Thieu sdt");
            result.put("success", false);
        }else if (sinhVienDangKyDto.getGioiTinh()==null){
            result.put("result", "Thieu gioi tinh");
            result.put("success", false);
        }else {
            try{
                sinhVienDangKyDto.setId(id);
                SinhVienDangKyDto item = sinhVienDangKyService.update(sinhVienDangKyDto, id);
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

    @GetMapping("/reset/{id}")
    public ResponseEntity<Map<String, Object>> updateSTTReset(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Short status1=0;
            SinhVienDangKyDto sinhVienDangKy = sinhVienDangKyService.findById(id);
            sinhVienDangKy.setStatus(status1);
            SinhVienDangKyDto item = sinhVienDangKyService.update(sinhVienDangKy, id);
            result.put("result",item.getStatus());
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @GetMapping("/pv/{id}")
    public ResponseEntity<Map<String, Object>> updateSTTPV(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Short status1=1;
            SinhVienDangKyDto sinhVienDangKy = sinhVienDangKyService.findById(id);
            sinhVienDangKy.setStatus(status1);
            SinhVienDangKyDto item = sinhVienDangKyService.update(sinhVienDangKy, id);
            result.put("result",item.getStatus());
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/pass/{id}")
    public ResponseEntity<Map<String, Object>> updateSTTPass(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Short status1=2;
            SinhVienDangKyDto sinhVienDangKy = sinhVienDangKyService.findById(id);
            sinhVienDangKy.setStatus(status1);
            SinhVienDangKyDto item = sinhVienDangKyService.update(sinhVienDangKy, id);
            result.put("result",item.getStatus());
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/fail/{id}")
    public ResponseEntity<Map<String, Object>> updateSTTFail(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Short status1=3;
            SinhVienDangKyDto sinhVienDangKy = sinhVienDangKyService.findById(id);
            sinhVienDangKy.setStatus(status1);
            SinhVienDangKyDto item = sinhVienDangKyService.update(sinhVienDangKy, id);
            result.put("result",item.getStatus());
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

//Lay danh sach cac sinh vien đang trong trạng thái chờ phỏng vấn
    @GetMapping("/get/stt0")
    public ResponseEntity<Integer> getCountSTTO() {
        Integer result=0;
        Short status=0;
        try {
            List<SinhVienDangKyDto> data = sinhVienDangKyService.fillByStatus(status);
            result=data.size();
        } catch (Exception e) {
        }
        return ResponseEntity.ok(result);
    }
}
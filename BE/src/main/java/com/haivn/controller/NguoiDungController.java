package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.authenticate.UserPrincipal;
import com.haivn.common_api.LopHoc;
import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.UserLogin;
import com.haivn.dto.LopHocDto;
import com.haivn.dto.NguoiDungDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.LopHocMapper;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.repository.NguoiDungRepository;
import com.haivn.service.NguoiDungService;
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
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.FileSystemNotFoundException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/nguoi-dung")
@RestController
@Slf4j
@Api("nguoi-dung")
public class NguoiDungController {
    private final NguoiDungService nguoiDungService;
    private final NguoiDungMapper nguoiDungMapper;
    private final NguoiDungRepository repository;

    public NguoiDungController(NguoiDungService nguoiDungService,NguoiDungMapper nguoiDungMapper,NguoiDungRepository repository) {
        this.nguoiDungService = nguoiDungService;
        this.nguoiDungMapper = nguoiDungMapper;
        this.repository = repository;
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> loginPass(@RequestBody @Validated UserLogin userLogin) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung = repository.findByUsername(userLogin.getUsername());
            Boolean checkPass = BCrypt.checkpw(userLogin.getPassword(), nguoiDung.getPassword());
            if(checkPass){
                result.put("result",nguoiDung);
                result.put("success", true);
            }else {
                result.put("result", "Tài khoản / mật khẩu không đúng");
                result.put("success", false);
            }
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/createAdmin")
    public ResponseEntity<Map<String, Object>> createAdmin(@RequestBody @Validated UserLogin userLogin) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {

            NguoiDung nguoiDung = repository.findByUsername(userLogin.getUsername());
            System.out.printf("================");
           if(nguoiDung==null){
               Short statusAdmin = 0 ;
               Short status = 1 ;
               NguoiDung data= new NguoiDung();
               data.setRole(statusAdmin);
               data.setUsername(userLogin.getUsername());
               data.setPassword(Utils.getBCryptedPassword("123456"));
               data.setFullName(userLogin.getUsername());
               data.setEmail("admin@gmail.com");
               data.setStatus(status);
               NguoiDung item= repository.save(data);
               result.put("result",item);
               result.put("success", true);
           }else {
               result.put("result", "Tài khoản tồn tại");
               result.put("success", false);
           }
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/change-pass/{id}")
    public ResponseEntity<Map<String, Object>> changePass(@RequestBody @Validated UserLogin userLogin,@PathVariable("id") Long id) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDungDto nguoiDung = nguoiDungService.findById(id);
            nguoiDung.setPassword(Utils.getBCryptedPassword(userLogin.getPassword()));
            NguoiDungDto item= nguoiDungService.update(nguoiDung, id);
            result.put("result",item.getId());
            result.put("success", true);
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/create")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated NguoiDungDto nguoiDungDto) {
        Map<String, Object> result =new HashMap<String, Object>();
        String messErr = "";
        if(Strings.isNullOrEmpty(nguoiDungDto.getFullName())){
            messErr += "tên người dùng";
        }
        if (Strings.isNullOrEmpty(nguoiDungDto.getEmail())){
            if(messErr != ""){
                messErr += ", email";
            }
            else{
                messErr += "email";
            }
        }
        if (Strings.isNullOrEmpty(nguoiDungDto.getSdt())){
            if(messErr != ""){
                messErr += ", sdt";
            }
            else{
                messErr += "sdt";
            }
        }
        if (Strings.isNullOrEmpty(nguoiDungDto.getDiaChi())){
            if(messErr != ""){
                messErr += ", địa chỉ";
            }
            else{
                messErr += "địa chỉ";
            }
        }
        if (nguoiDungDto.getIdLop()==null||nguoiDungDto.getIdLop()<1){
            if(messErr != ""){
                messErr += ", lớp học";
            }
            else{
                messErr += "Lớp học";
            }
        }
        if (nguoiDungDto.getGioiTinh()==null){
            if(messErr != ""){
                messErr += ", giới tính";
            }
            else{
                messErr += "Giới tính";
            }
        }
        if (nguoiDungDto.getIdChucVu()==null||nguoiDungDto.getIdChucVu()<1){
            if(messErr != ""){
                messErr += ", chức vụ";
            }
            else{
                messErr += "chức vụ";
            }
        }
        if (nguoiDungDto.getNgaySinh()==null){
            if(messErr != ""){
                messErr += ", ngày sinh";
            }
            else{
                messErr += "ngày sinh";
            }
        }
        if (nguoiDungDto.getStatus()==null){
            if(messErr != ""){
                messErr += ", trạng thái";
            }
            else{
                messErr += "trạng thái";
            }
        }
        if(messErr != ""){
            messErr = "Không được bỏ trống " + messErr;
            result.put("result", messErr);
            result.put("success",false);
        }
        else{
            NguoiDungDto tblUser = nguoiDungService.findByEmail(nguoiDungDto.getEmail());
            if(tblUser == null){
               try{
                   Short role =1;
                   NguoiDung user = nguoiDungMapper.toEntity(nguoiDungDto);
                   user.setUsername(nguoiDungDto.getEmail());
                   user.setPassword(Utils.getBCryptedPassword("123456"));
//                   user.setNgayVao();
                   user.setRole(role);
                   repository.save(user);
                   result.put("result", "Đăng kí thành công");
                   result.put("success", true);
               }catch (Exception e){
                   result.put("result",e.getMessage());
                   result.put("success", false);
               }
            }
            else{
                result.put("result", "Email này đã tồn tại");
                result.put("success", false);
            }
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            NguoiDungDto nguoiDung = nguoiDungService.findById(id);
            result.put("result",nguoiDung);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(nguoiDungService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        nguoiDungService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<NguoiDung> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<NguoiDungDto> nguoiDungPage = nguoiDungService.findByCondition(spec, pageable);
            result.put("result", nguoiDungPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated NguoiDungDto nguoiDungDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            nguoiDungDto.setId(id);
            NguoiDungDto item= nguoiDungService.update(nguoiDungDto, id);
            result.put("result", item.getId());
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}
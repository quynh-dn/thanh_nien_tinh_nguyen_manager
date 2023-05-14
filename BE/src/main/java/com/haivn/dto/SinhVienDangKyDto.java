package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import com.haivn.common_api.LopHoc;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class SinhVienDangKyDto extends BaseDto {
    @Size(max = 255)
    private String fullName;
    @Size(max = 255)
    private String maSV;
    private Long idLop;
    private LopHoc lopHoc;
    private Timestamp ngaySinh;
    @Size(max = 255)
    private String diaChi;
    private Boolean gioiTinh;
    @CheckEmail
    @Size(max = 255)
    private String email;
    @Size(max = 255)
    private String sdt;
    private String moTa;
    private Short status;

    public SinhVienDangKyDto() {
    }
}
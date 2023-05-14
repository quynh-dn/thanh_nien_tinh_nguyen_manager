package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import com.haivn.common_api.ChucVu;
import com.haivn.common_api.LopHoc;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class NguoiDungDto extends BaseDto {
    private Short role;
    private String username;
    private String password;
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
    private Timestamp ngayVao;
    private Long idChucVu;
    @Size(max = 255)
    private String avatar;
    private ChucVu chucVu;
    private Short status;
    public NguoiDungDto() {
    }
}
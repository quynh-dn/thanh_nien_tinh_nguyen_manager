package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class LichPhongVanDto extends BaseDto {
    private Long id;
    @Size(max = 255)
    private String title;
    private String content;
    private Timestamp thoiGian;
    @Size(max = 255)
    private String diaDiem;
    @Size(max = 255)
    private String thanhPhanThamDu;
    @Size(max = 255)
    private String sinhVienPv;
    private Short status;

    public LichPhongVanDto() {
    }
}
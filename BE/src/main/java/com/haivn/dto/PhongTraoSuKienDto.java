package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class PhongTraoSuKienDto extends BaseDto {
    private Long id;
    @Size(max = 255)
    private String title;
    private String content;
    @Size(max = 255)
    private String poster;
    private Timestamp startDate;
    private Timestamp endDate;
    @Size(max = 255)
    private String diaDiem;
    @Size(max = 255)
    private String kinhPhi;
    @Size(max = 255)
    private String nguoiPhuTrach;
    private Short soLuongHoTro;
    private Short status;

    public PhongTraoSuKienDto() {
    }
}
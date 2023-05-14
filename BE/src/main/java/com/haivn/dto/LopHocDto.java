package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class LopHocDto extends BaseDto {
    @Size(max = 255)
    private String name;
    @Size(max = 255)
    private String khoa;
    @Size(max = 255)
    private String tenChuNhiem;
    @Size(max = 255)
    private String sdtChuNhiem;
    @CheckEmail
    @Size(max = 255)
    private String emailChuNhiem;
    private Short status;

    public LopHocDto() {
    }
}
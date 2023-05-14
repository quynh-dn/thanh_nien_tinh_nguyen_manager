package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class ChucVuDto extends BaseDto {
    @Size(max = 255)
    private String name;
    private Short level;
    private Short status;

    public ChucVuDto() {
    }
}
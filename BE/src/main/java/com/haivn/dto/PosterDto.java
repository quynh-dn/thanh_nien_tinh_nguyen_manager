package com.haivn.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class PosterDto extends BaseDto {
    private Long id;
    @Size(max = 255)
    private String name;
    @Size(max = 255)
    private String fileName;
    private Short stt;
    private Short status;

    public PosterDto() {
    }
}
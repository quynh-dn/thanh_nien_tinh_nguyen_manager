package com.haivn.dto;

import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.PhongTraoSuKien;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

@ApiModel()
@Getter
@Setter
public class TnvPtskDto extends BaseDto{
    private Long idTnv;
    private NguoiDung nguoiDung;
    private Long idPtsk;
    private PhongTraoSuKien phongTraoSuKien;
    private Short status;
    public TnvPtskDto() {
    }
}
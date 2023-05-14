package com.haivn.mapper;

import com.haivn.common_api.SinhVienDangKy;
import com.haivn.dto.SinhVienDangKyDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface SinhVienDangKyMapper extends EntityMapper<SinhVienDangKyDto, SinhVienDangKy> {
}
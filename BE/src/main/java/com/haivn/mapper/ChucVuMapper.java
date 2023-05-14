package com.haivn.mapper;

import com.haivn.common_api.ChucVu;
import com.haivn.dto.ChucVuDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ChucVuMapper extends EntityMapper<ChucVuDto, ChucVu> {
}
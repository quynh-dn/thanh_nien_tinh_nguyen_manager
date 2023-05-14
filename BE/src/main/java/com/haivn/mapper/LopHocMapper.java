package com.haivn.mapper;

import com.haivn.common_api.LopHoc;
import com.haivn.dto.LopHocDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface LopHocMapper extends EntityMapper<LopHocDto, LopHoc> {
}
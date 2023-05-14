package com.haivn.mapper;

import com.haivn.common_api.PhongTraoSuKien;
import com.haivn.dto.PhongTraoSuKienDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface PhongTraoSuKienMapper extends EntityMapper<PhongTraoSuKienDto, PhongTraoSuKien> {
}
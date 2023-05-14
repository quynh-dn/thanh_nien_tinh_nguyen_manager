package com.haivn.mapper;

import com.haivn.common_api.LichPhongVan;
import com.haivn.dto.LichPhongVanDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface LichPhongVanMapper extends EntityMapper<LichPhongVanDto, LichPhongVan> {
}
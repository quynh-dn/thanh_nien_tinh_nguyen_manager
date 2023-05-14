package com.haivn.mapper;

import com.haivn.common_api.TnvPtsk;
import com.haivn.dto.TnvPtskDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface TnvPtskMapper extends EntityMapper<TnvPtskDto, TnvPtsk> {
}
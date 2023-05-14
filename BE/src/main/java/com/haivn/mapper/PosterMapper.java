package com.haivn.mapper;

import com.haivn.common_api.Poster;
import com.haivn.dto.PosterDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface PosterMapper extends EntityMapper<PosterDto, Poster> {
}
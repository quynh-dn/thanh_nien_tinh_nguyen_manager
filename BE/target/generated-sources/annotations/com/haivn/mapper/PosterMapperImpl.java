package com.haivn.mapper;

import com.haivn.common_api.Poster;
import com.haivn.dto.PosterDto;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2023-05-08T22:49:30+0700",
    comments = "version: 1.5.1.Final, compiler: Eclipse JDT (IDE) 3.34.0.v20230413-0857, environment: Java 17.0.7 (Eclipse Adoptium)"
)
@Component
public class PosterMapperImpl implements PosterMapper {

    @Override
    public Poster toEntity(PosterDto dto) {
        if ( dto == null ) {
            return null;
        }

        Poster poster = new Poster();

        poster.setCreatedDate( dto.getCreatedDate() );
        poster.setCreatedUser( dto.getCreatedUser() );
        poster.setDeleted( dto.isDeleted() );
        poster.setId( dto.getId() );
        poster.setModifiedDate( dto.getModifiedDate() );
        poster.setModifiedUser( dto.getModifiedUser() );
        poster.setFileName( dto.getFileName() );
        poster.setName( dto.getName() );
        poster.setStatus( dto.getStatus() );
        poster.setStt( dto.getStt() );

        return poster;
    }

    @Override
    public PosterDto toDto(Poster entity) {
        if ( entity == null ) {
            return null;
        }

        PosterDto posterDto = new PosterDto();

        if ( entity.getCreatedDate() != null ) {
            posterDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        posterDto.setCreatedUser( entity.getCreatedUser() );
        posterDto.setDeleted( entity.isDeleted() );
        if ( entity.getModifiedDate() != null ) {
            posterDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        posterDto.setModifiedUser( entity.getModifiedUser() );
        posterDto.setFileName( entity.getFileName() );
        posterDto.setId( entity.getId() );
        posterDto.setName( entity.getName() );
        posterDto.setStatus( entity.getStatus() );
        posterDto.setStt( entity.getStt() );

        return posterDto;
    }

    @Override
    public List<Poster> toEntity(List<PosterDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<Poster> list = new ArrayList<Poster>( dtoList.size() );
        for ( PosterDto posterDto : dtoList ) {
            list.add( toEntity( posterDto ) );
        }

        return list;
    }

    @Override
    public List<PosterDto> toDto(List<Poster> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<PosterDto> list = new ArrayList<PosterDto>( entityList.size() );
        for ( Poster poster : entityList ) {
            list.add( toDto( poster ) );
        }

        return list;
    }

    @Override
    public Set<PosterDto> toDto(Set<Poster> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<PosterDto> set = new LinkedHashSet<PosterDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( Poster poster : entityList ) {
            set.add( toDto( poster ) );
        }

        return set;
    }
}

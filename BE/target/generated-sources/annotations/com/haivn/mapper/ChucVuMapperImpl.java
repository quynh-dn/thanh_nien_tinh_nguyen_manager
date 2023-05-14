package com.haivn.mapper;

import com.haivn.common_api.ChucVu;
import com.haivn.dto.ChucVuDto;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2023-05-08T22:49:31+0700",
    comments = "version: 1.5.1.Final, compiler: Eclipse JDT (IDE) 3.34.0.v20230413-0857, environment: Java 17.0.7 (Eclipse Adoptium)"
)
@Component
public class ChucVuMapperImpl implements ChucVuMapper {

    @Override
    public ChucVu toEntity(ChucVuDto dto) {
        if ( dto == null ) {
            return null;
        }

        ChucVu chucVu = new ChucVu();

        chucVu.setCreatedDate( dto.getCreatedDate() );
        chucVu.setCreatedUser( dto.getCreatedUser() );
        chucVu.setDeleted( dto.isDeleted() );
        chucVu.setId( dto.getId() );
        chucVu.setModifiedDate( dto.getModifiedDate() );
        chucVu.setModifiedUser( dto.getModifiedUser() );
        chucVu.setLevel( dto.getLevel() );
        chucVu.setName( dto.getName() );
        chucVu.setStatus( dto.getStatus() );

        return chucVu;
    }

    @Override
    public ChucVuDto toDto(ChucVu entity) {
        if ( entity == null ) {
            return null;
        }

        ChucVuDto chucVuDto = new ChucVuDto();

        if ( entity.getCreatedDate() != null ) {
            chucVuDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        chucVuDto.setCreatedUser( entity.getCreatedUser() );
        chucVuDto.setDeleted( entity.isDeleted() );
        chucVuDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            chucVuDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        chucVuDto.setModifiedUser( entity.getModifiedUser() );
        chucVuDto.setLevel( entity.getLevel() );
        chucVuDto.setName( entity.getName() );
        chucVuDto.setStatus( entity.getStatus() );

        return chucVuDto;
    }

    @Override
    public List<ChucVu> toEntity(List<ChucVuDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<ChucVu> list = new ArrayList<ChucVu>( dtoList.size() );
        for ( ChucVuDto chucVuDto : dtoList ) {
            list.add( toEntity( chucVuDto ) );
        }

        return list;
    }

    @Override
    public List<ChucVuDto> toDto(List<ChucVu> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<ChucVuDto> list = new ArrayList<ChucVuDto>( entityList.size() );
        for ( ChucVu chucVu : entityList ) {
            list.add( toDto( chucVu ) );
        }

        return list;
    }

    @Override
    public Set<ChucVuDto> toDto(Set<ChucVu> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<ChucVuDto> set = new LinkedHashSet<ChucVuDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( ChucVu chucVu : entityList ) {
            set.add( toDto( chucVu ) );
        }

        return set;
    }
}

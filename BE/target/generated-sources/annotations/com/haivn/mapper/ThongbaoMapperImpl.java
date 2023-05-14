package com.haivn.mapper;

import com.haivn.common_api.Thongbao;
import com.haivn.dto.ThongbaoDto;
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
public class ThongbaoMapperImpl implements ThongbaoMapper {

    @Override
    public Thongbao toEntity(ThongbaoDto dto) {
        if ( dto == null ) {
            return null;
        }

        Thongbao thongbao = new Thongbao();

        thongbao.setCreatedDate( dto.getCreatedDate() );
        thongbao.setCreatedUser( dto.getCreatedUser() );
        thongbao.setDeleted( dto.isDeleted() );
        thongbao.setId( dto.getId() );
        thongbao.setModifiedDate( dto.getModifiedDate() );
        thongbao.setModifiedUser( dto.getModifiedUser() );
        thongbao.setTitle( dto.getTitle() );

        return thongbao;
    }

    @Override
    public ThongbaoDto toDto(Thongbao entity) {
        if ( entity == null ) {
            return null;
        }

        ThongbaoDto thongbaoDto = new ThongbaoDto();

        if ( entity.getCreatedDate() != null ) {
            thongbaoDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        thongbaoDto.setCreatedUser( entity.getCreatedUser() );
        thongbaoDto.setDeleted( entity.isDeleted() );
        thongbaoDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            thongbaoDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        thongbaoDto.setModifiedUser( entity.getModifiedUser() );
        thongbaoDto.setTitle( entity.getTitle() );

        return thongbaoDto;
    }

    @Override
    public List<Thongbao> toEntity(List<ThongbaoDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<Thongbao> list = new ArrayList<Thongbao>( dtoList.size() );
        for ( ThongbaoDto thongbaoDto : dtoList ) {
            list.add( toEntity( thongbaoDto ) );
        }

        return list;
    }

    @Override
    public List<ThongbaoDto> toDto(List<Thongbao> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<ThongbaoDto> list = new ArrayList<ThongbaoDto>( entityList.size() );
        for ( Thongbao thongbao : entityList ) {
            list.add( toDto( thongbao ) );
        }

        return list;
    }

    @Override
    public Set<ThongbaoDto> toDto(Set<Thongbao> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<ThongbaoDto> set = new LinkedHashSet<ThongbaoDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( Thongbao thongbao : entityList ) {
            set.add( toDto( thongbao ) );
        }

        return set;
    }
}

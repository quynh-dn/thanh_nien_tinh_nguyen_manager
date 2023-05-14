package com.haivn.mapper;

import com.haivn.common_api.LichPhongVan;
import com.haivn.dto.LichPhongVanDto;
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
public class LichPhongVanMapperImpl implements LichPhongVanMapper {

    @Override
    public LichPhongVan toEntity(LichPhongVanDto dto) {
        if ( dto == null ) {
            return null;
        }

        LichPhongVan lichPhongVan = new LichPhongVan();

        lichPhongVan.setCreatedDate( dto.getCreatedDate() );
        lichPhongVan.setCreatedUser( dto.getCreatedUser() );
        lichPhongVan.setDeleted( dto.isDeleted() );
        lichPhongVan.setId( dto.getId() );
        lichPhongVan.setModifiedDate( dto.getModifiedDate() );
        lichPhongVan.setModifiedUser( dto.getModifiedUser() );
        lichPhongVan.setContent( dto.getContent() );
        lichPhongVan.setDiaDiem( dto.getDiaDiem() );
        lichPhongVan.setSinhVienPv( dto.getSinhVienPv() );
        lichPhongVan.setStatus( dto.getStatus() );
        lichPhongVan.setThanhPhanThamDu( dto.getThanhPhanThamDu() );
        lichPhongVan.setThoiGian( dto.getThoiGian() );
        lichPhongVan.setTitle( dto.getTitle() );

        return lichPhongVan;
    }

    @Override
    public LichPhongVanDto toDto(LichPhongVan entity) {
        if ( entity == null ) {
            return null;
        }

        LichPhongVanDto lichPhongVanDto = new LichPhongVanDto();

        if ( entity.getCreatedDate() != null ) {
            lichPhongVanDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        lichPhongVanDto.setCreatedUser( entity.getCreatedUser() );
        lichPhongVanDto.setDeleted( entity.isDeleted() );
        if ( entity.getModifiedDate() != null ) {
            lichPhongVanDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        lichPhongVanDto.setModifiedUser( entity.getModifiedUser() );
        lichPhongVanDto.setContent( entity.getContent() );
        lichPhongVanDto.setDiaDiem( entity.getDiaDiem() );
        lichPhongVanDto.setId( entity.getId() );
        lichPhongVanDto.setSinhVienPv( entity.getSinhVienPv() );
        lichPhongVanDto.setStatus( entity.getStatus() );
        lichPhongVanDto.setThanhPhanThamDu( entity.getThanhPhanThamDu() );
        lichPhongVanDto.setThoiGian( entity.getThoiGian() );
        lichPhongVanDto.setTitle( entity.getTitle() );

        return lichPhongVanDto;
    }

    @Override
    public List<LichPhongVan> toEntity(List<LichPhongVanDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<LichPhongVan> list = new ArrayList<LichPhongVan>( dtoList.size() );
        for ( LichPhongVanDto lichPhongVanDto : dtoList ) {
            list.add( toEntity( lichPhongVanDto ) );
        }

        return list;
    }

    @Override
    public List<LichPhongVanDto> toDto(List<LichPhongVan> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<LichPhongVanDto> list = new ArrayList<LichPhongVanDto>( entityList.size() );
        for ( LichPhongVan lichPhongVan : entityList ) {
            list.add( toDto( lichPhongVan ) );
        }

        return list;
    }

    @Override
    public Set<LichPhongVanDto> toDto(Set<LichPhongVan> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<LichPhongVanDto> set = new LinkedHashSet<LichPhongVanDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( LichPhongVan lichPhongVan : entityList ) {
            set.add( toDto( lichPhongVan ) );
        }

        return set;
    }
}

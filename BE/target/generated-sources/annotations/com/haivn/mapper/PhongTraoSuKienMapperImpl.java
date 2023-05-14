package com.haivn.mapper;

import com.haivn.common_api.PhongTraoSuKien;
import com.haivn.dto.PhongTraoSuKienDto;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2023-05-08T22:49:32+0700",
    comments = "version: 1.5.1.Final, compiler: Eclipse JDT (IDE) 3.34.0.v20230413-0857, environment: Java 17.0.7 (Eclipse Adoptium)"
)
@Component
public class PhongTraoSuKienMapperImpl implements PhongTraoSuKienMapper {

    @Override
    public PhongTraoSuKien toEntity(PhongTraoSuKienDto dto) {
        if ( dto == null ) {
            return null;
        }

        PhongTraoSuKien phongTraoSuKien = new PhongTraoSuKien();

        phongTraoSuKien.setCreatedDate( dto.getCreatedDate() );
        phongTraoSuKien.setCreatedUser( dto.getCreatedUser() );
        phongTraoSuKien.setDeleted( dto.isDeleted() );
        phongTraoSuKien.setId( dto.getId() );
        phongTraoSuKien.setModifiedDate( dto.getModifiedDate() );
        phongTraoSuKien.setModifiedUser( dto.getModifiedUser() );
        phongTraoSuKien.setContent( dto.getContent() );
        phongTraoSuKien.setDiaDiem( dto.getDiaDiem() );
        phongTraoSuKien.setEndDate( dto.getEndDate() );
        phongTraoSuKien.setKinhPhi( dto.getKinhPhi() );
        phongTraoSuKien.setNguoiPhuTrach( dto.getNguoiPhuTrach() );
        phongTraoSuKien.setPoster( dto.getPoster() );
        phongTraoSuKien.setSoLuongHoTro( dto.getSoLuongHoTro() );
        phongTraoSuKien.setStartDate( dto.getStartDate() );
        phongTraoSuKien.setStatus( dto.getStatus() );
        phongTraoSuKien.setTitle( dto.getTitle() );

        return phongTraoSuKien;
    }

    @Override
    public PhongTraoSuKienDto toDto(PhongTraoSuKien entity) {
        if ( entity == null ) {
            return null;
        }

        PhongTraoSuKienDto phongTraoSuKienDto = new PhongTraoSuKienDto();

        if ( entity.getCreatedDate() != null ) {
            phongTraoSuKienDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        phongTraoSuKienDto.setCreatedUser( entity.getCreatedUser() );
        phongTraoSuKienDto.setDeleted( entity.isDeleted() );
        if ( entity.getModifiedDate() != null ) {
            phongTraoSuKienDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        phongTraoSuKienDto.setModifiedUser( entity.getModifiedUser() );
        phongTraoSuKienDto.setContent( entity.getContent() );
        phongTraoSuKienDto.setDiaDiem( entity.getDiaDiem() );
        phongTraoSuKienDto.setEndDate( entity.getEndDate() );
        phongTraoSuKienDto.setId( entity.getId() );
        phongTraoSuKienDto.setKinhPhi( entity.getKinhPhi() );
        phongTraoSuKienDto.setNguoiPhuTrach( entity.getNguoiPhuTrach() );
        phongTraoSuKienDto.setPoster( entity.getPoster() );
        phongTraoSuKienDto.setSoLuongHoTro( entity.getSoLuongHoTro() );
        phongTraoSuKienDto.setStartDate( entity.getStartDate() );
        phongTraoSuKienDto.setStatus( entity.getStatus() );
        phongTraoSuKienDto.setTitle( entity.getTitle() );

        return phongTraoSuKienDto;
    }

    @Override
    public List<PhongTraoSuKien> toEntity(List<PhongTraoSuKienDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<PhongTraoSuKien> list = new ArrayList<PhongTraoSuKien>( dtoList.size() );
        for ( PhongTraoSuKienDto phongTraoSuKienDto : dtoList ) {
            list.add( toEntity( phongTraoSuKienDto ) );
        }

        return list;
    }

    @Override
    public List<PhongTraoSuKienDto> toDto(List<PhongTraoSuKien> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<PhongTraoSuKienDto> list = new ArrayList<PhongTraoSuKienDto>( entityList.size() );
        for ( PhongTraoSuKien phongTraoSuKien : entityList ) {
            list.add( toDto( phongTraoSuKien ) );
        }

        return list;
    }

    @Override
    public Set<PhongTraoSuKienDto> toDto(Set<PhongTraoSuKien> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<PhongTraoSuKienDto> set = new LinkedHashSet<PhongTraoSuKienDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( PhongTraoSuKien phongTraoSuKien : entityList ) {
            set.add( toDto( phongTraoSuKien ) );
        }

        return set;
    }
}

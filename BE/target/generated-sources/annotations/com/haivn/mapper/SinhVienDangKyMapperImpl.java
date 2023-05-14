package com.haivn.mapper;

import com.haivn.common_api.SinhVienDangKy;
import com.haivn.dto.SinhVienDangKyDto;
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
public class SinhVienDangKyMapperImpl implements SinhVienDangKyMapper {

    @Override
    public SinhVienDangKy toEntity(SinhVienDangKyDto dto) {
        if ( dto == null ) {
            return null;
        }

        SinhVienDangKy sinhVienDangKy = new SinhVienDangKy();

        sinhVienDangKy.setCreatedDate( dto.getCreatedDate() );
        sinhVienDangKy.setCreatedUser( dto.getCreatedUser() );
        sinhVienDangKy.setDeleted( dto.isDeleted() );
        sinhVienDangKy.setId( dto.getId() );
        sinhVienDangKy.setModifiedDate( dto.getModifiedDate() );
        sinhVienDangKy.setModifiedUser( dto.getModifiedUser() );
        sinhVienDangKy.setDiaChi( dto.getDiaChi() );
        sinhVienDangKy.setEmail( dto.getEmail() );
        sinhVienDangKy.setFullName( dto.getFullName() );
        sinhVienDangKy.setGioiTinh( dto.getGioiTinh() );
        sinhVienDangKy.setIdLop( dto.getIdLop() );
        sinhVienDangKy.setLopHoc( dto.getLopHoc() );
        sinhVienDangKy.setMaSV( dto.getMaSV() );
        sinhVienDangKy.setMoTa( dto.getMoTa() );
        sinhVienDangKy.setNgaySinh( dto.getNgaySinh() );
        sinhVienDangKy.setSdt( dto.getSdt() );
        sinhVienDangKy.setStatus( dto.getStatus() );

        return sinhVienDangKy;
    }

    @Override
    public SinhVienDangKyDto toDto(SinhVienDangKy entity) {
        if ( entity == null ) {
            return null;
        }

        SinhVienDangKyDto sinhVienDangKyDto = new SinhVienDangKyDto();

        if ( entity.getCreatedDate() != null ) {
            sinhVienDangKyDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        sinhVienDangKyDto.setCreatedUser( entity.getCreatedUser() );
        sinhVienDangKyDto.setDeleted( entity.isDeleted() );
        sinhVienDangKyDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            sinhVienDangKyDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        sinhVienDangKyDto.setModifiedUser( entity.getModifiedUser() );
        sinhVienDangKyDto.setDiaChi( entity.getDiaChi() );
        sinhVienDangKyDto.setEmail( entity.getEmail() );
        sinhVienDangKyDto.setFullName( entity.getFullName() );
        sinhVienDangKyDto.setGioiTinh( entity.getGioiTinh() );
        sinhVienDangKyDto.setIdLop( entity.getIdLop() );
        sinhVienDangKyDto.setLopHoc( entity.getLopHoc() );
        sinhVienDangKyDto.setMaSV( entity.getMaSV() );
        sinhVienDangKyDto.setMoTa( entity.getMoTa() );
        sinhVienDangKyDto.setNgaySinh( entity.getNgaySinh() );
        sinhVienDangKyDto.setSdt( entity.getSdt() );
        sinhVienDangKyDto.setStatus( entity.getStatus() );

        return sinhVienDangKyDto;
    }

    @Override
    public List<SinhVienDangKy> toEntity(List<SinhVienDangKyDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<SinhVienDangKy> list = new ArrayList<SinhVienDangKy>( dtoList.size() );
        for ( SinhVienDangKyDto sinhVienDangKyDto : dtoList ) {
            list.add( toEntity( sinhVienDangKyDto ) );
        }

        return list;
    }

    @Override
    public List<SinhVienDangKyDto> toDto(List<SinhVienDangKy> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<SinhVienDangKyDto> list = new ArrayList<SinhVienDangKyDto>( entityList.size() );
        for ( SinhVienDangKy sinhVienDangKy : entityList ) {
            list.add( toDto( sinhVienDangKy ) );
        }

        return list;
    }

    @Override
    public Set<SinhVienDangKyDto> toDto(Set<SinhVienDangKy> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<SinhVienDangKyDto> set = new LinkedHashSet<SinhVienDangKyDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( SinhVienDangKy sinhVienDangKy : entityList ) {
            set.add( toDto( sinhVienDangKy ) );
        }

        return set;
    }
}

package com.haivn.mapper;

import com.haivn.common_api.NguoiDung;
import com.haivn.dto.NguoiDungDto;
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
public class NguoiDungMapperImpl implements NguoiDungMapper {

    @Override
    public NguoiDung toEntity(NguoiDungDto dto) {
        if ( dto == null ) {
            return null;
        }

        NguoiDung nguoiDung = new NguoiDung();

        nguoiDung.setCreatedDate( dto.getCreatedDate() );
        nguoiDung.setCreatedUser( dto.getCreatedUser() );
        nguoiDung.setDeleted( dto.isDeleted() );
        nguoiDung.setId( dto.getId() );
        nguoiDung.setModifiedDate( dto.getModifiedDate() );
        nguoiDung.setModifiedUser( dto.getModifiedUser() );
        nguoiDung.setAvatar( dto.getAvatar() );
        nguoiDung.setChucVu( dto.getChucVu() );
        nguoiDung.setDiaChi( dto.getDiaChi() );
        nguoiDung.setEmail( dto.getEmail() );
        nguoiDung.setFullName( dto.getFullName() );
        nguoiDung.setGioiTinh( dto.getGioiTinh() );
        nguoiDung.setIdChucVu( dto.getIdChucVu() );
        nguoiDung.setIdLop( dto.getIdLop() );
        nguoiDung.setLopHoc( dto.getLopHoc() );
        nguoiDung.setMaSV( dto.getMaSV() );
        nguoiDung.setNgaySinh( dto.getNgaySinh() );
        nguoiDung.setNgayVao( dto.getNgayVao() );
        nguoiDung.setPassword( dto.getPassword() );
        nguoiDung.setRole( dto.getRole() );
        nguoiDung.setSdt( dto.getSdt() );
        nguoiDung.setStatus( dto.getStatus() );
        nguoiDung.setUsername( dto.getUsername() );

        return nguoiDung;
    }

    @Override
    public NguoiDungDto toDto(NguoiDung entity) {
        if ( entity == null ) {
            return null;
        }

        NguoiDungDto nguoiDungDto = new NguoiDungDto();

        if ( entity.getCreatedDate() != null ) {
            nguoiDungDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        nguoiDungDto.setCreatedUser( entity.getCreatedUser() );
        nguoiDungDto.setDeleted( entity.isDeleted() );
        nguoiDungDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            nguoiDungDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        nguoiDungDto.setModifiedUser( entity.getModifiedUser() );
        nguoiDungDto.setAvatar( entity.getAvatar() );
        nguoiDungDto.setChucVu( entity.getChucVu() );
        nguoiDungDto.setDiaChi( entity.getDiaChi() );
        nguoiDungDto.setEmail( entity.getEmail() );
        nguoiDungDto.setFullName( entity.getFullName() );
        nguoiDungDto.setGioiTinh( entity.getGioiTinh() );
        nguoiDungDto.setIdChucVu( entity.getIdChucVu() );
        nguoiDungDto.setIdLop( entity.getIdLop() );
        nguoiDungDto.setLopHoc( entity.getLopHoc() );
        nguoiDungDto.setMaSV( entity.getMaSV() );
        nguoiDungDto.setNgaySinh( entity.getNgaySinh() );
        nguoiDungDto.setNgayVao( entity.getNgayVao() );
        nguoiDungDto.setPassword( entity.getPassword() );
        nguoiDungDto.setRole( entity.getRole() );
        nguoiDungDto.setSdt( entity.getSdt() );
        nguoiDungDto.setStatus( entity.getStatus() );
        nguoiDungDto.setUsername( entity.getUsername() );

        return nguoiDungDto;
    }

    @Override
    public List<NguoiDung> toEntity(List<NguoiDungDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<NguoiDung> list = new ArrayList<NguoiDung>( dtoList.size() );
        for ( NguoiDungDto nguoiDungDto : dtoList ) {
            list.add( toEntity( nguoiDungDto ) );
        }

        return list;
    }

    @Override
    public List<NguoiDungDto> toDto(List<NguoiDung> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<NguoiDungDto> list = new ArrayList<NguoiDungDto>( entityList.size() );
        for ( NguoiDung nguoiDung : entityList ) {
            list.add( toDto( nguoiDung ) );
        }

        return list;
    }

    @Override
    public Set<NguoiDungDto> toDto(Set<NguoiDung> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<NguoiDungDto> set = new LinkedHashSet<NguoiDungDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( NguoiDung nguoiDung : entityList ) {
            set.add( toDto( nguoiDung ) );
        }

        return set;
    }
}

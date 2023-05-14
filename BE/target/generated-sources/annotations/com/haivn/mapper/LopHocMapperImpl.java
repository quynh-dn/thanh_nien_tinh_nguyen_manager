package com.haivn.mapper;

import com.haivn.common_api.LopHoc;
import com.haivn.dto.LopHocDto;
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
public class LopHocMapperImpl implements LopHocMapper {

    @Override
    public LopHoc toEntity(LopHocDto dto) {
        if ( dto == null ) {
            return null;
        }

        LopHoc lopHoc = new LopHoc();

        lopHoc.setCreatedDate( dto.getCreatedDate() );
        lopHoc.setCreatedUser( dto.getCreatedUser() );
        lopHoc.setDeleted( dto.isDeleted() );
        lopHoc.setId( dto.getId() );
        lopHoc.setModifiedDate( dto.getModifiedDate() );
        lopHoc.setModifiedUser( dto.getModifiedUser() );
        lopHoc.setEmailChuNhiem( dto.getEmailChuNhiem() );
        lopHoc.setKhoa( dto.getKhoa() );
        lopHoc.setName( dto.getName() );
        lopHoc.setSdtChuNhiem( dto.getSdtChuNhiem() );
        lopHoc.setStatus( dto.getStatus() );
        lopHoc.setTenChuNhiem( dto.getTenChuNhiem() );

        return lopHoc;
    }

    @Override
    public LopHocDto toDto(LopHoc entity) {
        if ( entity == null ) {
            return null;
        }

        LopHocDto lopHocDto = new LopHocDto();

        if ( entity.getCreatedDate() != null ) {
            lopHocDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        lopHocDto.setCreatedUser( entity.getCreatedUser() );
        lopHocDto.setDeleted( entity.isDeleted() );
        lopHocDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            lopHocDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        lopHocDto.setModifiedUser( entity.getModifiedUser() );
        lopHocDto.setEmailChuNhiem( entity.getEmailChuNhiem() );
        lopHocDto.setKhoa( entity.getKhoa() );
        lopHocDto.setName( entity.getName() );
        lopHocDto.setSdtChuNhiem( entity.getSdtChuNhiem() );
        lopHocDto.setStatus( entity.getStatus() );
        lopHocDto.setTenChuNhiem( entity.getTenChuNhiem() );

        return lopHocDto;
    }

    @Override
    public List<LopHoc> toEntity(List<LopHocDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<LopHoc> list = new ArrayList<LopHoc>( dtoList.size() );
        for ( LopHocDto lopHocDto : dtoList ) {
            list.add( toEntity( lopHocDto ) );
        }

        return list;
    }

    @Override
    public List<LopHocDto> toDto(List<LopHoc> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<LopHocDto> list = new ArrayList<LopHocDto>( entityList.size() );
        for ( LopHoc lopHoc : entityList ) {
            list.add( toDto( lopHoc ) );
        }

        return list;
    }

    @Override
    public Set<LopHocDto> toDto(Set<LopHoc> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<LopHocDto> set = new LinkedHashSet<LopHocDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( LopHoc lopHoc : entityList ) {
            set.add( toDto( lopHoc ) );
        }

        return set;
    }
}

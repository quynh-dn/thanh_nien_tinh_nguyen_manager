package com.haivn.mapper;

import com.haivn.common_api.TnvPtsk;
import com.haivn.dto.TnvPtskDto;
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
public class TnvPtskMapperImpl implements TnvPtskMapper {

    @Override
    public TnvPtsk toEntity(TnvPtskDto dto) {
        if ( dto == null ) {
            return null;
        }

        TnvPtsk tnvPtsk = new TnvPtsk();

        tnvPtsk.setCreatedDate( dto.getCreatedDate() );
        tnvPtsk.setCreatedUser( dto.getCreatedUser() );
        tnvPtsk.setDeleted( dto.isDeleted() );
        tnvPtsk.setId( dto.getId() );
        tnvPtsk.setModifiedDate( dto.getModifiedDate() );
        tnvPtsk.setModifiedUser( dto.getModifiedUser() );
        tnvPtsk.setIdPtsk( dto.getIdPtsk() );
        tnvPtsk.setIdTnv( dto.getIdTnv() );
        tnvPtsk.setNguoiDung( dto.getNguoiDung() );
        tnvPtsk.setPhongTraoSuKien( dto.getPhongTraoSuKien() );
        tnvPtsk.setStatus( dto.getStatus() );

        return tnvPtsk;
    }

    @Override
    public TnvPtskDto toDto(TnvPtsk entity) {
        if ( entity == null ) {
            return null;
        }

        TnvPtskDto tnvPtskDto = new TnvPtskDto();

        if ( entity.getCreatedDate() != null ) {
            tnvPtskDto.setCreatedDate( new Timestamp( entity.getCreatedDate().getTime() ) );
        }
        tnvPtskDto.setCreatedUser( entity.getCreatedUser() );
        tnvPtskDto.setDeleted( entity.isDeleted() );
        tnvPtskDto.setId( entity.getId() );
        if ( entity.getModifiedDate() != null ) {
            tnvPtskDto.setModifiedDate( new Timestamp( entity.getModifiedDate().getTime() ) );
        }
        tnvPtskDto.setModifiedUser( entity.getModifiedUser() );
        tnvPtskDto.setIdPtsk( entity.getIdPtsk() );
        tnvPtskDto.setIdTnv( entity.getIdTnv() );
        tnvPtskDto.setNguoiDung( entity.getNguoiDung() );
        tnvPtskDto.setPhongTraoSuKien( entity.getPhongTraoSuKien() );
        tnvPtskDto.setStatus( entity.getStatus() );

        return tnvPtskDto;
    }

    @Override
    public List<TnvPtsk> toEntity(List<TnvPtskDto> dtoList) {
        if ( dtoList == null ) {
            return null;
        }

        List<TnvPtsk> list = new ArrayList<TnvPtsk>( dtoList.size() );
        for ( TnvPtskDto tnvPtskDto : dtoList ) {
            list.add( toEntity( tnvPtskDto ) );
        }

        return list;
    }

    @Override
    public List<TnvPtskDto> toDto(List<TnvPtsk> entityList) {
        if ( entityList == null ) {
            return null;
        }

        List<TnvPtskDto> list = new ArrayList<TnvPtskDto>( entityList.size() );
        for ( TnvPtsk tnvPtsk : entityList ) {
            list.add( toDto( tnvPtsk ) );
        }

        return list;
    }

    @Override
    public Set<TnvPtskDto> toDto(Set<TnvPtsk> entityList) {
        if ( entityList == null ) {
            return null;
        }

        Set<TnvPtskDto> set = new LinkedHashSet<TnvPtskDto>( Math.max( (int) ( entityList.size() / .75f ) + 1, 16 ) );
        for ( TnvPtsk tnvPtsk : entityList ) {
            set.add( toDto( tnvPtsk ) );
        }

        return set;
    }
}

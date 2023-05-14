package com.haivn.service;

import com.haivn.common_api.TnvPtsk;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.TnvPtskDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.TnvPtskMapper;
import com.haivn.repository.TnvPtskRepository;
import com.turkraft.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional
public class TnvPtskService {
    private final TnvPtskRepository repository;
    private final TnvPtskMapper tnvPtskMapper;

    public TnvPtskService(TnvPtskRepository repository, TnvPtskMapper tnvPtskMapper) {
        this.repository = repository;
        this.tnvPtskMapper = tnvPtskMapper;
    }

    public TnvPtskDto save(TnvPtskDto tnvPtskDto) {
        TnvPtsk entity = tnvPtskMapper.toEntity(tnvPtskDto);
        return tnvPtskMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public TnvPtskDto findById(Long id) {
        return tnvPtskMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<TnvPtskDto> findByCondition(@Filter Specification<TnvPtsk> spec, Pageable pageable) {
        Page<TnvPtsk> entityPage = repository.findAll(spec,pageable);
        List<TnvPtsk> entities = entityPage.getContent();
        return new PageImpl<>(tnvPtskMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public TnvPtskDto update(TnvPtskDto tnvPtskDto, Long id) {
        TnvPtskDto data = findById(id);
        TnvPtsk entity = tnvPtskMapper.toEntity(tnvPtskDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(tnvPtskMapper.toDto(entity));
    }
    public List<TnvPtskDto> findByIdPtskAndStatus (Long idPtsk,Short status){
        List<TnvPtsk> entities = repository.findByIdPtskAndStatus(idPtsk,status);
        return tnvPtskMapper.toDto(entities);
    }
}
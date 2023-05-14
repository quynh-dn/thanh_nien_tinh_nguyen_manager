package com.haivn.service;

import com.haivn.common_api.ChucVu;
import com.haivn.dto.ChucVuDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.ChucVuMapper;
import com.haivn.repository.ChucVuRepository;
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
public class ChucVuService {
    private final ChucVuRepository repository;
    private final ChucVuMapper chucVuMapper;

    public ChucVuService(ChucVuRepository repository, ChucVuMapper chucVuMapper) {
        this.repository = repository;
        this.chucVuMapper = chucVuMapper;
    }

    public ChucVuDto save(ChucVuDto chucVuDto) {
        ChucVu entity = chucVuMapper.toEntity(chucVuDto);
        return chucVuMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public ChucVuDto findById(Long id) {
        return chucVuMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<ChucVuDto> findByCondition(@Filter Specification<ChucVu> spec, Pageable pageable) {
        Page<ChucVu> entityPage = repository.findAll(spec,pageable);
        List<ChucVu> entities = entityPage.getContent();
        return new PageImpl<>(chucVuMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public ChucVuDto update(ChucVuDto chucVuDto, Long id) {
        ChucVuDto data = findById(id);
        ChucVu entity = chucVuMapper.toEntity(chucVuDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(chucVuMapper.toDto(entity));
    }
}
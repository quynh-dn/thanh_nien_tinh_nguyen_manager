package com.haivn.service;

import com.haivn.common_api.PhongTraoSuKien;
import com.haivn.dto.LopHocDto;
import com.haivn.dto.PhongTraoSuKienDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.PhongTraoSuKienMapper;
import com.haivn.repository.PhongTraoSuKienRepository;
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
public class PhongTraoSuKienService {
    private final PhongTraoSuKienRepository repository;
    private final PhongTraoSuKienMapper phongTraoSuKienMapper;

    public PhongTraoSuKienService(PhongTraoSuKienRepository repository, PhongTraoSuKienMapper phongTraoSuKienMapper) {
        this.repository = repository;
        this.phongTraoSuKienMapper = phongTraoSuKienMapper;
    }

    public PhongTraoSuKienDto save(PhongTraoSuKienDto phongTraoSuKienDto) {
        PhongTraoSuKien entity = phongTraoSuKienMapper.toEntity(phongTraoSuKienDto);
        return phongTraoSuKienMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public PhongTraoSuKienDto findById(Long id) {
        return phongTraoSuKienMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<PhongTraoSuKienDto> findByCondition(@Filter Specification<PhongTraoSuKien> spec, Pageable pageable) {
        Page<PhongTraoSuKien> entityPage = repository.findAll(spec,pageable);
        List<PhongTraoSuKien> entities = entityPage.getContent();
        return new PageImpl<>(phongTraoSuKienMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public PhongTraoSuKienDto update(PhongTraoSuKienDto phongTraoSuKienDto, Long id) {
        PhongTraoSuKienDto data = findById(id);
        PhongTraoSuKien entity = phongTraoSuKienMapper.toEntity(phongTraoSuKienDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(phongTraoSuKienMapper.toDto(entity));
    }
}
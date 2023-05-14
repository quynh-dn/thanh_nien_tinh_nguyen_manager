package com.haivn.service;

import com.haivn.common_api.SinhVienDangKy;
import com.haivn.dto.ChucVuDto;
import com.haivn.dto.SinhVienDangKyDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.SinhVienDangKyMapper;
import com.haivn.repository.SinhVienDangKyRepository;
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
public class SinhVienDangKyService {
    private final SinhVienDangKyRepository repository;
    private final SinhVienDangKyMapper sinhVienDangKyMapper;

    public SinhVienDangKyService(SinhVienDangKyRepository repository, SinhVienDangKyMapper sinhVienDangKyMapper) {
        this.repository = repository;
        this.sinhVienDangKyMapper = sinhVienDangKyMapper;
    }

    public SinhVienDangKyDto save(SinhVienDangKyDto sinhVienDangKyDto) {
        SinhVienDangKy entity = sinhVienDangKyMapper.toEntity(sinhVienDangKyDto);
        return sinhVienDangKyMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public SinhVienDangKyDto findById(Long id) {
        return sinhVienDangKyMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<SinhVienDangKyDto> findByCondition(@Filter Specification<SinhVienDangKy> spec, Pageable pageable) {
        Page<SinhVienDangKy> entityPage = repository.findAll(spec,pageable);
        List<SinhVienDangKy> entities = entityPage.getContent();
        return new PageImpl<>(sinhVienDangKyMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public SinhVienDangKyDto update(SinhVienDangKyDto sinhVienDangKyDto, Long id) {
        SinhVienDangKyDto data = findById(id);
        SinhVienDangKy entity = sinhVienDangKyMapper.toEntity(sinhVienDangKyDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(sinhVienDangKyMapper.toDto(entity));
    }

    public List<SinhVienDangKyDto> fillByStatus(Short status){
        List<SinhVienDangKy> entities = repository.findByStatus(status);
        return sinhVienDangKyMapper.toDto(entities);
    }
}
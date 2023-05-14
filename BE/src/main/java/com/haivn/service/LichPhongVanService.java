package com.haivn.service;

import com.haivn.common_api.LichPhongVan;
import com.haivn.dto.LichPhongVanDto;
import com.haivn.dto.LopHocDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.LichPhongVanMapper;
import com.haivn.repository.LichPhongVanRepository;
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
public class LichPhongVanService {
    private final LichPhongVanRepository repository;
    private final LichPhongVanMapper lichPhongVanMapper;

    public LichPhongVanService(LichPhongVanRepository repository, LichPhongVanMapper lichPhongVanMapper) {
        this.repository = repository;
        this.lichPhongVanMapper = lichPhongVanMapper;
    }

    public LichPhongVanDto save(LichPhongVanDto lichPhongVanDto) {
        LichPhongVan entity = lichPhongVanMapper.toEntity(lichPhongVanDto);
        return lichPhongVanMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public LichPhongVanDto findById(Long id) {
        return lichPhongVanMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<LichPhongVanDto> findByCondition(@Filter Specification<LichPhongVan> spec, Pageable pageable) {
        Page<LichPhongVan> entityPage = repository.findAll(spec,pageable);
        List<LichPhongVan> entities = entityPage.getContent();
        return new PageImpl<>(lichPhongVanMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public LichPhongVanDto update(LichPhongVanDto lichPhongVanDto, Long id) {
        LichPhongVanDto data = findById(id);
        LichPhongVan entity = lichPhongVanMapper.toEntity(lichPhongVanDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(lichPhongVanMapper.toDto(entity));
    }
}
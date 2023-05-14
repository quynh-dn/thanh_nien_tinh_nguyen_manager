package com.haivn.service;

import com.haivn.common_api.Poster;
import com.haivn.dto.LopHocDto;
import com.haivn.dto.PosterDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.PosterMapper;
import com.haivn.repository.PosterRepository;
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
public class PosterService {
    private final PosterRepository repository;
    private final PosterMapper posterMapper;

    public PosterService(PosterRepository repository, PosterMapper posterMapper) {
        this.repository = repository;
        this.posterMapper = posterMapper;
    }

    public PosterDto save(PosterDto posterDto) {
        Poster entity = posterMapper.toEntity(posterDto);
        return posterMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public PosterDto findById(Long id) {
        return posterMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<PosterDto> findByCondition(@Filter Specification<Poster> spec, Pageable pageable) {
        Page<Poster> entityPage = repository.findAll(spec,pageable);
        List<Poster> entities = entityPage.getContent();
        return new PageImpl<>(posterMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public PosterDto update(PosterDto posterDto, Long id) {
        PosterDto data = findById(id);
        Poster entity = posterMapper.toEntity(posterDto);
        BeanUtils.copyProperties(entity, data, Utils.getNullPropertyNames(entity));
        return save(posterMapper.toDto(entity));
    }
}
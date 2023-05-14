package com.haivn.controller;

import com.google.common.base.Strings;
import com.haivn.common_api.LopHoc;
import com.haivn.common_api.Poster;
import com.haivn.dto.LopHocDto;
import com.haivn.dto.PosterDto;
import com.haivn.mapper.PosterMapper;
import com.haivn.service.PosterService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.FileSystemAlreadyExistsException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/poster")
@RestController
@Slf4j
@Api("poster")
public class PosterController {
    private final PosterService posterService;

    public PosterController(PosterService posterService) {
        this.posterService = posterService;
    }

    @PostMapping("/post")
    public ResponseEntity< Map<String, Object>> save(@RequestBody @Validated PosterDto posterDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            PosterDto item = posterService.save(posterDto);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            PosterDto poster = posterService.findById(id);
            result.put("result",poster);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(posterService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemAlreadyExistsException();
        });
        posterService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity< Map<String, Object>> pageQuery(@Filter Specification<Poster> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<PosterDto> posterPage = posterService.findByCondition(spec, pageable);
            result.put("result", posterPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity< Map<String, Object>> update(@RequestBody @Validated PosterDto posterDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            posterDto.setId(id);
            PosterDto item =posterService.update(posterDto, id);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}
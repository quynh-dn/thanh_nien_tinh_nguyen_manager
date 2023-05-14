package com.haivn.repository;

import com.haivn.common_api.LichPhongVan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface LichPhongVanRepository extends JpaRepository<LichPhongVan, Long>, JpaSpecificationExecutor<LichPhongVan> {
}
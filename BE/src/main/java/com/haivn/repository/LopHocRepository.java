package com.haivn.repository;

import com.haivn.common_api.LopHoc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface LopHocRepository extends JpaRepository<LopHoc, Long>, JpaSpecificationExecutor<LopHoc> {
}
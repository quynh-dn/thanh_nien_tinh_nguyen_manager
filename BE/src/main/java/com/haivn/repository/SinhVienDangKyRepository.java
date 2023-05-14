package com.haivn.repository;

import com.haivn.common_api.SinhVienDangKy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SinhVienDangKyRepository extends JpaRepository<SinhVienDangKy, Long>, JpaSpecificationExecutor<SinhVienDangKy> {
    List<SinhVienDangKy> findByStatus(Short status);
}
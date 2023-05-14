package com.haivn.repository;

import com.haivn.common_api.PhongTraoSuKien;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PhongTraoSuKienRepository extends JpaRepository<PhongTraoSuKien, Long>, JpaSpecificationExecutor<PhongTraoSuKien> {
}
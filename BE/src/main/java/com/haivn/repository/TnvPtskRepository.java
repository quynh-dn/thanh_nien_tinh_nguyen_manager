package com.haivn.repository;

import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.TnvPtsk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TnvPtskRepository extends JpaRepository<TnvPtsk, Long>, JpaSpecificationExecutor<TnvPtsk> {
    List<TnvPtsk> findByIdPtskAndStatus(Long idPtsk, Short status);
}
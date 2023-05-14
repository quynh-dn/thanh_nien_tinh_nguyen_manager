package com.haivn.repository;

import com.haivn.common_api.NguoiDung;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface NguoiDungRepository extends JpaRepository<NguoiDung, Long>, JpaSpecificationExecutor<NguoiDung> {
    NguoiDung findByEmail(String email);

    NguoiDung findByUsername(String username);
    NguoiDung findByEmailAndPassword(String email, String password);
}
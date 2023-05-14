package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "phong_trao_su_kien")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class PhongTraoSuKien extends BaseEntity{
    @Column(name = "title")
    private String title;
    @Column(name = "content")
    private String content;
    @Column(name = "poster")
    private String poster;
    @Column(name = "start_date")
    private Timestamp startDate;
    @Column(name = "end_date")
    private Timestamp endDate;
    @Column(name = "dia_diem")
    private String diaDiem;
    @Column(name = "kinh_phi")
    private String kinhPhi;
    @Column(name = "nguoi_phu_trach")
    private String nguoiPhuTrach;
    @Column(name = "file_dinh_kem")
    private String fileDinhKiem;
    @Column(name = "so_luong_ho_tro")
    private Short soLuongHoTro;
    @Column(name = "status")
    private Short status;
}

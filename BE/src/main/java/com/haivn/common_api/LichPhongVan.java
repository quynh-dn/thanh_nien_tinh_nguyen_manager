package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "lich_phong_van")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class LichPhongVan extends BaseEntity{
    @Column(name = "title")
    private String title;
    @Column(name = "content")
    private String content;
    @Column(name = "thoi_gian")
    private Timestamp thoiGian;
    @Column(name = "dia_diem")
    private String diaDiem;
    @Column(name = "thanh_phan_tham_du")
    private String thanhPhanThamDu;
    @Column(name = "sinh_vien_pv")
    private String sinhVienPv;
    @Column(name = "status")
    private Short status;
}

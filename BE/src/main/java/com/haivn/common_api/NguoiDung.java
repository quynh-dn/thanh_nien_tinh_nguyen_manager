package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "nguoi_dung")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class NguoiDung extends BaseEntity{
    @Column(name = "user_name")
    private String username;
    @Column(name = "password")
    private String password;
    @Column(name = "role")
    private Short role;
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "ma_sv")
    private String maSV;
    @Column(name = "id_lop")
    private Long idLop;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_lop",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private LopHoc lopHoc;
    @Column(name = "ngay_sinh")
    private Timestamp ngaySinh;
    @Column(name = "dia_chi")
    private String diaChi;
    @Column(name = "gioi_tinh")
    private Boolean gioiTinh;
    @Column(name = "email")
    private String email;
    @Column(name = "sdt")
    private String sdt;
    @Column(name = "ngay_vao")
    private Timestamp ngayVao;
    @Column(name = "id_chuc_vu")
    private Long idChucVu;
    @Column(name = "avatar")
    private String avatar;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_chuc_vu",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private ChucVu chucVu;
    @Column(name = "status")
    private Short status;
}

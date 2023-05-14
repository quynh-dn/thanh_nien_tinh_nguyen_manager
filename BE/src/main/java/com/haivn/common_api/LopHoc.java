package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "lop_hoc")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class LopHoc extends BaseEntity{
    @Column(name = "name")
    private String name;
    @Column(name = "khoa")
    private String khoa;
    @Column(name = "ten_chu_nhiem")
    private String tenChuNhiem;
    @Column(name = "sdt_chu_nhiem")
    private String sdtChuNhiem;
    @Column(name = "email_chu_nhiem")
    private String emailChuNhiem;
    @Column(name = "status")
    private Short status;

}

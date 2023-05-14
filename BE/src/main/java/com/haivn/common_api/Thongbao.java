package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "thong_bao")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class Thongbao extends BaseEntity{
    @Column(name = "noi_dung")
    private String noiDung;
    @Column(name = "title")
    private String title;
    @Column(name = "status")
    private Short status;
}

package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "tnv_ptsk")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class TnvPtsk extends BaseEntity{
    @Column(name = "id_tnv")
    private Long idTnv;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_tnv",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nguoiDung;
    @Column(name = "id_ptsk")
    private Long idPtsk;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="id_ptsk",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private PhongTraoSuKien phongTraoSuKien;
    @Column(name = "status")
    private Short status;
}

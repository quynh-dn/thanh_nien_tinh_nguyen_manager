package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "chuc_vu")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class ChucVu extends BaseEntity{
    @Column(name = "name")
    private String name;
    @Column(name = "level")
    private Short level;
    @Column(name = "status")
    private Short status;

}

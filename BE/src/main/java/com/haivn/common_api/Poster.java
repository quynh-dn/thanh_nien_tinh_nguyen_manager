package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "poster")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class Poster extends BaseEntity{
    @Column(name = "name")
    private String name;
    @Column(name = "file_name")
    private String fileName;
    @Column(name = "stt")
    private Short stt;
    @Column(name = "status")
    private Short status;
}

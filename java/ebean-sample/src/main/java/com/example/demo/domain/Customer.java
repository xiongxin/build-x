package com.example.demo.domain;


import io.ebean.Model;
import io.ebean.annotation.Length;
import io.ebean.annotation.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@ToString(callSuper = true)
public class Customer extends BaseDomain {

    @NotNull @Length(3)
    String name;

    LocalDate registered;
}

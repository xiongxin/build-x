package com.example.demo.domain;


import io.ebean.Model;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Setter
@ToString
public class Customer extends Model {

    @Id
    long id;

    String name;
}

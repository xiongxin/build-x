package com.example.demo;

import com.example.demo.domain.Customer;

import java.time.Instant;
import java.time.LocalDate;

public class P02 {

    public static void main(String[] args) {
        Customer customer = new Customer();
//        customer.setId(5);
        customer.setRegistered(LocalDate.now());
        customer.setName("11abcedf");
//        customer.setWhenCreated(Instant.now());
//        customer.setWhenModified(Instant.now());
        customer.save();
    }
}

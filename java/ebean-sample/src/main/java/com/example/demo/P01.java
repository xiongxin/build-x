package com.example.demo;

import com.example.demo.domain.Customer;
import com.example.demo.domain.query.QCustomer;
import io.ebean.DB;

import java.util.List;


public class P01 {

    public static void main(String[] args) {
        List<Customer> customerList = DB.getDefault()
                .find(Customer.class)
                .findList();

        customerList.forEach(System.out::println);
        System.out.println("=====");
        List<Customer> customers = new QCustomer()
                .name.equalTo("abc")
                .findList();
        customers.forEach(System.out::println);

        //
    }
}

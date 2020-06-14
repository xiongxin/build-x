package com.example.demo;

import com.example.demo.domain.Customer;
import com.example.demo.domain.query.QCustomer;

import java.util.List;

public class P03 {

    public static void main(String[] args) {
        List<String> names = new QCustomer()
                .select("concat(id, ',', name)")
                .findSingleAttributeList();
        var a = "abc";
        names.forEach(System.out::println);
        System.out.println("============");
        List<Customer> customers = new QCustomer()
                .raw("id > ?", 5)
                .findList();
        customers.forEach(System.out::println);
        System.out.println("============");
        List<Customer> customers1 = new QCustomer()
                .name.startsWith("11")
                .findList();
        customers1.forEach(System.out::println);
        System.out.println("============");
    }
}

package com.example.demo;

import com.example.demo.domain.Customer;
import com.example.demo.domain.query.QCustomer;
import io.ebean.DB;
import io.ebean.Database;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Random;

public class P00 {

    public static void main(String[] args) {
//        Customer customer = new Customer();
//        customer.setName("a11bcdd");
//        customer.save();
//        Database database = DB.getDefault();
//        database.save(customer);
//
//        List<Customer> customerList = database.find(Customer.class)
//                .findList();
//
//        customerList.forEach(System.out::println);

        Customer customer = new QCustomer().name.equalTo("abc").findOne();
        System.out.println(customer);
    }
}

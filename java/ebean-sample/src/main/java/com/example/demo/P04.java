package com.example.demo;

import com.example.demo.domain.Customer;
import com.example.demo.domain.query.QCustomer;
import io.ebean.DB;
import io.ebean.SqlRow;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

public class P04 {

    public static void main(String[] args) {
        String sql = "SELECT id, name FROM customer";

        List<SqlRow> rows = DB.sqlQuery(sql)
                .setMaxRows(2)
                .setFirstRow(2)
                .findList();

        for (SqlRow sqlRow : rows) {
            Long id = sqlRow.getLong("id");
            String name = sqlRow.getString("name");

            System.out.println(id +" " + name);
        }

        LocalDate localDate = LocalDate.now();
        localDate.minusDays(7);
    }
}

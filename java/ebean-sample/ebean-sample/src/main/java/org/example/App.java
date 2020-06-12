package org.example;

import io.ebean.DB;
import io.ebean.Database;
import org.example.domain.Customer;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {

        Database database = DB.getDefault();

        Customer customer = new Customer();
        customer.setName("abc");

        database.save(customer);
        
        System.out.println(customer.getId());
    }
}

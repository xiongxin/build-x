package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonView;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import lombok.Data;
import lombok.ToString;

import java.time.ZonedDateTime;
import java.util.Date;

public class JsonViewAnnotation {

  private static class Views {
    private interface QuickContact {}
    private interface SummaryView {}
  }

  @Data
  @ToString
  private static class Customer {
    @JsonView({Views.SummaryView.class, Views.QuickContact.class})
    private String name;
    @JsonView(Views.SummaryView.class)
    private String address;
    private String phone;
    @JsonView(Views.QuickContact.class)
    private String cellPhone;
    private String emailAddress;

    @JsonView(Views.SummaryView.class)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy/MM/dd")
    private Date customerSince;
  }


  public static void main(String[] args) throws JsonProcessingException {
    Customer customer = new Customer();
    customer.setName("Emily");
    customer.setAddress("642 Buckhannan Avenue Stratford");
    customer.setPhone("111-111-111");
    customer.setCellPhone("222-222-222");
    customer.setCustomerSince(Date.from(ZonedDateTime.now().minusYears(8).toInstant()));
    customer.setEmailAddress("emily@example.com");

    System.out.println("-- before serialization --");
    System.out.println(customer);
    ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
    objectMapper.disable(MapperFeature.DEFAULT_VIEW_INCLUSION);
    String jsonStr = objectMapper.writerWithView(Views.SummaryView.class).writeValueAsString(customer);
    System.out.println("-- after serialization --");
    System.out.println(jsonStr);
  }
}

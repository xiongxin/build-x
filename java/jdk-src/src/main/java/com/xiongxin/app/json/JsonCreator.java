package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.ToString;

public class JsonCreator {


  @Data
  @ToString
  private static class Employee {
    private String name;
    private String dept;

    @com.fasterxml.jackson.annotation.JsonCreator
    public Employee(@JsonProperty("name") String name, @JsonProperty("dept") String dept) {
      System.out.println("'constructor invoked!'");
      this.name = name;
      this.dept = dept;
    }
  }


  public static void main(String[] args) throws JsonProcessingException {
    System.out.println("-- writing --");
    Employee employee = new Employee("Trish", "Admin");

    ObjectMapper objectMapper = new ObjectMapper();

    String jsonString = objectMapper.writeValueAsString(employee);

    System.out.println(jsonString);
    System.out.println("-- reading --");
    Employee employee1 = objectMapper.readValue(jsonString, Employee.class);
    System.out.println(employee1);
  }
}

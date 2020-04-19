package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import lombok.Data;

import java.util.Date;

public class RenameingProperties {

  @Data
  public static final class Employee {
    @JsonSetter(nulls = Nulls.AS_EMPTY)
    private String name;

    @JsonProperty("employee-dept")
    private String dept;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date date;

    @JsonSetter(nulls = Nulls.AS_EMPTY)
    private Integer age;
  }

  public static void main(String[] args) throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
    Employee employee = new Employee();
    employee.setName("Trish");
    employee.setDept("Admin");
    employee.setDate(new Date());

    String jsonStr = objectMapper.writeValueAsString(employee);

    System.out.println(jsonStr);

    String jsonString = "{\"name\":null, \"age\": null}";
    System.out.println(jsonString);
    //convert to Person
    Employee person = objectMapper.readValue(jsonString, Employee.class);
    System.out.println(person);
  }
}

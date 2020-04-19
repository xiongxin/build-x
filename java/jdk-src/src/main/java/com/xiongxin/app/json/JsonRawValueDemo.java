package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonRawValue;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;

public class JsonRawValueDemo {

  @Data
  private static class Report {
    private long id;
    private String name;
    @JsonRawValue
    private String content;
  }


  public static void main(String[] args) throws JsonProcessingException {
    Report r = new Report();
    r.setId(1);
    r.setName("Test report");
    r.setContent("{\"author\":\"Peter\", \"content\":\"Test content\"}");

    System.out.println("-- before serialization --");
    System.out.println(r);

    ObjectMapper objectMapper = new ObjectMapper();
    System.out.println("-- after serialization --");
    System.out.println(objectMapper.writeValueAsString(r));
  }
}

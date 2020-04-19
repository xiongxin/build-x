package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class JacksonAnySetter {

  @Data
  private static class ScreenInfo {
    private String id;
    private String title;
    private int width;
    private int height;
    private Map<String, Object> otherInfo;


    @JsonAnySetter
    public void addOtherInof(String propertyKey, Object value) {
      if (Objects.isNull(otherInfo)) {
        this.otherInfo = new HashMap<>();
      }

      this.otherInfo.put(propertyKey, value);
    }
  }

  public static void main(String[] args) throws JsonProcessingException {
    String jsonString = "{\"id\":\"TradeDetails\",\"title\":\"Trade Details\","
            + "\"width\":500,\"height\":300,\"xLocation\":400,\"yLocation\":200}";

    System.out.println("-- before deserialization --");
    System.out.println(jsonString);

    ObjectMapper om = new ObjectMapper();
    ScreenInfo screenInfo = om.readValue(jsonString, ScreenInfo.class);

    System.out.println("-- after deserialization --");
    System.out.println(screenInfo);
  }
}

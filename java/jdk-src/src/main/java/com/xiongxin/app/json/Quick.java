package com.xiongxin.app.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Quick {

  @Data
  @NoArgsConstructor
  @ToString
  public static class MyObject {
    private int intVal;
    private String stringVal;
    private List<String> list;
  }


  public static void main(String[] args) throws JsonProcessingException {
    ObjectMapper om = new ObjectMapper();

    Map<String, Integer> map = new HashMap<String, Integer>(){{
      this.put("one", 1);
      this.put("two", 2);
    }};

    String s = om.writeValueAsString(map);

    System.out.println(s);

    Map jsonMap = om.readValue(s, Map.class);

    System.out.println(jsonMap.getOrDefault("one", 1));


    MyObject pojo = new MyObject();
    pojo.setIntVal(3);
    pojo.setStringVal("test string");
    pojo.setList(new ArrayList(){{this.add("item1");this.add("item2");}});
    s = om.writeValueAsString(pojo);
    System.out.println(s);

    MyObject myObject = om.readValue(s, MyObject.class);
    System.out.println(myObject);

    s = "[{\"intVal\":3,\"list\":[\"item1\",\"item2\"],\"stringVal\":\"test string\"}]";
    List<MyObject> list = om.readValue(s, new TypeReference<List<MyObject>>() {});

    TypeReference typeReference = new TypeReference<List<MyObject>>() {};
    Type superClass = typeReference.getClass().getGenericSuperclass();
    if (superClass instanceof Class<?>) { // sanity check, should never happen
      throw new IllegalArgumentException("Internal error: TypeReference constructed without actual type information");
    }
    /* 22-Dec-2008, tatu: Not sure if this case is safe -- I suspect
     *   it is possible to make it fail?
     *   But let's deal with specific
     *   case when we know an actual use case, and thereby suitable
     *   workarounds for valid case(s) and/or error to throw
     *   on invalid one(s).
     */
    System.out.println(((ParameterizedType) superClass).getActualTypeArguments()[0]);
  }
}

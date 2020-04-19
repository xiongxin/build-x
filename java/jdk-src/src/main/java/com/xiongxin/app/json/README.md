# Jackson笔记

## 处理泛型问题

利用`TypeReference`处理

```java
String s = "[{\"intVal\":3,\"list\":[\"item1\",\"item2\"],\"stringVal\":\"test string\"}]";
ObjectMapper om = new ObjectMapper();
List<MyObject> list = om.readValue(s, new TypeReference<List<MyObject>>() { });
System.out.println(list.get(0));
System.out.println(list.get(0).getClass());
```

## 常用配置

建议有点的以设置成全局属性，方便开发，看具体情况。

- `om.enable(SerializationFeature.INDENT_OUTPUT);`开启缩进
- `om.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);` 属性未知时，取消失败
- `om.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);`对象没有属性时，取消序列化失败
- `om.enable(DeserializationFeature.ACCEPT_EMPTY_STRING_AS_NULL_OBJECT);` 开启空字符串转成null对象
- `om.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);` 取消序列化时讲日期转成时间戳

## 重命名属性

- @JsonProperty
- @JsonGetter
- @JsonSetter 该属性对于Null处理有好几种方式，public enum Nulls {
                                  SET,
                                  SKIP,
                                  FAIL,
                                  AS_EMPTY,
                                  DEFAULT;
                                  private Nulls() {
                                  }
                                }，例如AS_EMPTY时，如果序列化为对象时，将转成空字符串
                                
  
## 使用 @JsonIgnore and @JsonIgnoreProperties 忽略属性

在序列化和反序列化时都会忽略

- @JsonIgnoreProperties#ignoreUnknown 忽略未知属性
- @JsonIgnore 忽略特定属性
- @JsonIgnoreProperties 忽略多个属性例如 `@JsonIgnoreProperties({"dept", "address"})`


## 使用 @JsonIgnoreType 会忽略整个class

## 使用 @JacksonInject 反序列化时注入值

我们可以使用类型和名称来注入

```java
package com.logicbig.example;

import com.fasterxml.jackson.annotation.JacksonInject;
import java.time.LocalDateTime;

public class CurrencyRate {
  private String pair;
  private double rate;
  @JacksonInject("lastUpdated")
  private LocalDateTime lastUpdated;
    .............
}



```

## 使用@JsonPropertyOrder指定顺序

例如
```java
@JsonPropertyOrder({"name", "phoneNumber","email", "salary", "id" })
public class Employee {
  private String id;
  private String name;
  private int salary;
  private String phoneNumber;
  private String email;
    .............
}
```

也可以使用在属性的Map或class对象
```java
@JsonPropertyOrder({"otherDetails", "name"})
public class Project {
  private String name;
  @JsonPropertyOrder(alphabetic = true)
  private Map<String, String> otherDetails;
    .............
}
```

## 使用@JsonAlias反序列化名称

```java
package com.logicbig.example;

import com.fasterxml.jackson.annotation.JsonAlias;

public class Employee {
  private String name;
  @JsonAlias({"department", "employeeDept" })
  private String dept;
    .............
}

public class ExampleMain {
  public static void main(String[] args) throws IOException {
      ObjectMapper om = new ObjectMapper();
      System.out.println("-- deserializing --");
      String jsonData = "{\"name\":\"Trish\",\"department\":\"IT\"}";
      Employee employee = om.readValue(jsonData, Employee.class);
      System.out.println(employee);

      jsonData = "{\"name\":\"Trish\",\"employeeDept\":\"IT\"}";
      employee = om.readValue(jsonData, Employee.class);
      System.out.println(employee);

      System.out.println("-- serializing --");
      Employee e = Employee.of("Jake", "Admin");
      String s = om.writeValueAsString(e);
      System.out.println(s);
  }
}
```

结果

```
-- deserializing --
Employee{name='Trish', dept='IT'}
Employee{name='Trish', dept='IT'}
-- serializing --
{"name":"Jake","dept":"Admin"}
```


## @JsonCreator 指定使用我们当前的构造方法或工厂方法

```java
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

```

运行结果

```
-- writing --
'constructor invoked!'
{"name":"Trish","dept":"Admin"}
-- reading --
'constructor invoked!'
JsonCreator.Employee(name=Trish, dept=Admin)
```

更加方便的可以使用 `@ConstructorProperties({"name", "dept"})`
https://www.logicbig.com/tutorials/misc/jackson/constructor-properties.html


## 使用@JsonSerialize and @JsonDeserialize自定义序列化和解序列化

```java
package com.xiongxin.app.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.util.StdConverter;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.Locale;

public class JsonSerializeDeserializeConverter {

  @Data
  private static class CurrencyRate {
    private String pair;
    private double rate;

    @JsonSerialize(converter = LocalDateTimeToStringConverter.class)
    @JsonDeserialize(converter = StringToLocalDatetimeConverter.class)
    private LocalDateTime lastUpdated;
  }

  private static class LocalDateTimeToStringConverter extends StdConverter<LocalDateTime, String> {

    static final DateTimeFormatter DATE_TIME_FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.CHINA);

    @Override
    public String convert(LocalDateTime localDateTime) {
      System.out.println(localDateTime.format(DATE_TIME_FORMATTER));
      return localDateTime.format(DATE_TIME_FORMATTER);
    }
  }

  private static class StringToLocalDatetimeConverter extends StdConverter<String, LocalDateTime> {

    @Override
    public LocalDateTime convert(String s) {
      return LocalDateTime.parse(s, LocalDateTimeToStringConverter.DATE_TIME_FORMATTER);
    }
  }


  public static void main(String[] args) throws JsonProcessingException {
    System.out.println("-- Java Object to JSON --");
    CurrencyRate currencyRate = new CurrencyRate();
    currencyRate.setPair("USD/JPY");
    currencyRate.setRate(109.15);
    currencyRate.setLastUpdated(LocalDateTime.now());
    System.out.println("Java Object: " + currencyRate);
    ObjectMapper objectMapper = new ObjectMapper();
    String str = objectMapper.writeValueAsString(currencyRate);
    System.out.println("JSON string: " + str);

    System.out.println("-- JSON to Java object --");
    CurrencyRate currencyRate1 = objectMapper.readValue(str, CurrencyRate.class);
    System.out.println("Java object: " + currencyRate1);
  }
}

```

结果

```
-- Java Object to JSON --
Java Object: JsonSerializeDeserializeConverter.CurrencyRate(pair=USD/JPY, rate=109.15, lastUpdated=2020-04-19T23:03:21.207)
2020-04-19 23:03:21
JSON string: {"pair":"USD/JPY","rate":109.15,"lastUpdated":"2020-04-19 23:03:21"}
-- JSON to Java object --
Java object: JsonSerializeDeserializeConverter.CurrencyRate(pair=USD/JPY, rate=109.15, lastUpdated=2020-04-19T23:03:21)
```

## 注册自定义阶序列化和序列化类

https://www.logicbig.com/tutorials/misc/jackson/custom-serializer-deserializer.html


## 使用@JsonTypeInfo补货多态类型

```java
package com.xiongxin.app.json;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Arrays;
import java.util.List;

public class JacksonJsonTypeInfoAnnotation {

  private static abstract class Shape {}

  @AllArgsConstructor
  @NoArgsConstructor
  private static class Rectangle extends Shape {
    private int w;
    private int h;

    public int getH() {
      return h;
    }

    public void setH(int h) {
      this.h = h;
    }

    public int getW() {
      return w;
    }

    public void setW(int w) {
      this.w = w;
    }

    @Override
    public String toString() {
      return "Rectangle{" +
              "w=" + w +
              ", h=" + h +
              '}';
    }
  }

  @AllArgsConstructor
  @NoArgsConstructor
  private static class Circle extends Shape {
    private int radius;

    public int getRadius() {
      return radius;
    }

    public void setRadius(int radius) {
      this.radius = radius;
    }

    @Override
    public String toString() {
      return "Circle{" +
              "radius=" + radius +
              '}';
    }
  }

  private static class View {
    @JsonTypeInfo(use = JsonTypeInfo.Id.MINIMAL_CLASS)
    private List<Shape> shapes;

    public List<Shape> getShapes() {
      return shapes;
    }

    public void setShapes(List<Shape> shapes) {
      this.shapes = shapes;
    }

    @Override
    public String toString() {
      return "View{" +
              "shapes=" + shapes +
              '}';
    }
  }

  public static void main(String[] args) throws JsonProcessingException {
    View v = new View();
    v.setShapes(Arrays.asList(new Rectangle(3, 6), new Circle(5)));

    System.out.println("-- serializing --");
    ObjectMapper om = new ObjectMapper();
    String s = om.writeValueAsString(v);
    System.out.println(s);

    System.out.println("-- deserializing --");
    View view = om.readValue(s, View.class);
    System.out.println(view);
  }
}

```

结果

```
-- serializing --
{"shapes":[{"@c":".JacksonJsonTypeInfoAnnotation$Rectangle","w":3,"h":6},{"@c":".JacksonJsonTypeInfoAnnotation$Circle","radius":5}]}
-- deserializing --
View{shapes=[Rectangle{w=3, h=6}, Circle{radius=5}]}
```


## @JsonView分组序列化和反序列化


注意：
如果使用视图方法序列化和反序列化的，字段只会出现使用注解序列化和反序列化的属性，此时可以使用@JsonView在类上面，使用默认注解
```java

@JsonView(Views.DetailedView.class)
public class Customer {
  @JsonView({Views.QuickContactView.class, Views.DetailedView.class})
  private String name;
  private String address;
  @JsonView({Views.QuickContactView.class})
  private String phone;
  @JsonView(Views.QuickContactView.class)
  private String cellPhone;
  private String emailAddress;
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy/MM/dd", timezone = "America/Chicago")
  private Date customerSince;
    .............
}
```

```java
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

```

运行结果

```
-- before serialization --
JsonViewAnnotation.Customer(name=Emily, address=642 Buckhannan Avenue Stratford, phone=111-111-111, cellPhone=222-222-222, emailAddress=emily@example.com, customerSince=Fri Apr 20 00:19:43 CST 2012)
-- after serialization --
{
  "name" : "Emily",
  "address" : "642 Buckhannan Avenue Stratford",
  "customerSince" : "2012/04/19"
}
```


## 使用@JsonFormat格式化日期和Enum


## 使用@JsonUnwrapped展开对象

```java
package com.logicbig.example;

public class Department {
  private String deptName;
  private String location;
    .............
}
```

```java
package com.logicbig.example;

import com.fasterxml.jackson.annotation.JsonUnwrapped;

public class Employee {
  private String name;
  @JsonUnwrapped
  private Department dept;
    .............
}
```

```java
public class ExampleMain {
  public static void main(String[] args) throws IOException {
      Department dept = new Department();
      dept.setDeptName("Admin");
      dept.setLocation("NY");
      Employee employee = new Employee();
      employee.setName("Amy");
      employee.setDept(dept);

      System.out.println("-- before serialization --");
      System.out.println(employee);

      System.out.println("-- after serialization --");
      ObjectMapper om = new ObjectMapper();
      String jsonString = om.writeValueAsString(employee);
      System.out.println(jsonString);

      System.out.println("-- after deserialization --");
      Employee employee2 = om.readValue(jsonString, Employee.class);
      System.out.println(employee2);
  }
}
```

运行结果

```
-- before serialization --
Employee{name='Amy', dept=Department{deptName='Admin', location='NY'}}
-- after serialization --
{"name":"Amy","deptName":"Admin","location":"NY"}
-- after deserialization --
Employee{name='Amy', dept=Department{deptName='Admin', location='NY'}}
```

支持名称前缀，防止名称碰撞

`@JsonUnwrapped(prefix = "dept-")`


## 使用@JsonAnyGetter注解序列化任意的对象属性
```java
public class ScreenInfo {
    private String id;
    private String title;
    private int width;
    private int height;
    private Map<String, Object> otherInfo;
    ....

    public void addOtherInfo(String key, Object value) {
        if (this.otherInfo == null) {
            this.otherInfo = new HashMap<>();
        }
        this.otherInfo.put(key, value);
    }

    @JsonAnyGetter
    public Map<String, Object> getOtherInfo() {
        return otherInfo;
    }

    ....
}
```

```java
public class MainScreenInfoSerialization {
  public static void main(String[] args) throws IOException {
      ScreenInfo si = new ScreenInfo();
      si.setId("TradeDetails");
      si.setTitle("Trade Details");
      si.setWidth(500);
      si.setHeight(300);
      si.addOtherInfo("xLocation", 400);
      si.addOtherInfo("yLocation", 200);

      System.out.println("-- before serialization --");
      System.out.println(si);

      ObjectMapper om = new ObjectMapper();
      String jsonString = om.writeValueAsString(si);
      System.out.println("-- after serialization --");
      System.out.println(jsonString);
  }
}
```

运行结果

```
-- before serialization --
ScreenInfo{id='TradeDetails', title='Trade Details', width=500, height=300, otherInfo={xLocation=400, yLocation=200}}
-- after serialization --
{"id":"TradeDetails","title":"Trade Details","width":500,"height":300,"xLocation":400,"yLocation":200}
```

## 使用@JsonAnySetter解序列化未映射的JSON属性


```java
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

```

运行结果

```
-- before deserialization --
{"id":"TradeDetails","title":"Trade Details","width":500,"height":300,"xLocation":400,"yLocation":200}
-- after deserialization --
JacksonAnySetter.ScreenInfo(id=TradeDetails, title=Trade Details, width=500, height=300, otherInfo={xLocation=400, yLocation=200})
```


## 使用@JsonRawValue序列化一个字段保存了json数据

```java
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

```

运行结果


```
-- before serialization --
JsonRawValueDemo.Report(id=1, name=Test report, content={"author":"Peter", "content":"Test content"})
-- after serialization --
{"id":1,"name":"Test report","content":{"author":"Peter", "content":"Test content"}}
```
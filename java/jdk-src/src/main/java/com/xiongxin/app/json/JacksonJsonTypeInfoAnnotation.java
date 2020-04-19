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

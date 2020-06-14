package com.xiongxin.app.io;

import java.io.Serializable;

public class Person implements Serializable {

    private String name = "Unknown";
    private String gender = "Unkonw";
    private double height = Double.NaN;

    public Person(String name, String gender, double height) {
        this.name = name;
        this.gender = gender;
        this.height = height;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", height=" + height +
                '}';
    }
}

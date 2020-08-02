package com.xiongxin.app.types;

import java.io.File;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.util.*;

public class TypeTest<T, V extends Number & Serializable> {

    public Number number;
    public T t;
    public V v;
    public List<T> list = new ArrayList<>();
    public Map<String, T> map = new HashMap<>();

    public T[] tArray;
    public List<T> ltArray;

    public TypeTest testClass;
    public TypeTest<T, Integer> testClass2;
    public Map<? super String, ? extends Number> mapWithWildcard;

    // 泛型构造函数，泛型参数为x
    public <X extends Number> TypeTest(X x, T t) {
        number = x;
        this.t = t;
    }

    // 泛型方法， 泛型参数为Y
    public <Y extends T> void method(Y y) {
        t = y;
    }


    public static void main(String[] args) throws NoSuchFieldException {
        Field v = TypeTest.class.getField("v");
        TypeVariable typeVariable = (TypeVariable) v.getGenericType();
        System.out.println(typeVariable);
        System.out.println(Arrays.toString(typeVariable.getBounds()));
        System.out.println(typeVariable.getGenericDeclaration());
        System.out.println(Arrays.toString(typeVariable.getAnnotatedBounds()));
        System.out.println(typeVariable.getTypeName());

        System.out.println("=================");
        Field number = TypeTest.class.getField("number");
        System.out.println(number.getGenericType());

        System.out.println("=================");

        Field list = TypeTest.class.getDeclaredField("list");
        ParameterizedType genericType1 = (ParameterizedType) list.getGenericType();
        System.out.println(genericType1.getRawType());
    }
}

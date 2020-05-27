package com.xiongxin.app.expression;

import org.springframework.core.convert.TypeDescriptor;
import org.springframework.util.Assert;

/**
 * 封装一个对象和TypeDescription.
 * type descriptor 可以包含泛型声明,可以不同通过getClass()中获取
 */
public class TypeValue {

    public static final TypeValue NULL = new TypeValue(null);

    private final Object value;
    private TypeDescriptor typeDescriptor;

    public TypeValue(Object value) {
        this.value = value;
        this.typeDescriptor = null;
    }
}

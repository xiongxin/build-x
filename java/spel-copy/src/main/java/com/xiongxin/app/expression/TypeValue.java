package com.xiongxin.app.expression;

import org.springframework.core.convert.TypeDescriptor;
import org.springframework.util.Assert;
import org.springframework.util.ObjectUtils;

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

    public Object getValue() {
        return this.value;
    }

    public TypeDescriptor getTypeDescriptor() {
        if (this.typeDescriptor == null && this.value != null) {
            this.typeDescriptor = TypeDescriptor.forObject(this.value);
        }

        return this.typeDescriptor;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }

        if (!(other instanceof TypeValue)) {
            return false;
        }

        TypeValue otherTv = (TypeValue) other;

        // 禁止 TypeDescriptor在不需要的时候初始化
        return (ObjectUtils.nullSafeEquals(this.value, otherTv.value) &&
                ((this.typeDescriptor == null && otherTv.typeDescriptor ==null) ||
                        ObjectUtils.nullSafeEquals(getTypeDescriptor(), otherTv.getTypeDescriptor())));
    }

    @Override
    public int hashCode() {
        return ObjectUtils.nullSafeHashCode(this.value);
    }

    @Override
    public String toString() {
        return "TypedValue: '" + this.value + "' of [" + getTypeDescriptor() + "]";
    }

}

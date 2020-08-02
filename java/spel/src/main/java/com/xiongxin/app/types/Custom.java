package com.xiongxin.app.types;


import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(value = {
        ElementType.ANNOTATION_TYPE,
        ElementType.CONSTRUCTOR,
        ElementType.FIELD,
        ElementType.METHOD,
        ElementType.PACKAGE,
        ElementType.PARAMETER,
        ElementType.TYPE,
        ElementType.TYPE_PARAMETER,
        ElementType.TYPE_USE
})
public @interface Custom {
}

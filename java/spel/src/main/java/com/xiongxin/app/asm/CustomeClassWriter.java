package com.xiongxin.app.asm;

import jdk.internal.org.objectweb.asm.ClassReader;
import jdk.internal.org.objectweb.asm.ClassWriter;

import java.io.IOException;

public class CustomeClassWriter {

    static String classNmae = "java.lang.Integer";
    static String cloneableInterface = "java/lang/Cloneable";
    ClassReader reader;
    ClassWriter writer;

    public CustomeClassWriter() throws IOException {
        reader = new ClassReader(classNmae);
        writer = new ClassWriter(reader, 0);
    }
}

package com.xiongxin.app.asm;


import jdk.internal.org.objectweb.asm.ClassReader;
import jdk.internal.org.objectweb.asm.ClassWriter;
import jdk.internal.org.objectweb.asm.MethodVisitor;
import jdk.internal.org.objectweb.asm.Opcodes;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.instrument.Instrumentation;
import java.lang.reflect.InvocationTargetException;

public class P02 extends ClassLoader implements Opcodes {

    public static void main(String[] args) throws IOException, InvocationTargetException, IllegalAccessException {
        FileInputStream is = new FileInputStream("/home/xiongxin/Code/build-x/java/spel/Example.class");

        ClassReader cr = new ClassReader(is);
        ClassWriter cw = new ClassWriter(0);
        ClassAdapter classAdapter = new ClassAdapter(cw); // visit+writer
//        MethodVisitor methodVisitor = classAdapter.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);
        cr.accept(classAdapter, 0); //start visit class
        FileOutputStream fos = new FileOutputStream("/home/xiongxin/Code/build-x/java/spel/Example1.class");
        fos.write(cw.toByteArray());
        byte[] code = cw.toByteArray();
        fos.close();
    }
}

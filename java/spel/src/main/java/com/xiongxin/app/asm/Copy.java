package com.xiongxin.app.asm;

import jdk.internal.org.objectweb.asm.ClassReader;
import jdk.internal.org.objectweb.asm.ClassWriter;
import jdk.internal.org.objectweb.asm.MethodVisitor;
import jdk.internal.org.objectweb.asm.Opcodes;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class Copy implements Opcodes {

    public static void main(String[] args) throws IOException {
        FileInputStream is = new FileInputStream("/home/xiongxin/Code/build-x/java/spel/Example.class");

        ClassReader cr = new ClassReader(is);
        ClassWriter cw = new ClassWriter(ClassWriter.COMPUTE_FRAMES);

        ClassAdapter classAdapter = new ClassAdapter(cw);
        MethodVisitor methodVisitor = classAdapter.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);
        methodVisitor.visitEnd();

        cr.accept(cw, 0);


        FileOutputStream fos = new FileOutputStream("/home/xiongxin/Code/build-x/java/spel/Example1.class");
        fos.write(cw.toByteArray());
        fos.close();
    }
}

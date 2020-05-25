package com.xiongxin.app.asm;

import org.objectweb.asm.*;
import org.objectweb.asm.commons.GeneratorAdapter;
import org.objectweb.asm.commons.Method;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.lang.reflect.InvocationTargetException;

import static org.objectweb.asm.Opcodes.*;

public class P00 extends ClassLoader implements Opcodes {

    public static void main(String[] args) throws IOException, InvocationTargetException, IllegalAccessException {
        ClassWriter cw = new ClassWriter(0);
        cw.visit(V1_8, ACC_PUBLIC, "Example",null, "java/lang/Object", null);
        MethodVisitor mw = cw.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);
        mw.visitVarInsn(ALOAD, 0); // push `this` to the operand stack
        mw.visitMethodInsn(INVOKESPECIAL, "java/lang/Object", "<init>", "()V", false); // 调用超类构造方法
        mw.visitInsn(RETURN);
        mw.visitMaxs(1, 1);
        mw.visitEnd();

        mw   = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, "main",
                "([Ljava/lang/String;)V", null, null);
        mw.visitFieldInsn(GETSTATIC, "java/lang/System", "out",
                "Ljava/io/PrintStream;");
        mw.visitLdcInsn("Hello world1111!");
        mw.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream", "println",
                "(Ljava/lang/String;)V", false);
        mw.visitInsn(RETURN);
        mw.visitMaxs(2, 2);
        mw.visitEnd();

        byte[] code = cw.toByteArray();
        FileOutputStream fos = new FileOutputStream("Example.class");
        fos.write(code);
        fos.close();
        P00 loader = new P00();

        Class<?> exampleClass = loader
                .defineClass("Example", code, 0, code.length);

        exampleClass.getMethods()[0].invoke(null, new Object[]{null});
    }
}

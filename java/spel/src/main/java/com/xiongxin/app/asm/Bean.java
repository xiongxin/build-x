package com.xiongxin.app.asm;


import org.objectweb.asm.*;
import org.objectweb.asm.commons.GeneratorAdapter;
import org.objectweb.asm.commons.Method;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

public class Bean extends ClassLoader implements Opcodes {

    public static class ChangeFiled extends ClassVisitor {

        public ChangeFiled(int api, ClassVisitor classVisitor) {
            super(api, classVisitor);
        }
    }

    public static void main(String[] args) throws IOException, InvocationTargetException, IllegalAccessException {
        ClassWriter cw = new ClassWriter(2);
        cw.visit(V1_8, ACC_PUBLIC, "Example", null, "java/lang/Object", null);
        MethodVisitor mw = cw.visitMethod(ACC_PUBLIC, "<init>", "()V", null, null);

        mw.visitVarInsn(ALOAD, 0); // 加载本地变量
        mw.visitMethodInsn(INVOKESPECIAL, "java/lang/Object", "<init>", "()V", false);
        mw.visitInsn(RETURN); // 无操作数指令
        mw.visitMaxs(0 , 0);
        mw.visitEnd();

        mw = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, "main", "([Ljava/lang/String;)V", null, null);
        mw.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
        mw.visitLdcInsn("Hello World");
        mw.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream", "println", "(Ljava/lang/String;)V", false);
        mw.visitInsn(RETURN);
        mw.visitMaxs(0 , 0);
        mw.visitEnd();


        byte[] code = cw.toByteArray();
        FileOutputStream fos = new FileOutputStream("Example.class");
        fos.write(code);
        fos.close();

        Bean loader = new Bean();

        Class exampleClass = loader.defineClass("Example", code, 0, code.length);

        exampleClass.getMethods()[0].invoke(null, new Object[]{null});


    }
}

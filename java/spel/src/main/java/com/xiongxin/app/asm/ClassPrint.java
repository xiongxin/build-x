package com.xiongxin.app.asm;

import jdk.internal.org.objectweb.asm.*;

import java.io.IOException;

public class ClassPrint extends ClassVisitor implements Opcodes {

    public ClassPrint() {
        super(ASM5);
    }

    public ClassPrint(final int api, final ClassVisitor cv) { // 添加
        super(api, cv);
    }

    @Override
    public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
        System.out.println(name + " 继承 " + superName + "{");
    }

    @Override
    public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
        return null;
    }

    @Override
    public FieldVisitor visitField(int access, String name, String desc, String signature, Object value) {
        System.out.println(" " + desc + " " + name);
        return null;
    }

    @Override
    public MethodVisitor visitMethod(int access, String name, String desc, String signature, String[] exceptions) {
        System.out.println(" " + name + desc);
        return null;
    }

    @Override
    public void visitEnd() {
        System.out.println("}");
    }

    public static void main(String[] args) throws IOException {
        ClassPrint classPrint = new ClassPrint();
        ClassReader classReader = new ClassReader("java.lang.Runnable");

        classReader.accept(classPrint, 0);
    }
}

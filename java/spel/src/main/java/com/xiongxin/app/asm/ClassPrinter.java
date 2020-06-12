package com.xiongxin.app.asm;

import org.objectweb.asm.*;

import java.io.IOException;

public class ClassPrinter extends ClassVisitor {
    public ClassPrinter(int api) {
        super(api);
    }

    public ClassPrinter(int api, ClassVisitor classVisitor) {
        super(api, classVisitor);
    }

    @Override
    public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
        System.out.println(name + " extends " + superName + " {");
    }

    @Override
    public void visitSource(String source, String debug) {

    }

    @Override
    public void visitOuterClass(String owner, String name, String descriptor) {

    }

    @Override
    public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
        return null;
    }

    @Override
    public void visitAttribute(Attribute attribute) {

    }

    @Override
    public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
        System.out.println(" " + descriptor + " " + name);
        return null;
    }

    @Override
    public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
        System.out.println(" " + name + descriptor);
        return null;
    }

    @Override
    public void visitEnd() {
        System.out.println("}");
    }

    public static void main(String[] args) throws IOException {
        ClassPrinter cp = new ClassPrinter(Opcodes.ASM8);
        ClassReader cr = new ClassReader("java.lang.Runnable");
        cr.accept(cp, 0);
    }
}

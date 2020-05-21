# ASM API BASICS
ASM API提供两种模式与Java classes交互传输和生产：基于event和基于tree

## 3.1 基于event API
这个API强依赖于`Visitor模式`，包含下面的几个组件

- `ClassReader` 用于读取一个class文件，传输class文件的起点
- `ClassVisitor` 读取原始的class文件之后提供方法传输class
- `ClassWriter` 输出最终生产的class文件

`ClassVisitor`提供很多方式用户我们放指定class文件的不同组件。我们通过提供一个
`classVistor`子类用于实现改变指定的class文件。

由于提供准确的class文件输出顺序，这个类型严格的方法调用顺序生成准确的输出。
```
visit
visitSource?
visitOuterClass?
( visitAnnotation | visitAttribute )*
( visitInnerClass | visitField | visitMethod )*
visitEnd 
```
## 3.2 
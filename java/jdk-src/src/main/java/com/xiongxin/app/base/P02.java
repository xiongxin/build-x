package com.xiongxin.app.base;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.function.Function;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class P02 {

  public static void main(String[] args) throws IOException {
    Stream<Person> personStream = Stream.of((Person[]) Person.persons().toArray());
    //personStream.forEach(System.out::println);
    String[] strings = new String[] {"abc","def"};
    Stream<String> stringStream = Stream.of(strings);


    System.out.println(
            Stream.of(1, 2, 3, 4, 5)
              .filter(n -> n % 2 == 0)
              .map(n -> n * n)
              .reduce(0, Integer::sum)
    );

    Stream<String> stringStream1 = Stream.of("Ken,Jeff,Charis,Ellen".split(","));
    stringStream1.forEach(System.out::println);

    Stream.Builder<String> stringBuilder = Stream.<String>builder().add("dd");
    stringBuilder.add("dd");
    stringBuilder.accept("a");
    stringBuilder.accept("b");
    stringBuilder.accept("c");
    stringBuilder.build().forEach(System.out::println);

    IntStream.rangeClosed(0, 10).forEach(System.out::println);

    Stream.iterate(1, i -> i + 10).limit(100).forEach(i -> System.out.print(i + ","));
    System.out.println();
    Stream.generate(Math::random).limit(100).forEach(i -> System.out.print(i + ","));
    System.out.println();
    new Random().ints(1, 1000).limit(100).distinct().limit(10).forEach(i -> System.out.print(i + ","));

    Files.walk(Paths.get("/home/xiongxin/Code/build-x/java/jdk-src"))
            .forEach(path -> {
              if (Files.isDirectory(path)) {
                System.out.println("目录名：" + path);
              } else {
                System.out.println("文件名：" + path);
              }
            });

    Optional<String> name = Stream.of("Ken", "Ellen", "Li")
            .min(Comparator.comparing(n -> n.length()));  // 比较两个值的应用函数

    System.out.println(name.get());

    // 1 对多生产模式
    IntStream.rangeClosed(1, 10).flatMap(n -> IntStream.of(n, n + 1, n + 2)) // 组合另外一个流产生新的流
            .forEach(System.out::println);

    personStream.forEachOrdered(System.out::println);

    double sum = Person.persons()
            .stream()
            .reduce(0.0, (partialSum, person) -> partialSum + person.getIncome(), (a, b) -> {
              System.out.println("Combiner called: a= " + a + "b = " + b);
              return a + b;
            });


    Optional<Person> person = Person.persons()
            .stream()
            .reduce((p1, p2) -> p1.getIncome() > p2.getIncome() ? p1 : p2);

    System.out.println("sum = " + sum);
    System.out.println("person = " + person.get());

    System.out.println("sum = " + Person.persons().stream().mapToDouble(Person::getIncome).sum());
    System.out.println("sum = " + Person.persons().stream().min(Comparator.comparing(Person::getIncome)));

    //
    List<String> names = Person.persons().stream()
            .map(Person::getName)
            .collect(Collectors.toList());

    System.out.println(names);
    System.out.println(Person.persons().stream().collect(Collectors.counting()));

    DoubleSummaryStatistics statistics = new DoubleSummaryStatistics();
    statistics.accept(1000.0);
    statistics.accept(5000.0);
    statistics.accept(4000.0);

    System.out.println(statistics);

    System.out.println(Person.persons().stream().collect(Collectors.summarizingDouble(Person::getIncome)));

    System.out.println(Person.persons().stream().collect(Collectors.toMap(Person::getName, Function.identity())));
    System.out.println(Person.persons().stream().collect(Collectors.toMap(Person::getGender, Person::getName, (o, n) -> String.join(",", o, n))));

    String text = P01.convertStreamToString(new FileInputStream(new File("/home/xiongxin/Code/build-x/java/jdk-src/Demo1.txt")));
//    Pattern.compile("\\s").splitAsStream(text).filter(s -> !s.isEmpty())
//            .map(String::trim)
//            .forEach(System.out::println);
    System.out.println(Pattern.compile("\\s").splitAsStream(text).filter(s -> !s.isEmpty())
            .map(String::trim)
            .collect(Collectors.toMap(Function.identity(), p -> 1L, (o, n) -> {
              o++;
              return o;
            })));

    System.out.println(
            Person.persons()
            .stream()
            .collect(Collectors.toMap(Person::getGender, Function.identity(), (o, n) -> n.getIncome() > o.getIncome() ? n : o))
    );


    System.out.println(
            Person.persons()
            .stream()
            .collect(Collectors.groupingBy(Person::getGender, Collectors.counting()))
    );

    System.out.println(
            Person.persons()
            .stream()
            .collect(Collectors.groupingBy(Person::getGender, Collectors.mapping(Person::getName, Collectors.toSet())))
    );

    System.out.println(
            Person.persons()
                    .stream().map(Person::getGender).collect(Collectors.toSet())
    );

    System.out.println(
            Person.persons()
                    .stream()
                    .collect(Collectors.groupingBy(Person::getGender,
                            Collectors.groupingBy(p -> p.getDob().getMonth(), Collectors.mapping(Person::getName, Collectors.joining(", ")))))
    );

    System.out.println(
            Person.persons()
                    .stream()
                    .collect(Collectors.groupingBy(Person::getGender, Collectors.summarizingDouble(Person::getIncome)))
    );
  }
}

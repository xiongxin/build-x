package com.xiongxin.app.io;

import java.io.*;

public class P08 {

    public static void main(String[] args) {
        Person john = new Person("John", "Male", 6.7);
        Person wally = new Person("Wally", "Male", 5.7);
        Person katrina = new Person("Katrina", "Female", 5.4);

        File fileObject = new File("person.ser");

        try (ObjectOutputStream oos =
                new ObjectOutputStream(new FileOutputStream(fileObject))) {

            // Write (or serialize) the objects to the object output stream
            oos.writeObject(john);
            oos.writeObject(wally);
            oos.writeObject(katrina);

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(fileObject.getName());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

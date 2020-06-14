package com.xiongxin.app.io;

import java.io.*;

public class P09 {

    public static void main(String[] args) throws IOException {
        // The input file
        File fileObject = new File("person.ser");

        try(ObjectInputStream ois = new ObjectInputStream(new FileInputStream(fileObject))) {

            Person john = (Person) ois.readObject();
            System.out.println(john);

            Person wally = (Person) ois.readObject();
            System.out.println(wally);

            Person katrina = (Person) ois.readObject();
            System.out.println(katrina);

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(fileObject.getName());
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }


        BufferedReader br = new BufferedReader(new FileReader("luci1.txt"));

        String str;
        while ((str = br.readLine()) != null) {
            System.out.println(str);
        }
        br.close();
    }
}

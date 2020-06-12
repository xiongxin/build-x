package com.xiongxin.app.io;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;

public class P00 {

    public static void main(String[] args) throws IOException {
        File file = new File("./a.txt");
        System.out.println(file.getCanonicalPath());
        System.out.println(System.getProperty("user.dir"));
        File dummyFile = new File("dummy.txt");
        if (!dummyFile.exists()) {
            dummyFile.createNewFile();
        }
        System.out.println(dummyFile.length());

        File currentDir = new File(System.getProperty("user.dir"));

        FileFilter fileFilter = f -> {
          if (f.isFile()) {
              if (f.getName().endsWith(".class")) {
                  return true;
              }
          }
          return false;
        };

        File[] list = currentDir.listFiles(fileFilter);
        for (File f: list) {
            if (f.isFile()) {
                System.out.println(f.getPath() + " (File)");
            }
            else if (f.isDirectory()) {
                System.out.append(f.getPath() + "(Directory)");
            }
        }
    }
}

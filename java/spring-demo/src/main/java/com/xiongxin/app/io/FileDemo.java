package com.xiongxin.app.io;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;

public class FileDemo {

    public static void main(String[] args) throws IOException {
        FileDemo demo = new FileDemo();
        demo.listFile("/home/xiongxin/Code/build-x/java/spring-demo/src");
    }


    void listFile(String path) throws IOException {
        if (path == null || path.isEmpty()) {
            return;
        }

        Path realPath = new File(path).toPath();

        if (!Files.exists(realPath, LinkOption.NOFOLLOW_LINKS)) {
            return;
        }


        Files.list(realPath).forEach(file -> {
            File file2 = new File(String.valueOf(file));

            if (file2.isDirectory()) {
                try {
                    listFile(file2.getPath());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            else
            {
                System.out.println(file2.getAbsolutePath());
            }
        });
    }
}

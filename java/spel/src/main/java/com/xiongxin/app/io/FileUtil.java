package com.xiongxin.app.io;

import java.io.Closeable;
import java.io.IOException;
import java.util.Objects;

public class FileUtil {

    public static void printFileNotFoundMsg(String fileName) {
        String workingDir = System.getProperty("user.dir");
        System.out.print("Could not find the file'" +
                fileName + "' in '" + workingDir + "' directory ");
    }

    public static void close(Closeable resource) {
        if (Objects.nonNull(resource)) {
            try {
                resource.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

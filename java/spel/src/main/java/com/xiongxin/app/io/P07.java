package com.xiongxin.app.io;

import java.io.*;

public class P07 {
/*    public static void main(String[] args) {

        String destFile = "primitives.dat";

        try (DataOutputStream dos
                     = new DataOutputStream(new FileOutputStream(destFile))) {

            // Write some primitive values and a string
            dos.writeInt(777);
            dos.writeDouble(1111.50);
            dos.writeBoolean(true);
            dos.writeUTF("Java Input/Output is cool!");

            // Flush the written data to the file
            dos.flush();

            System.out.println("Data has been written to " + destFile);

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(destFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }*/

    public static void main(String[] args) {

        String destFile = "primitives.dat";

        try (DataInputStream dis
                     = new DataInputStream(new FileInputStream(destFile))) {

            // Write some primitive values and a string
            System.out.println(dis.readInt());
            System.out.println(dis.readDouble());
            System.out.println(dis.readBoolean());
            System.out.println(dis.readUTF());

        } catch (FileNotFoundException e) {
            FileUtil.printFileNotFoundMsg(destFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

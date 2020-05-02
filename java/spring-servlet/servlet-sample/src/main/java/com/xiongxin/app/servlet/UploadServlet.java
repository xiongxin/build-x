package com.xiongxin.app.servlet;


import lombok.Data;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.DataInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/upload.do")
public class UploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        byte[] body = readBody(req);
        String textBody = new String(body, StandardCharsets.ISO_8859_1);
        System.out.println("UTF-8 length = " + textBody.getBytes().length);
        String filename = getFilename(textBody);

        Position p = getFilePosition(req, textBody);

        writeTo(filename, body, p);
    }


    @Data
    class Position {
        int begin;
        int end;

        public Position(int begin, int end) {
            this.begin = begin;
            this.end = end;
        }
    }

    private byte[] readBody(HttpServletRequest request) throws IOException {

        int formDataLength = request.getContentLength(); // 请求的数据总长度

        DataInputStream dataInputStream =
                new DataInputStream(request.getInputStream());
        System.out.println(request.getContentLength());
        byte[] body = new byte[formDataLength];

        int totalBytes = 0;
        while (totalBytes < formDataLength) {
            int bytes = dataInputStream.read(body, totalBytes, formDataLength);
            totalBytes += bytes;
        }

        return body;
    }

    private Position getFilePosition(HttpServletRequest request, String textBody) {
        // 获取文件区段边界信息
        // 例如： Content-Type: multipart/form-data; boundary=----WebKitFormBoundarygxgtHUzAr98RwUHZ
        String contenType = request.getContentType();
        String boundaryText = contenType.substring(
                contenType.lastIndexOf("=") + 1);

        int pos = textBody.indexOf("filename=\"");
        pos = textBody.indexOf("\n", pos) + 1; // 从文件名开始找到第一个换号符号索引
        pos = textBody.indexOf("\n", pos) + 1; // 从文件名开始找到第一个换号符号索引
        pos = textBody.indexOf("\n", pos) + 1; // 从文件名开始找到第一个换号符号索引

        // -4 是剪去 -,- \n, 到达最后一个位置
        int boundaryLoc = textBody.indexOf(boundaryText, pos) - 4; // 找到最后一个图片的有效字符

        int begin = ((textBody.substring(0, pos)).getBytes(StandardCharsets.ISO_8859_1)).length;
        int end = ((textBody.substring(0, boundaryLoc)).getBytes(StandardCharsets.ISO_8859_1)).length;
        System.out.println("end = " + end + ", begin = " + begin);
        return new Position(begin, end);
    }

    private String getFilename(String reqBody) {
        String filename = reqBody.substring(reqBody.indexOf("filename=\"") + 10);
        filename = filename.substring(0, filename.indexOf("\n"));
        filename = filename.substring(filename.lastIndexOf("\\") + 1, filename.indexOf("\""));

        return filename;
    }

    private void writeTo(String filename, byte[] body, Position p) throws IOException {
        FileOutputStream fileOutputStream =
                new FileOutputStream("/home/xiongxin/data/Code/java/spring-servlet/" + filename);

        System.out.println("body = " + body.length);
        fileOutputStream.write(body, p.begin, (p.end - p.begin));

        fileOutputStream.flush();
        fileOutputStream.close();
    }
}

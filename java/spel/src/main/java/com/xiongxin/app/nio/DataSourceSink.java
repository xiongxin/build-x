package com.xiongxin.app.nio;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;

public class DataSourceSink {

    private CharBuffer cBuffer = null;
    private ByteBuffer bBuffer = null;

    public DataSourceSink() {
        String text = getText();
        this.cBuffer = CharBuffer.wrap(text); // 当前大小刚刚满足字符串大小
    }

    public int getByteData(ByteBuffer buffer) {
        if (!this.bBuffer.hasRemaining()) {
            return -1;
        }

        int count = 0;
        while (this.bBuffer.hasRemaining() && buffer.hasRemaining()) {
            buffer.put(this.bBuffer.get());
            count++;
        }

        return count;
    }

    public int getCharData(CharBuffer buffer) {
        if (!this.cBuffer.hasRemaining()) {
            return -1;
        }

        int count = 0;
        while (this.cBuffer.hasRemaining() && buffer.hasRemaining()) {
            buffer.put(this.cBuffer.get());
            count++;
        }

        return count;
    }

    // 存储一个byteData 到当前的byteBuffer
    public void storeByteData(ByteBuffer byteData) {
        if (this.bBuffer == null) {
            int total = byteData.remaining();
            this.bBuffer = ByteBuffer.allocate(total);
            while (byteData.hasRemaining()) {
                this.bBuffer.put(byteData.get());
            }
            this.bBuffer.flip();
        }
        else {
            this.bBuffer = this.appendContent(byteData);
        }
    }

    private ByteBuffer appendContent(ByteBuffer content) {
        // Create a new buffer to accommodate new data
        int count = this.bBuffer.limit() + content.remaining();
        ByteBuffer newBuffer = ByteBuffer.allocate(count);

        // set the position of bBuffer that has some data
        this.bBuffer.clear();
        newBuffer.put(this.bBuffer);
        newBuffer.put(content);

        this.bBuffer.clear();
        newBuffer.clear();

        return newBuffer;
    }

    public String getText() {
        String newLine = System.getProperty("line.separator");
        StringBuilder sb = new StringBuilder();
        sb.append("My horse moved on; hoof after hoof");
        sb.append(newLine);
        sb.append("He raised, and never stopped:");
        sb.append(newLine);
        sb.append("When down behind the cottage roof,");
        sb.append(newLine);
        sb.append("At once, the bright moon dropped.");
        return sb.toString();
    }
}

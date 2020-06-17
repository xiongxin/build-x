package com.xiongxin.app.nio;

import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CoderResult;

public class CharEncoderDecoder {

    public static void main(String[] args) {

    }

    public static void encode(DataSourceSink ds, String charset) {
        CharsetEncoder encoder = Charset.forName(charset).newEncoder(); // 特定字符编码编解码器

        CharBuffer input = CharBuffer.allocate(8);
        ByteBuffer output = ByteBuffer.allocate(8);

        // Initialize variables for loop
        boolean endOfInput = false;
        CoderResult result = CoderResult.UNDERFLOW; // 默认结果是需要更多输入数据

        while (!endOfInput) {
            if (result == CoderResult.UNDERFLOW) { // 结果需要更多输入
                input.clear();
                endOfInput = (ds.getCharData(input) == -1); // 数据源读取字符数据进来
                input.flip();
            }

            // Encode the input characters
            result = encoder.encode(input, output, endOfInput); // 编码字符到字节

            // Drain output when
            // 1. It is an overflow. Or,
            // 2. It is an underflow and it is the end of the input
            // 保存编码字节的条件：
            // 1. 如果编码的buffer溢出了，需要再次调用encode
            // 2. 如果输入结束并且编码字符需要更多输入时
            if (result == CoderResult.OVERFLOW ||
                    (endOfInput && result == CoderResult.UNDERFLOW)) {
                output.flip();             // 字节转成读模式
                ds.storeByteData(output);  // 将编码的字节保存到数据源
                output.clear();            // 清空编码用的字节buffer，变成新建状态
            }
        }

        // Flush the internal state of the encoder
        // 清空编码器的内部状态
        while (true) {
            output.clear();
            result = encoder.flush(output);
            output.flip();
            if (output.hasRemaining()) {
                ds.storeByteData(output);
                output.clear();
            }
            // Underflow means flush() method has flushed everything
            if (result == CoderResult.UNDERFLOW) {
                break;
            }
        }
    }
}

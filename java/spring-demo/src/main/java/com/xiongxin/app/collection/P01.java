package com.xiongxin.app.collection;

import java.util.ArrayList;
import java.util.Collections;

public class P01 {

    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<Integer>(){{
            this.add(-1);
            this.add(3);
            this.add(3);
            this.add(-5);
            this.add(7);
            this.add(4);
            this.add(-9);
            this.add(-7);
        }};
        Collections.reverse(list);
        System.out.println(list);

        Collections.rotate(list, 4);

        System.out.println(list);
    }
}

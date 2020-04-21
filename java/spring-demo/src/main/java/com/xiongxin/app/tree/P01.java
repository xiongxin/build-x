package com.xiongxin.app.tree;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;

public class P01 {


    public static void main(String[] args) {
        ArrayList<Integer> ll = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            ll.add(i);
        }

        Iterator<Integer> ii = ll.iterator();

        while (ii.hasNext()) {
            int i = ii.next();

            if (i == 7) {
                ii.remove();
            }
            System.out.println(i);

        }

        System.out.println(ll);
    }
}

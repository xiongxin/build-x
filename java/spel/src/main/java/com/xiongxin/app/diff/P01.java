package com.xiongxin.app.diff;

import com.github.difflib.DiffUtils;
import com.github.difflib.algorithm.DiffException;
import com.github.difflib.patch.AbstractDelta;
import com.github.difflib.patch.Patch;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

public class P01 {

    public static void main(String[] args) throws DiffException, IOException {
        //build simple lists of the lines of the two testfiles
        List<String> original = new ArrayList<String>(){{
            this.add("<h1>目录1</h1>");
            this.add("<p>安静的222风景是大家大厦收到</p>");
            this.add("<h2>目录23333</h2>");
        }};
        List<String> revised = new ArrayList<String>(){{
            this.add("<h1>目录1222</h1>");
            this.add("<p>安静的222风景是大家大厦收到ss</p>");
            this.add("<h2>目录23333</h2>");
        }};
        System.out.println(original);
        System.out.println(revised);
//compute the patch: this is the diffutils part
        Patch<String> patch = DiffUtils.diff(original, revised);

//simple output the computed patch to console
        System.out.println(patch.getDeltas().size());
        for (AbstractDelta<String> delta : patch.getDeltas()) {
            System.out.println(delta);
//            System.out.println(delta.getTarget().getPosition());
        }

    }
}

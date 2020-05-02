package com.xiongxin.app.servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/some.view")
public class SomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


//        PrintWriter printWriter = resp.getWriter();
//
//        printWriter.println("Some do one ...");
//        RequestDispatcher dispatcher = req.getRequestDispatcher("other.view?data=1&nda=1");
//        dispatcher.forward(req, resp);
//
//        printWriter.println("Some do two...");
//        printWriter.close();

        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "请求参数错误");
    }
}

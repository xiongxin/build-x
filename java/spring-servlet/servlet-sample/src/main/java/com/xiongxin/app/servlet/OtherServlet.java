package com.xiongxin.app.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/other.view")
public class OtherServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String p = req.getParameter("data");


        resp.getWriter().println( req.getAttribute("javax.servlet.include.request_uri") );
        resp.getWriter().println( req.getAttribute("javax.servlet.include.context_path") );
        resp.getWriter().println( req.getAttribute("javax.servlet.include.servlet_path") );
        resp.getWriter().println( req.getAttribute("javax.servlet.include.path_info") );
        resp.getWriter().println( req.getAttribute("javax.servlet.include.query_string") );
        resp.getWriter().println("get p from some=" + p );
        resp.getWriter().println("get p from some=" + p );
        resp.getWriter().println("get p from some=" + p );
    }
}

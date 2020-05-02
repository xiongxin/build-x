package com.xiongxin.app.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet("/body.view")
public class BodyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();

        out.println("<html>");
        out.println("<head>");
        out.println("<title>Simple Servlet</title>");
        out.println("</head>");
        out.println("<body>");
        out.println(readBody(req));
        out.println("<p>"+req.getRequestedSessionId()+"</p>");
        out.println("<p>"+req.getRequestURI()+"</p>");
        out.println("<p>"+req.getRequestURL()+"</p>");
        out.println("<p>"+req.getContextPath()+"</p>");
        out.println("<p>"+req.getServletPath()+"</p>");
        out.println("<p>"+req.getPathInfo()+"</p>");
    }


    private String readBody(HttpServletRequest request) throws IOException {

        BufferedReader reader = request.getReader();
        String input = null;
        StringBuilder sb = new StringBuilder();

        while ( (input = reader.readLine()) != null ) {
            sb.append(input);
            sb.append("<br>");
        }

        return sb.toString();
    }
}

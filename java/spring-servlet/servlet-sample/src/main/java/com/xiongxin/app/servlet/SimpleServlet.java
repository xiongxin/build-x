package com.xiongxin.app.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.Map;

@WebServlet(
        urlPatterns = { "/servlet/*" }
)
public class SimpleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String name = req.getParameter("name");

        resp.setContentType("text/html;charset=UTF-8");

        PrintWriter out = resp.getWriter();

        Enumeration<String> e = req.getParameterNames();
        while (e.hasMoreElements()) {
            String param = e.nextElement();
            System.out.println("param = " + param);
        }

        Map<String, String[]> e1 = req.getParameterMap();
        e1.forEach((k, v) -> System.out.println(k + Arrays.toString(v)));


        out.println("<html>");
        out.println("<head>");
        out.println("<title>Simple Servlet</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1> Hello, " + name + ", 现在是" + new Date() + "</h1>");

        out.println("<p>"+req.getRequestedSessionId()+"</p>");
        out.println("<p>"+req.getRequestURI()+"</p>");
        out.println("<p>"+req.getRequestURL()+"</p>");
        out.println("<p>"+req.getContextPath()+"</p>");
        out.println("<p>"+req.getServletPath()+"</p>");
        out.println("<p>"+req.getPathInfo()+"</p>");

        Enumeration<String> names = req.getHeaderNames();

        while (names.hasMoreElements()) {
            String headName=  names.nextElement();
            out.println("<p>"+ headName +":" + req.getHeader(headName) + "</p>");
        }

        out.println("</body>");
        out.println("</html>");

        out.close();
    }
}

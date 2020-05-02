package com.xiongxin.app.servlet;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/encoding")
public class EncodingServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("nameGet");
        System.out.println(req.getCharacterEncoding());
        System.out.println(new String(name.getBytes("ISO-8859-1"), "BIG5"));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        BufferedReader reader = req.getReader();

        String input = null;
        String requestBody = "";

        PrintWriter out = resp.getWriter();
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Simple Servlet</title>");
        out.println("</head>");
        out.println("<body>");

        while ((input = reader.readLine()) != null) {
            requestBody = requestBody + input + "<br />";
            out.println(requestBody);
        }

        out.println("</body>");
        out.println("</html>");
        resp.getWriter().println(requestBody);
    }
}

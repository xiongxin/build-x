<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="!isAuthenticated()">
    Login
</sec:authorize>
<sec:authorize access="isAuthenticated()">
    Logout
</sec:authorize>

<a href=""></a>

<h1>index page</h1>

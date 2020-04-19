<%--
  Created by IntelliJ IDEA.
  User: xiongxin
  Date: 8/27/19
  Time: 12:02 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="zh">
<head>
    <title>登录页面</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="/dist/index.css">
</head>
<body>
<div class="uk-section uk-container">
    <h1>赞课程 用户注册</h1>
    <hr>
    <spring:hasBindErrors name="userDTO">
        <div class="uk-alert-danger" uk-alert>
            <a class="uk-alert-close" uk-close></a>
            <c:forEach var="error" items="${errors.allErrors}">
                <p><spring:message message="${error}" /></p>
            </c:forEach>
        </div>
    </spring:hasBindErrors>

    <form:form cssClass="uk-form-horizontal" action="/register" method="post" modelAttribute="userDTO">
        <div class="uk-margin">
            <label class="uk-form-label" for="email">邮箱(登录时使用)</label>
            <div class="uk-form-controls">
                <form:input path="email" cssClass="uk-input uk-form-width-medium" id="email" />
            </div>
        </div>

        <div class="uk-margin">
            <label class="uk-form-label" for="username">用户名</label>
            <div class="uk-form-controls">
                <form:input path="username" cssClass="uk-input uk-form-width-medium" id="username" />
            </div>
        </div>

        <div class="uk-margin">
            <label class="uk-form-label" for="password">密码</label>
            <div class="uk-form-controls">
                <form:password path="password"  cssClass="uk-input uk-form-width-medium" id="password" />
            </div>
        </div>

        <div class="uk-margin">
            <label class="uk-form-label" for="confirmationPassword">确认密码</label>
            <div class="uk-form-controls">
                <form:password path="confirmationPassword" cssClass="uk-input uk-form-width-medium" id="confirmationPassword" />
            </div>
        </div>

        <div class="uk-margin" uk-margin>
            <button class="uk-button uk-button-primary">立即注册</button>
        </div>
    </form:form>
    <hr>
    <p>已有账号？<a href="/login">登录账号</a></p>
</>
<script src="/dist/runtime.js"></script>
<script src="/dist/index.js"></script>

</body>
</html>

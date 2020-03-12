<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/fragments/header.jspf" %>

<div class="subnav">
    <div class="uk-container">
        <ul class="uk-subnav uk-subnav-pill uk-flex-center uk-subnav-divider" uk-margin>
            <li class="uk-active"><a href="#"><i class="iconfont">&#xe6f0;</i>教程</a></li>
            <li><a href="#"><i class="iconfont">&#xe60b;</i>学习线路</a></li>
            <li>
                <a href="#"><span uk-icon="heart"></span>博客</a>
            </li>
        </ul>
    </div>
</div>

<div class="uk-container uk-margin">
    <ul class="uk-breadcrumb">
        <li><a href="#">${category.name}</a></li>
        <li class="uk-disabled">${tutorial.name}</li>
    </ul>

    <div class="uk-grid-small uk-grid-match" uk-grid>

        <div class="uk-width-expand">
            <div class="uk-box-shadow-hover-small uk-padding-small">
                <div class="uk-flex uk-flex-left@m ">
                    <div class="uk-margin-right">
                        <img src="${tutorial.imageUrl}" width="100" height="100"  alt="${tutorial.name}"/>
                    </div>
                    <div class="">
                        <h1>${tutorial.name}</h1>
                        <p>
                            ${tutorial.description}
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="uk-width-medium@m">
            <div class="uk-card uk-card-default">
                <div class="uk-card-header">
                    <p class="uk-heading-bullet uk-text-muted">热门推荐教程</p>
                </div>
                <div class="uk-card-body">
                    <ul class="uk-list uk-list-divider">
                        <li><a href="" class="uk-link">Python从入门到精通</a></li>
                        <li>List item 2</li>
                        <li>List item 3</li>
                        <li>List item 3</li>
                        <li>List item 3</li>
                    </ul>
                </div>

            </div>
        </div>
    </div>

    <div class="uk-grid-small" uk-grid>
        <div class="uk-width-expand">
            <div class="uk-card uk-card-default">
                <div class="uk-card-header">
                    <div class="uk-clearfix">
                        <div class="uk-float-left">
                            <p class="uk-margin-remove-bottom uk-text-muted uk-heading-bullet">${tutorial.name}课程</p>
                        </div>
                    </div>
                </div>
                <div class="uk-card-body">
                    <ul class="uk-list uk-list-divider">
                        <c:forEach items="${courses.data}" var="course">
                            <li>
                                <div class="uk-grid-small uk-flex-middle" uk-grid>
                                    <div class="uk-width-auto">
                                        <button class="uk-button uk-button-default">
                                            <div><span uk-icon="icon:  triangle-up; ratio: 1.5"></span></div>
                                            <div>100</div>
                                        </button>
                                    </div>
                                    <div class="uk-width-expand">
                                        <h3 class="uk-margin-remove-bottom"><a href="" class=" uk-link">${course.title}</a></h3>
                                        <p class="uk-margin-remove-top">
                                            <span uk-icon="icon:  user;ratio: 0.8"></span><a class="uk-link-text" href="#"> ${course.user.username}</a>
                                            <span uk-icon="icon:  rss;ratio: 0.8"></span>
                                            <span  class="uk-text-muted">${course.views}次查看</span>
                                            <span uk-icon="icon:  comments;ratio: 0.8"></span><a class="uk-link-muted" href="#">${course.comments}条评论</a>
                                        </p>
                                        <p>
                                            <span uk-icon="icon:tag"></span>
                                            <c:forEach items="${course.tags}" var="tag">
                                                <span class="uk-label uk-label-success">${tag.name}</span>
                                            </c:forEach>
                                        </p>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>

                    <hr>

                    <ul class="uk-pagination uk-flex-center" uk-margin>
                        <c:forEach begin="1" end="${(courses.total) / 20 + 1}" var="p">
                            <li><a href="${path}/${p}${query}">${p}</a></li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        <div class="uk-width-medium@m">
            <div class="uk-card uk-card-default">
                <div class="uk-card-header">
                    <div class="uk-clearfix">
                        <div class="uk-float-left">
                            <p class="uk-margin-remove-bottom uk-text-muted uk-heading-bullet">选择分类</p>
                        </div>
                    </div>
                </div>
                <div class="uk-card-body">
                    <ul class="uk-list">
                        <c:forEach items="${tags}" var="tag">
                            <li>
                                <label>${tag.name}</label>
                                <ul>
                                    <c:forEach items="${tag.childrenTag}" var="ctag">
                                        <li><label><input class="uk-checkbox tag-url"
                                            <c:forEach var="tid" items="${tagIds}">
                                                <c:if test="${tid == ctag.id}">checked</c:if>
                                        </c:forEach> value="${ctag.id}" type="checkbox"> ${ctag.name}</label></li>
                                    </c:forEach>
                                </ul>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>


<%@ include file="/WEB-INF/jsp/fragments/tutorial-footer.jspf" %>
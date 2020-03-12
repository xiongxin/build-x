<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/fragments/course-header.jspf" %>

<div class="uk-container uk-margin">
    <div class="uk-card  uk-card-default uk-card-body">
        <form id="create-course">
            <fieldset class="uk-fieldset">
                <legend class="uk-legend">发版新课程</legend>

                <div class="uk-margin">
                    <input class="uk-input" name="url" type="url" placeholder="课程链接地址">
                </div>

                <div class="uk-margin">
                    <label class="uk-form-label">课程相关信息(可选)</label>
                    <div class="uk-form-controls">
                        <select class="uk-select" name="tutorial" id="form-stacked-select">
                            <option value="1">Option 01</option>
                            <option value="2">Option 02</option>
                        </select>
                    </div>
                </div>

                <div class="uk-margin">
                    <label class="uk-form-label">课程标签</label>
                    <div class="uk-form-controls uk-grid">
                        <div class="uk-width-1-5@s">
                            <label><input class="uk-radio" type="radio" value="2" name="type" checked>付费</label>
                            <label><input class="uk-radio" type="radio" value="3" name="type">免费</label>
                        </div>
                        <div class="uk-width-1-5@s">
                            <label><input class="uk-radio" type="radio" value="5" name="medium" checked>视频</label>
                            <label><input class="uk-radio" type="radio" value="6" name="medium">Book</label>
                        </div>
                    </div>
                </div>

                <div class="uk-margin">
                    <label class="uk-form-label">课程级别</label>
                    <div class="uk-form-controls uk-grid">
                        <div class="uk-width-1-5@s">
                            <label><input class="uk-radio" type="radio" value="8" name="level" checked>初级</label>
                            <label><input class="uk-radio" type="radio"  value="9" name="level">高级</label>
                        </div>
                    </div>
                </div>

                <div class="uk-margin">
                    <button id="create-course-btn" class="uk-button uk-button-primary" type="button">提交课程</button>
                </div>
            </fieldset>
        </form>
    </div>

</div>



<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<hr>
<footer>
    <div class="uk-container">本站所有内容来自网络，如果有侵权请联系站长删除1781189926#qq.com(请用@替换#)</div>
</footer>
<script src="/dist/runtime.js"></script>
<script src="/dist/course.js"></script>
</body>
</html>
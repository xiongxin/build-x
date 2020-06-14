import { Component } from '@angular/core';

@Component({
  selector: 'app-root', // css selector 发现改元素时插入组件
  templateUrl: './app.component.html', // host view
  styleUrls: ['./app.component.css'] // 样式文件
})
export class AppComponent {
  title = 'my-app';
}

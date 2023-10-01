# README

## 目标：单词卡片

> 需求：
- 可以检索单词，并提供英英翻译
- 单词输出错误，提供类似的单词提示
- 通过AI，使用检索过的单词生成一篇小短文，帮助学习如何在实际中使用这些单词
- 记录搜索过的单词，并可删除
- 通过Action Cable实时更新
- 通过折叠面板，让页面更简洁 (参考：https://50projects50days.com/projects/faq-collapse/)
- 通过滚动样式替换分页（参考：https://50projects50days.com/projects/scroll-animation/）
- 删除时增加隐藏动画和高度调整，看着丝滑一点儿（参考：https://50projects50days.com/projects/blurry-loading/）
- 通过点击音标来播放音频
- 点击单词本身，跳转到朗文官网，查询更详细的内容

## 项目介绍
​	使用Ruby On Rails全栈开发，也是参考之前翻译的[Turbo教程](https://github.com/GengCen-Qin/rails-quotes)编写的。其中model要简化很多，只有一个。更多时间花在了练习写样式和使用Stimulus与Turbo交互上。其中样式是从[50projects](https://50projects50days.com/)上学习的。如果感兴趣的同学，可以了解一下，非常棒的资源。



> 启动服务
1. bundle install
2. yarn
3. ./bin/setup
4. rails db:seed
5. 在config/cable.yml中配置redis密码，如果没有就把password注释掉
6. 如果使用AI生成，在config/initializers/openai.rb填入你的access_token。如果你有代理填入uri_base，没有的话可以了解一下[cloudflare](https://www.cloudflare.com/)
7. rails s  或  ./bin/dev
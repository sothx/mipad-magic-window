# 完美横屏应用计划（修改版）

## 模块首页

可通过项目首页快速了解本模块：

<a href="https://hyper-magic-window.sothx.com/" target="_blank">完美横屏应用计划（修改版）</a>

## 模块版本说明

[小米平板专版]

该版本适用于所有小米/红米平板，无论是MIUI For Pad还是Hyper OS For Pad，均可以安装且正常使用，模块安装包格式为pad-x.xx.xx.zip。

[小米平板3:2比例专版]

该版本适用于机型屏幕比例为3:2的小米平板，目前小米平板使用3:2屏幕比例的平板均为小米平板6S Pro往后的所有新平板，模块安装包格式为pad-ratioOf3To2-x.xx.xx.zip。

该版本调整了部分应用在3:2比例下平行窗口适配体验不佳的问题。

[小米折叠屏专版]

该版本适用于小米 Mix Fold系列折叠屏手机，模块安装包格式为fold-x.xx.xx.zip。

[小米平板魔窗专版]

版本仅适用于安卓11的MIUI For Pad，基于MIUI老版魔窗逻辑进行适配，模块安装包格式为pad-magicWindow-x.xx.xx.zip。

[小米平板5系列澎湃专版]

版本适用于所有小米没给下放左右滑动条平行视界的应用，例如小米平板5系列的澎湃OS，模块安装包格式为pad-not-dragable--x.xx.xx.zip。

[基于小米平板6 Max 下MIUI 14 For Pad的移植包专版]

该版本仅适用于当前系统为MIUI14 For Pad，且是基于小米平板6 Max系统ROM制作的移植包，模块安装包格式为transplant-x.xx.xx.zip

其他移植包安装该模块会导致卡米，其他移植包请使用小米(红米)平板专版。

6 Max 移植包专版会随着时间推移逐渐停更，目前暂无停更计划。

[卸载模块]

uninstall-pad-0.00.00.zip——安卓12L以上版本小米平板模块适用

uninstall-pad-magicWindow-0.00.00——安卓11版本小米平板模块适用

uninstall-fold-0.00.00.zip——Mix Fold系列折叠屏适用

安装该模块后重启，然后再卸载该模块，再重启即可。

## 快速开发指南
项目脚手架基于Gulp工作流，需要依赖Gulp-Cli，可以通过以下方式进行安装：

Tips:推荐使用Node.js 18+版本。

```base
# 安装gulp-cli
pnpm install gulp-cli -g
# 安装项目依赖
pnpm install
```

相关构建命令:

```
# 安装项目依赖
pnpm install

# 构建模块文件
pnpm build

# 将构建的模块文件进行打包成对应版本的zip
pnpm release

# 将构建和打包同时进行
pnpm package
```

项目使用了ejs作为模块的模板引擎，可以根据不同的设备平台差异化平行窗口的配置。
在脚本执行时通过--use-platform来指定需要差异化适配的设备类型。
一般来说：
平板设备可以使用 pad 作为参数，折叠屏设备可以使用 fold 作为参数。

```bash
# 构建平板设备的模块包
gulp package --use-platform pad
# 构建折叠屏设备的模块包
gulp package --use-platform fold
```

在平行窗口的配置文件中可以使用ejs的相关语法来差异化适配不同的设备端：
```ejs
    <%_ if (['fold'].includes(platform)) { _%>
    <package name="com.twitter.android" scaleMode="1" fullRule="nra:cr:rcr" />
    <%_ } else { _%>
    <package name="com.twitter.android" scaleMode="1" supportFullSize="true" splitPairRule="com.twitter.app.main.MainActivity:*,com.twitter.app.profiles.ProfileActivity:*,com.twitter.android.search.implementation.results.SearchActivity:*,com.twitter.communities.detail.CommunitiesDetailActivity:*,com.twitter.communities.search.CommunitiesSearchActivity:*,com.twitter.channels.details.ChannelsDetailsActivity:*,com.twitter.app.bookmarks.legacy.BookmarkActivity:*,com.twitter.channels.management.manage.UrtListManagementActivity:*,com.twitter.app.settings.search.SettingsSearchResultsActivity:*,com.twitter.app.settings.SettingsRootCompatActivity:*" activityRule="com.twitter.app.main.MainActivity,com.twitter.app.gallery.GalleryActivity,com.twitter.explore.immersivemediaplayer.ui.activity.ImmersiveMediaPlayerActivity,com.twitter.communities.detail.CommunitiesDetailActivity,com.twitter.creator.impl.main.MonetizationActivity,com.twitter.android.client.web.AuthenticatedTwitterSubdomainWebViewActivity,com.twitter.android.client.web.AuthenticatedTwitterSubdomainWebViewActivity,com.twitter.app.settings.SettingsRootCompatActivity,com.twitter.app.bookmarks.legacy.BookmarkActivity,com.twitter.channels.management.manage.UrtListManagementActivity,com.twitter.app.profiles.ProfileActivity,com.twitter.browser.BrowserActivity" transitionRules="com.twitter.app.main.MainActivity,com.twitter.communities.detail.CommunitiesDetailActivity,com.twitter.creator.impl.main.MonetizationActivity,com.twitter.android.client.web.AuthenticatedTwitterSubdomainWebViewActivity,com.twitter.android.client.web.AuthenticatedTwitterSubdomainWebViewActivity,com.twitter.app.settings.SettingsRootCompatActivity,com.twitter.app.bookmarks.legacy.BookmarkActivity,com.twitter.channels.management.manage.UrtListManagementActivity,com.twitter.app.profiles.ProfileActivity" />
    <%_ } _%>
```


## 支持的版本
该Magisk模块Fork自酷安御板初琴大佬的完美横屏应用计划，根据我的个人使用习惯及应用体验修改并扩充了部分应用的平行窗口适配规则，不保证与原版体验一致，如有需要可以从下方获取御板初琴大佬编写的正式版规则。

<a href="https://ybcq.github.io/2023/05/01/%E3%80%90%E5%8E%9F%E5%88%9B%E8%BD%AF%E4%BB%B6%E3%80%91%E5%AE%8C%E7%BE%8E%E6%A8%AA%E5%B1%8F%E5%BA%94%E7%94%A8%E8%AE%A1%E5%88%92-%E6%AD%A3%E5%BC%8F%E7%89%88%20V1.00.0/" target="_blank">【原创软件】完美横屏应用计划-正式版 V1.00.0 —— 御坂初琴软件屋</a>

## 我该如何扩充适配规则
可通过Pull Request或者Issue提交应用适配代码或者应用适配需求，如果不了解详细的适配参数，可用阅读下方御板初琴大佬的适配攻略：

<a href="https://ybcq.github.io/2023/02/12/%E3%80%90%E5%8E%9F%E5%88%9B%E6%95%99%E7%A8%8B%E3%80%91MIUI%E5%B9%B3%E8%A1%8C%E8%A7%86%E7%95%8C%E5%85%A8%E6%8E%A2%E7%B4%A2/" target="_blank">【原创教程】MIUI平行视界全探索 —— 御坂初琴软件屋</a>

Tips:使用MT管理器可用方便地获取应用的Activity记录

## 问题合集

遇到问题可参考御板初琴软件屋针对完美横屏应用计划的问题合集指南，模块问题建议优先反馈给模块作者。

<a href="https://ybcq.github.io/2023/03/20/%E3%80%90%E9%97%AE%E9%A2%98%E5%90%88%E9%9B%86%E3%80%91%E5%AE%8C%E7%BE%8E%E6%A8%AA%E5%B1%8F%E5%BA%94%E7%94%A8%E8%AE%A1%E5%88%92/" target="_blank">【问题合集】完美横屏应用计划 —— 御坂初琴软件屋</a>




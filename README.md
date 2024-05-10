# HyperOS For Pad/Fold 完美横屏应用计划

## 模块首页

可通过项目首页快速了解本模块：

<a href="https://hyper-magic-window.sothx.com/" target="_blank">HyperOS For Pad/Fold 完美横屏应用计划 - MIUI MagicWindow+</a>


## 模块版本说明

[小米平板通用版(pad-x.xx.xx.zip)]

适配基于Android 14 + 的Hyper OS for Pad（也适配Android 13的Xiaomi Pad 6 Max）,以及各类基于Android 14的Hyper OS For Pad第三方移植包的机型，均可刷此模块，正常情况下不会遇到任何问题，仅在我自己的小米平板6 Pro上测试通过，其他机型不保证不会出现卡米、变砖的可能性，建议自己有充足的玩机、救砖知识再去使用本模块。

[小米平板安卓13通用版(pad-not-dragable-x.xx.xx.zip)]

适配Android 13下不支持平行视界左右滑动条的MIUI For Pad/Hyper OS For Pad，以及各类基于Android 13 MIUI For Pad的移植包机型，推荐基于Android 13底层安装此版本，该版本针对Android 13下平行视界部分应用显示不全的问题有做单独适配优化。

[小米平板安卓11通用版(pad-magicWindow-x.xx.xx.zip)]

适配小米平板安卓11下类华为/荣耀体系的横屏模式，仅适配安卓11，安卓11的模块不支持通过系统设置直接关闭某个应用的横屏模式适配(重启或者升级模块均会恢复打开状态)，可通过模块提供的[自定义规则(Beta)](https://hyper-magic-window.sothx.com/custom-config.html)来调整某个应用的横屏模式适配，如果有体验不佳的应用也可以反馈给我，在后续版本中永久移除该应用的平行视界适配。

[小米折叠屏通用版(fold-x.xx.xx.zip)]

适配小米Mix Fold 折叠屏系列，仅推荐折叠屏的机型。

[小米平板6S Pro澎湃专版(pad-ratioOf3To2-x.xx.xx.zip)]

基本与小米平板通用版没有特别大区别，仅针对部分应用在3：2比例下体验不佳的情况进行差异化适配。

[小米平板6(pipa)澎湃专版(pad-pipa-for-hyperos-x.xx.xx.zip)]

本模块仅适用于小米平板6(pipa) 的小米官方 Hyper OS For Pad，该模块会补全小米平板6缺失的应用布局优化，该版本存在一定的卡米风险，需要自行救砖，该版本误装会100%卡米！！！

该模块不同于通用版模块，推荐系统更新前先卸载本模块，避免卡米，系统更新后再尝试安装本模块。

[小米平板5系列安卓13澎湃专版(pad-hyperos-based-on-tiramisu-x.xx.xx.zip)]

适配小米平板5/小米平板5 Pro/小米平板5 Pro 5G 小米官方基于Android 13的 Hyper OS，该模块会解锁平行窗口的左右滑动调节，该版本存在一定的卡米风险，需要自行救砖，该版本误装会100%卡米！！！

该模块不同于通用版模块，推荐系统更新前先卸载本模块，避免卡米，系统更新后再尝试安装本模块。

[MIUI 14下的6 Max移植包专版(pad-transplant-6max-based-on-tiramisu-x.xx.xx.zip)]

适配以前小米平板6 Max发布后到Hyper OS For Pad更新前这段时间推出的基于小米平板6 Max的MIUI 14 For Pad移植包(Hyper OS For Pad和非移植包勿刷，刷错会卡米)，该版本存在一定的卡米风险，需要自行救砖，该版本误刷会100%卡米！！！！！！

移植包升级到Hyper OS For Pad 之前，务必先卸载本模块，不然导致100%会导致卡米。

[V13之前的老版本卸载模块(新版模块可以直接移除，不需要额外的卸载模块)]

V13之前的老版本模块需要安装对应的卸载模块，重启后再移除卸载模块，再重启，此时才能完成模块的卸载，未遵守模块卸载方法导致的任何问题，请自行解决。

模块会锁定部分系统文件防止被系统云控覆盖模块的规则，可能会导致系统升级的时候因为权限不足导致卡米（存在概率，不敢保证），也可以提前使用卸载模块卸载后，再对系统进行升级。

请通过[GitHub Release](https://github.com/sothx/mipad-magic-window/releases/)搜索当前老版本的卸载模块进行卸载

-  小米平板安卓12L以上的卸载模块(uninstall-pad-x.xx.xx.zip)
-  小米平板安卓11的卸载模块(uninstall-pad-magicWindow-x.xx.xx.zip)
-  小米折叠屏的卸载模块(uninstall-fold-x.xx.xx.zip)

安装该模块后重启，然后再卸载该模块，再重启即可。

## 快速开发指南
项目基于Gulp工作流，需要依赖Gulp-Cli，可以通过以下方式进行安装：

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

使用了ejs作为模块的模板引擎，可以根据不同的设备平台差异化平行窗口的配置。
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


## 我该如何扩充适配规则

可通过Pull Request或者Issue提交应用适配代码或者应用适配需求，如果不了解详细的适配参数，可用阅读下方的自定义规则攻略：

<a href="https://hyper-magic-window.sothx.com/custom-config.html" target="_blank">完美横屏应用计划——自定义规则</a>


## 许可协议

《HyperOS For Pad/Fold 完美横屏应用计划》允许个人在非盈利用途下的安装和使用本Magisk模块，未经许可禁止用于任何商业性或其他未经许可的用途，作为项目的主要维护者将保留对项目的所有权利。



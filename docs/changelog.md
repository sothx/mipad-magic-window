## 更新日志-测试版(beta)

模块首页:[https://hyper-magic-window.sothx.com/](https://hyper-magic-window.sothx.com/)

如果是处于测试版(Beta)的模块，可能存在不稳定性以及异常BUG，如遇问题可反馈，反馈Q群：277757185

历史更新日志请点击:[https://github.com/sothx/mipad-magic-window/releases](https://github.com/sothx/mipad-magic-window/releases)

[重要更新]

本次为模块大版本更新，如遇到任何测试版模块的问题，可以前往反馈Q群：277757185进行反馈。

升级模块版本后，不符合模块Android版本要求会被阻止安装，需要手动前往网盘获取最新的模块，否则将无法正常安装：

链接: [https://caiyun.139.com/m/i?135CmUWDgnbAM](https://caiyun.139.com/m/i?135CmUWDgnbAM)

请自备救砖模块再进行测试版本模块的升级，否则可能导致卡米。

[模块主体]

- 模块安装过程增加对APatch版本信息的打印

- APatch引导过程不再推荐安装Web UI

- 阻止APatch低于10568版本安装模块，因低于该版本不支持Web UI

- 阻止KernelSU低于v0.8.0版本安装模块，因低于该版本不支持Web UI

- 新增service.sh.lcok 锁逻辑，避免service.sh被重复执行 @柚稚的孩纸

- 新增开机后aapt2读取应用已安装应用信息的service.sh逻辑 @柚稚的孩纸


[Web UI]

- "平行窗口滑动条比例"更名为"平行窗口默认分屏比例",降低理解成本

- 模块设置增加对 Root 管理器信息的输出



自定义规则:[https://hyper-magic-window.sothx.com/custom-config.html](https://hyper-magic-window.sothx.com/custom-config.html)

问题合集:[https://hyper-magic-window.sothx.com/FAQ.html](https://hyper-magic-window.sothx.com/FAQ.html)

提交适配需求或者缺陷请点击:[https://github.com/sothx/mipad-magic-window/issues](https://github.com/sothx/mipad-magic-window/issues)

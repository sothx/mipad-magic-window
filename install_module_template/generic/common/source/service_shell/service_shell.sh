# shellcheck disable=SC2148

# 可以重载模块部分应用的规则
# 详细使用方法，请阅读模块首页-自定义规则：https://hyper-magic-window.sothx.com/custom-config.html


set_reload_rule() {

    # [我是案例]重载哔哩哔哩的默认分屏比例为0.3
    # cmd miui_embedding_window update-rule tv.danmaku.bili splitRatio::0.3

}
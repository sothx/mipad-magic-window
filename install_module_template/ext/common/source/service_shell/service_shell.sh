# shellcheck disable=SC2148

# 可以重载模块部分应用的规则
# 详细使用方法，请阅读模块首页-自定义规则：https://hyper-magic-window.sothx.com/custom-config.html


set_reload_rule() {

    # 【强制横屏】

    # 配置QQ音乐的适配规则为强制横屏(需开启该应用在[设置-平行窗口]的开关)
    # cmd miui_embedding_window update-rule com.tencent.qqmusic fullRule::nra:cr:rcr:nr

    # 【类折叠屏信箱模式】

    # 重载QQ音乐的适配规则为类似折叠屏的尺寸(需关闭该应用在[设置-平行窗口]的开关)
    # cmd miui_embedding_window set-fixedOri com.tencent.qqmusic ratio::1.1

    # 【类手机信箱模式】

    # 重载QQ音乐的适配规则为类似手机的尺寸(需关闭该应用在[设置-平行窗口]的开关)
    # cmd miui_embedding_window set-fixedOri com.tencent.qqmusic ratio::1.5

}
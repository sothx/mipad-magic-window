/**
 * 已适配横屏的应用，没必要为他二次适配平行视界，任何情况下混入规则均需要移除以下应用的横屏适配
 */

const fullScreenList = {
  'com.taobao.taobao': true, // 淘宝
  'com.tencent.wework': true, // 企业微信
  'com.taobao.trip': true, // 飞猪
  'com.fenbi.android.leo': true, // 小猿口算
  'com.duokan.reader': true,// 多看阅读
  'com.xiaomi.shop': true, // 小米商城
  'com.xiaomi.smarthome': true, // 米家
  'com.youdao.dict': true, // 网易有道词典
  'com.netease.uu': true, // UU加速器
  'com.lemon.lv': true, // 剪映
  'com.valvesoftware.android.steam.community': true, // Steam
  'com.douban.book.reader': true, // 豆瓣阅读
  'com.amazon.kindlefc': true, // Kindle
  'com.alicloud.databox': true, // 阿里云盘
  'com.huawei.appmarket': true, // 华为应用商店
  'com.huawei.smarthome': true, // 华为智慧生活
  'mark.via': true, //via
  'com.fenbi.android.servant': true, // 粉笔
  'com.fenbi.android.zhaojiao': true, // 粉笔教师
  'com.eusoft.eudic': true, // 欧路词典
  'com.eusoft.ting.en': true, // 每日英语体力
  'com.cnki.android.cnkimobile': true, // 全球学术快报
  'com.zui.calculator': true, // ZUI计算器
  'com.jd.app.reader': true, // 京东读书
  'com.huajiao': true, // 花椒直播
  'com.youku.phone': true, // 优酷视频
  'com.tencent.qqlive': true, // 腾讯视频
  'com.kugou.android': true, // 酷狗音乐
  'com.ss.android.ugc.aweme': true, // 抖音
  'com.ss.android.ugc.live': true, // 抖音火山版
  'com.ss.android.ugc.aweme.lite': true, // 抖音极速版
  'com.smile.gifmaker': true, // 快手
  'com.kuaishou.nebula': true, // 快手极速版
  'com.bdatu.geography': true, // 华夏地理
  'com.ubestkid.beilehu.android': true, // 贝乐虎儿歌
  'youqu.android.todesk': true, // Todesk
  'com.tencent.docs': true, // 腾讯文档
  'com.github.metacubex.clash.meta': true, //Clash Meta for Android
  'com.tencent.pao': true, // 天天酷跑
  'com.estrongs.android.pop': true, // ES文件管理器
  'com.adobe.reader': true, // Adobe Acrobat
  'com.microsoft.skydrive': true, // Microsoft OneDrive
  'cn.com.langeasy.LangEasyLexis': true, // 不背单词
  'cn.ticktick.task': true, // 滴答清单
  'com.google.earth': true, //谷歌地图
  'com.omarea.vtools': true, // Scene
  'com.ss.android.ugc.aweme': true, // 抖音
  'com.ss.android.ugc.aweme.lite': true, // 抖音极速版
  'com.plan.kot32.tomatotime': true, // 番茄Todo
  'com.farplace.qingzhuo': true, // 清浊
  'com.xiachufang': true, // 下厨房
  'com.happyteam.dubbingshow': true, // 配音秀
  'czh.mindnode': true, // 思维导图
  'com.chrissen.card': true, // 麻雀记
  'top.onepix.timeblock': true, // 块时间
  'www.imxiaoyu.com.musiceditor': true, // 音乐剪辑
  'com.mmbox.xbrowser': true, // X浏览器
  'com.lemon.lv': true, // 剪映
  'com.flyersoft.moonreader': true, // 静读天下
  'com.flyersoft.moonreaderp': true, // 静读天下 Pro
  'com.yikaobang.yixue': true, // 医考帮
  'com.kwai.m2u': true, // 一甜相机
  'com.qiyi.video.pad': true, // 爱奇艺Pad版
  'com.smile.gifmaker': true, // 快手
  'com.baidu.baidutranslate': true, // 百度翻译
}

/**
 * 仅对其做了横屏优化的应用
 */

const fixedOrientationList = {
  'com.santi.sinology': true, // 国学启蒙古诗词典
  'com.xifeng.fun': true, // OmoFun
  'com.viva.note': true, // 囧次元
  'com.mxbc.mxsa': true, // 蜜雪冰城
  'com.ingka.ikea.app.cn.prod': true, // 宜家家居
  'com.vpapps.hdwallpaper.xyz': true, // 小柚子
  'cn.jj': true, // JJ斗地主
  'com.happyelements.AndroidAnimal': true, // 开心消消乐
  'com.by.butter.camera': true, // 黄油相机
  'com.tencent.peng': true, // 天天爱消除
  'com.fy.bzzbc.mi': true, // 搬砖争霸赛
  'com.netease.sz.xxqa': true, // 南国强安
  'com.hexin.plat.android': true, // 同花顺
  'com.umihome.m': true, // 柚米租房
  'com.fimo.camera': true, // FIMO
}



/**
 * 无任何适配意义的应用
 */

const NotNeedAdaptationList = {
  'com.ks.jybh.mi': true, // 解压宝盒
  'com.hcj.moon': true, // moom 月相
}

module.exports = {
  ...fullScreenList,
  ...NotNeedAdaptationList,
  ...fixedOrientationList,
}
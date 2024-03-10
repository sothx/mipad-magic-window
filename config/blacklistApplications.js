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
}

/**
 * 无法适配平行视界，但是对其做了横屏优化的应用
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
}

module.exports = {
  ...fullScreenList,
  ...fixedOrientationList,
}
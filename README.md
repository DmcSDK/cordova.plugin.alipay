# cordova.plugin.alipay

cordova 支付宝支付插件

```
 cordova plugin add https://github.com/DmcSDK/cordova.plugin.alipay.git --variable PID=你的商户PID可以在账户中查询
 
```

* js调用插件方法

```js

    //第一步：订单在服务端签名生成订单信息，具体请参考官网进行签名处理
    var payInfo  = "xxxx";

    //第二步：调用支付插件        	
    cordova.plugins.AliPay.pay(payInfo,function success(e){},function error(e){});

	 //e.resultStatus  状态代码  e.result  本次操作返回的结果数据 e.memo 提示信息
	 //e.resultStatus  9000  订单支付成功 ;8000 正在处理中  调用function success
	 //e.resultStatus  4000  订单支付失败 ;6001  用户中途取消 ;6002 网络连接出错  调用function error
	 //当e.resultStatus为9000时，请去服务端验证支付结果
	 			/**
				 * 同步返回的结果必须放置到服务端进行验证（验证的规则请看https://doc.open.alipay.com/doc2/
				 * detail.htm?spm=0.0.0.0.xdvAU6&treeId=59&articleId=103665&
				 * docType=1) 建议商户依赖异步通知
				 */

```

## Android 注意点

如果你采用的是最新的cordova8.0版本，那么当执行 cordova platform add android时候，会默认采用cordova android 7.0 或者更高的版本，由于7.0以上的版本中，Android的目录发生了改变。[参考网址](https://cordova.apache.org/announcements/2017/12/04/cordova-android-7.0.0.html)

cordova android 7.0 运行可能会报错如下：
```
cp: copyFileSync: could not write to dest file (code=ENOENT):/home/ice/WebstormProjects/MyCordova4/platforms/android/res/xml/config.xml

Parsing /home/ice/WebstormProjects/MyCordova4/platforms/android/res/xml/config.xml failed
```

如果想要兼容，可以采用hook的方式，需要两步：

1、新建 hooks/patch-android-studio-check.js 文件,内容如下

```
/**
* This hook overrides a function check at runtime. Currently, cordova-android 7+ incorrectly detects that we are using
* an eclipse style project. This causes a lot of plugins to fail at install time due to paths actually being setup
* for an Android Studio project. Some plugins choose to install things into 'platforms/android/libs' which makes
* this original function assume it is an ecplise project.
*/
module.exports = function (context) {
    if (context.opts.cordova.platforms.indexOf('android') < 0) {
        return;
    }

    const path = context.requireCordovaModule('path');
    const androidStudioPath = path.join(context.opts.projectRoot, 'platforms/android/cordova/lib/AndroidStudio');
    const androidStudio = context.requireCordovaModule(androidStudioPath);
    androidStudio.isAndroidStudioProject = function () { return true; };
};
```

2、在config.xml添加如下代码

```
<platform name="android">
    <hook src="hooks/patch-android-studio-check.js" type="before_plugin_install" />
    <hook src="hooks/patch-android-studio-check.js" type="before_plugin_add" />
    <hook src="hooks/patch-android-studio-check.js" type="before_build" />
    <hook src="hooks/patch-android-studio-check.js" type="before_run" />
    <hook src="hooks/patch-android-studio-check.js" type="before_plugin_rm" />
</platform>
```
此时重新运行 cordova run android 即可正常运行。

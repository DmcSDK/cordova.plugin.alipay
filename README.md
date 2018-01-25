# cordova.plugin.alipay

cordova 支付宝支付插件

```
 cordova plugin add https://github.com/dmcBig/cordova.plugin.alipay.git --variable PID=你的商户PID可以在账户中查询
 
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

package com.dmc.alipay;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.alipay.sdk.app.PayTask;

import java.util.Map;

/**
 * This class echoes a string called from JavaScript.
 */
public class AlipayPlugin extends CordovaPlugin {


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("pay")) {
            String orderInfo = args.getString(0);
            this.pay(orderInfo, callbackContext);
            return true;
        }
        return false;
    }



    private void pay(final String orderInfo,final CallbackContext callbackContext) {
         //订单信息在服务端签名后返回

         if (orderInfo == null || orderInfo.equals("") || orderInfo.equals("null")) {
            callbackContext.error("Please enter order information");
         }
        Log.i("msp", "pay");
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                PayTask alipay = new PayTask(cordova.getActivity());
                Map<String, String> result = alipay.payV2(orderInfo, true);
                Log.i("msp", result.toString());
                PayResult payResult = new PayResult((Map<String, String>) result);
                String resultStatus = payResult.getResultStatus();
                // 判断resultStatus 为9000则代表支付成功
                if (TextUtils.equals(resultStatus, "9000")) {
                    // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                    callbackContext.success(new JSONObject(result));
                } else {
                    // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                    callbackContext.error(new JSONObject(result));
                }
            }
        });
    }
}

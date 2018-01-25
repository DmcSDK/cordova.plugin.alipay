/********* Alipay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AlipaySDK/AlipaySDK.h>
@interface AlipayPlugin : CDVPlugin {
    // Member variables go here.
    NSString *callbackId;
}

- (void)pay:(CDVInvokedUrlCommand*)command;
@end

@implementation AlipayPlugin

- (void)pay:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;
    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString =[command argumentAtIndex:0];
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:[NSString stringWithFormat:@"dmc%@", [self settingForKey: @"alipayPid"]] callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
            CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
        } else {
            CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
            
        }}];
    
    
}

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

- (void)handleOpenURL:(NSNotification *)notification {
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:[NSString stringWithFormat:@"dmc%@", [self settingForKey: @"alipayPid"]]])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            
            NSLog(@"reslut = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            } else {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            }
        }];
    }
}

@end

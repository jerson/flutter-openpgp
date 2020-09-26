#import "OpenpgpPlugin.h"

@implementation OpenpgpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"openpgp"
            binaryMessenger:[registrar messenger]];
  OpenpgpPlugin* instance = [[OpenpgpPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
    
}

@end

#import "OpenpgpPlugin.h"

#if __has_include(<OpenPGPBridge/OpenPGPBridge.h>)
#import <OpenPGPBridge/OpenPGPBridge.h>
#else
@import OpenPGPBridge;
#endif

@implementation OpenpgpPlugin{
    dispatch_queue_t queue;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"openpgp"
                                     binaryMessenger:[registrar messenger]];
    OpenpgpPlugin* instance = [[OpenpgpPlugin alloc] init];
    [instance setup];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self call:call.method payload:[call arguments] result:result];
}

- (void)setup
{
    queue = dispatch_queue_create("fast-openpgp", DISPATCH_QUEUE_SERIAL);
}

- (void)result: (FlutterResult)result output:(id) output
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        result(output);
    });
}

- (void)call:(NSString *)name payload: (FlutterStandardTypedData *)payload result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            NSError *error;
            NSData * output = OpenPGPBridgeCall(name, payload.data, &error);
            
            if(error!=nil){
                [self result:result output:[FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]];
            }else{
                [self result:result output:[FlutterStandardTypedData typedDataWithBytes:output]];
            }
        }
        @catch (NSException * e) {
            [self result:result output:[FlutterError errorWithCode:e.name message:e.reason details:nil]];
        }
    });
}


@end

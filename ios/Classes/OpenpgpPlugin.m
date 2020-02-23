#import "OpenpgpPlugin.h"

#if __has_include(<Openpgp/Openpgp.h>)
#import <Openpgp/Openpgp.h>
#else
@import Openpgp;
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
   
  if ([@"encrypt" isEqualToString:call.method]) {
      
      [self encrypt:[call arguments][@"message"] publicKey:[call arguments][@"publicKey"] result:result];
      
  } else if ([@"decrypt" isEqualToString:call.method]) {
      
      [self decrypt:[call arguments][@"message"] privateKey:[call arguments][@"privateKey"] passphrase:[call arguments][@"passphrase"] result:result];
      
  } else if ([@"sign" isEqualToString:call.method]) {
      
      [self sign:[call arguments][@"message"] publicKey:[call arguments][@"publicKey"] privateKey:[call arguments][@"privateKey"] passphrase:[call arguments][@"passphrase"] result:result];
      
  } else if ([@"verify" isEqualToString:call.method]) {
      
      [self verify:[call arguments][@"signature"] message:[call arguments][@"message"] publicKey:[call arguments][@"publicKey"] result:result];
      
  } else if ([@"decryptSymmetric" isEqualToString:call.method]) {
      
      [self decryptSymmetric:[call arguments][@"message"] passphrase:[call arguments][@"passphrase"] options:[call arguments][@"options"] result:result];
      
  } else if ([@"encryptSymmetric" isEqualToString:call.method]) {
      
      [self encryptSymmetric:[call arguments][@"message"] passphrase:[call arguments][@"passphrase"] options:[call arguments][@"options"] result:result];
      
  } else if ([@"generate" isEqualToString:call.method]) {
      [self generate:[call arguments][@"options"] result:result];
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)setup
{
    queue = dispatch_queue_create("fast-openpgp", DISPATCH_QUEUE_SERIAL);
}

- (void)encrypt:(NSString *)message publicKey: (NSString *)publicKey result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
             NSError *error;
             NSString * output = [OpenpgpNewFastOpenPGP() encrypt:message publicKey:publicKey error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result(output);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)decrypt:(NSString *)message privateKey: (NSString *)privateKey passphrase: (NSString *)passphrase result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            NSError *error;
            NSString * output = [OpenpgpNewFastOpenPGP() decrypt:message privateKey:privateKey passphrase:passphrase error:&error];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result(output);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)sign:(NSString *)message publicKey: (NSString *)publicKey privateKey: (NSString *)privateKey passphrase: (NSString *)passphrase result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            NSError *error;
            NSString * output = [OpenpgpNewFastOpenPGP() sign:message publicKey:publicKey privateKey:privateKey passphrase:passphrase error:&error];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result(output);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)verify:(NSString *)signature message: (NSString *)message publicKey: (NSString *)publicKey result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            NSError *error;
            BOOL ret0_;
            BOOL output = [OpenpgpNewFastOpenPGP() verify:signature message:message publicKey:publicKey ret0_:&ret0_ error:&error];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result([NSNumber numberWithBool:output]);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)decryptSymmetric:(NSString *)message passphrase: (NSString *)passphrase options:(NSDictionary *)map result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            OpenpgpKeyOptions *options = [self getKeyOptions:map];
            NSError *error;
            NSString * output = [OpenpgpNewFastOpenPGP() decryptSymmetric:message passphrase:passphrase options:options error:&error];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result(output);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)encryptSymmetric:(NSString *)message passphrase: (NSString *)passphrase options:(NSDictionary *)map result:(FlutterResult)result {
    dispatch_async(queue, ^(void){
        @try {
            OpenpgpKeyOptions *options = [self getKeyOptions:map];
            NSError *error;
            NSString * output = [OpenpgpNewFastOpenPGP() encryptSymmetric:message passphrase:passphrase options:options error:&error];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if(error!=nil){
                    result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                }else{
                    result(output);
                }
            });
        }
        @catch (NSException * e) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
            });
        }
    });
}

- (void)generate:(NSDictionary *)map result:(FlutterResult)result {
    
    dispatch_async(queue, ^(void){
            @try {
                OpenpgpOptions * options = [self getOptions:map];
                NSError *error;
                OpenpgpKeyPair * output = [OpenpgpNewFastOpenPGP() generate:options error:&error];

                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if(error!=nil){
                        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.description details:nil]);
                    }else{
                        result(@{
                                  @"publicKey":output.publicKey,
                                  @"privateKey":output.privateKey,
                                });
                    }
                });
            }
            @catch (NSException * e) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    result([FlutterError errorWithCode:e.name message:e.reason details:nil]);
                });
            }
    });
    
}

- (OpenpgpKeyOptions *)getKeyOptions:(NSDictionary *)map
{
    OpenpgpKeyOptions * options = [[OpenpgpKeyOptions alloc] init];
    if (map == nil){
        return options;
    }
    if(map[@"cipher"]){
        [options setCipher:map[@"cipher"]];
    }
    if(map[@"compression"]){
        [options setCompression:map[@"compression"]];
    }
    if(map[@"hash"]){
        [options setHash:map[@"hash"]];
    }
    if(map[@"rsaBits"]){
        [options setRsaBits:[map[@"rsaBits"] floatValue]];
    }
    if(map[@"compressionLevel"]){
        [options setCompressionLevel:[map[@"compressionLevel"] floatValue]];
    }
    return options;
}

- (OpenpgpOptions *)getOptions:(NSDictionary *)map
{
    OpenpgpOptions * options = [[OpenpgpOptions alloc] init];
    if (map == nil){
        return options;
    }
    if(map[@"name"]){
        [options setName:map[@"name"]];
    }
    if(map[@"email"]){
        [options setEmail:map[@"email"]];
    }
    if(map[@"comment"]){
        [options setComment:map[@"comment"]];
    }
    if(map[@"passphrase"]){
        [options setPassphrase:map[@"passphrase"]];
    }
    if(map[@"keyOptions"]){
        [options setKeyOptions:[self getKeyOptions:map[@"keyOptions"]]];
    }
    
    return options;
}

@end

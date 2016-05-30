
#import <Cordova/CDVPlugin.h>

#import <UIKit/UIKit.h>

#import "SaoMViewController.h"


@interface CDVBarcodeScanner : CDVPlugin {}

- (void)scan:(CDVInvokedUrlCommand*)command;

@end


@implementation CDVBarcodeScanner

- (void)scan:(CDVInvokedUrlCommand*)command {
    
    
    
    CDVPluginResult* pluginResult = nil;
    
    // NSString* echo = [command.arguments objectAtIndex:0];
    
    
    
    SaoMViewController *saoM = [[SaoMViewController alloc]init];
    
    [self.viewController presentViewController:saoM animated:YES completion:nil];
    
    
    
    __block NSString *stringValue = nil;
    
    
    __weak __typeof(self) weakSelf = self;
    
    saoM.block = ^(NSString *string){
        
        stringValue = string;
        
        [weakSelf pluginResult:pluginResult echo:stringValue command:command];
        
    };
    
    
    
    
}


- (void)pluginResult:(CDVPluginResult*)pluginResult echo:(NSString *)echo command:(CDVInvokedUrlCommand *)command{
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}




@end
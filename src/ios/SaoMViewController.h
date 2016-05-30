//
//  SaoMViewController.h
//  saoMaTest
//
//  Created by fami_Lbb on 16/5/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^BLOCK) (NSString *);

@interface SaoMViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL upOrdrow;
    int num;
    NSTimer *timer;
}
//负责调配影音输入与输出之间的数据流
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong)UIImageView *linImgV;

@property (nonatomic,assign)BOOL oneOrTwo;

@property (nonatomic,copy)BLOCK block;

@end

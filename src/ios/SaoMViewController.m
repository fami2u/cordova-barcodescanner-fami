//
//  SaoMViewController.m
//  saoMaTest
//
//  Created by fami_Lbb on 16/5/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "SaoMViewController.h"
#import "UIImage+blurry.h"


#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kRectW2H 0.8*kScreenW
#define kTopH 0.2*kScreenH + 50
#define kLeadSpace (kScreenW-kRectW2H)/2


static NSString *saoText = @"将二维码/条形码放入框内，即可自动扫描";

@interface SaoMViewController ()

//记录系统是否允许调取系统摄像头
@property (nonatomic,assign)BOOL canOpen;

@property (nonatomic,strong)UIPageControl *page;

@property (nonatomic,strong)UIButton *oneButt;

@property (nonatomic,strong)UIButton *twoButt;

@end

@implementation SaoMViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canOpen = NO;

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneOrTwo = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //背景图
    [self creatBackGroudImage];
    
    //设置UI
    [self creatUI];
    
    //添加手势
    [self setupRecoginizer];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self setupCamera];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [timer invalidate];
    timer = nil;
    
    [_session stopRunning];
}


- (void)setupRecoginizer{
    for (int i = 0; i < 2; i++) {
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwip:)];
        swipeGesture.numberOfTouchesRequired = 1;
        swipeGesture.direction = i + 1;
        [self.view addGestureRecognizer:swipeGesture];
    }
    
    
}
- (void)handleSwip:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == 1) {
//        NSLog(@"右边");
        [self oneAction];
    }else if (swipe.direction == 2){
//        NSLog(@"左边");
        [self twoAction];
    }
    
    
    
    
}

#pragma mark -----绘制背景图------
- (void)creatBackGroudImage{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    
    CGRect clearR = CGRectMake(kLeadSpace, kTopH, kRectW2H, kRectW2H);
    
    imgView.image = [UIImage blurryImageWithBlurryRect:imgView.frame clearRect:clearR];
    
    [self.view addSubview:imgView];
    
}


- (void)creatUI{
    //返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 24, 32, 32)];
    [backButton setImage:[[UIImage imageNamed:@"anniu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //扫描框上面文字
    UILabel *saoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kTopH - 55, kScreenW, 35)];
    saoLabel.numberOfLines = 2;
    saoLabel.text = saoText;
    saoLabel.textAlignment = NSTextAlignmentCenter;
    saoLabel.textColor = [UIColor whiteColor];
    saoLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:saoLabel];
    
    //扫描框
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kLeadSpace, kTopH, kRectW2H, kRectW2H)];
    imgV.image = [UIImage imageNamed:@"Icon_SaoYiSao"];
    imgV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgV];
    
    //扫描条
    upOrdrow = NO;
    num = 0;
    _linImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kLeadSpace, kTopH, kRectW2H, 35)];
    _linImgV.image = [UIImage imageNamed:@"Icon_SaoLineOn"];
    _linImgV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_linImgV];
    
    
    //page
    [self.view addSubview:self.page];
    
    //条形码
    [self.oneButt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.oneButt];
    
    //二维码
    [self.view addSubview:self.twoButt];
    
}


#pragma mark  ------返回事件-----
- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)oneAction{
    
    [timer invalidate];
    timer = nil;

    if (!_oneOrTwo) {
        
        [self animatuionView];
                
        _oneOrTwo = YES;
        
        [_preview removeFromSuperlayer];
        
        _output.metadataObjectTypes = nil;

        self.device = nil;

        [self setupCamera];
        
        
    }else{
        
        return;
    }
    
}


- (void)twoAction{
    [timer invalidate];
    timer = nil;
    
    if (_oneOrTwo) {
        
        [self animatuionView];
        
        _oneOrTwo = NO;
        
        
        [_preview removeFromSuperlayer];
        
        _output.metadataObjectTypes = nil;
        
        self.device = nil;

        [self setupCamera];
        
    }else{
        
        return;
    }
    
    
}


- (void)animatuionView{
    
    UIButton *one = self.oneButt;
    UIButton *two = self.twoButt;
    
    if (!_oneOrTwo) {
        
        [UIView animateWithDuration:0.4 animations:^{
           
            CGPoint oneP = one.center;
            oneP.x = one.center.x + 100;
            one.center = oneP;
            
            CGPoint twoP = two.center;
            twoP.x = two.center.x + 100;
            two.center = twoP;
            
            [two setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [one setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }];
        
        
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            
            CGPoint oneP = one.center;
            oneP.x = one.center.x - 100;
            one.center = oneP;
            
            CGPoint twoP = two.center;
            twoP.x = two.center.x - 100;
            two.center = twoP;
            
            [one setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [two setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }];
        
    }
    
}


#pragma mark -----设置相机-----
- (void)setupCamera{
    
    //所有对 capture session 的调用都是阻塞的,建议放到后台队列中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if (!_device) {
        
            //初始化
            _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
            _output = [[AVCaptureMetadataOutput alloc]init];
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            _session = [[AVCaptureSession alloc]init];
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            
            if ([_session canAddInput:_input]) {
                
                [_session addInput:_input];
                
                _canOpen = YES;
                
            }else{
            
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                //去设置里开启权限
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许我们访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self backAction];
                    
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    //跳转到设置
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                        
                    }
                    
                    [self backAction];
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
               });
            
            
           }
        
            
        
            if (_canOpen) {
                
                if ([_session canAddOutput:_output]) {
                    
                    [_session addOutput:_output];
                    
                }
                
  
               
                if (_oneOrTwo) {
                    
                    //条形码
                    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode,nil];
                    
                    //                   NSLog(@"条形码");

                }else{
                    
                    //二维码
                    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,nil];
                    
                    //划定可扫描范围
                    //                    [_output setRectOfInterest:CGRectMake(kLeadSpace/kScreenH, kTopH/kScreenW, kRectW2H/kScreenH, kScreenW)];
                    
                    //                    NSLog(@"二维码");
                
                }
            
                
                _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
                _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    //回到主线程
                    
                    _preview.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    
                    [self.view.layer insertSublayer:_preview atIndex:0];
                    
                });
                
            }
        
        }

        if (_canOpen) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                //回到主线程
                timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
                
                [_session startRunning];
                
            });
            
        }
        
        
    });
    
}



#pragma mark -----获取输出的数据------

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *stringValue;
    
    if ([metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        stringValue = metadataObject.stringValue;
        
    }
    
    
    
    if (!_oneOrTwo) {
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:stringValue]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
            
            NSLog(@"扫描二维码的结果%@",stringValue);

            
            [self backAction];
        }
        
    }
    
    
    
    self.block(stringValue);
    

    
    [_session stopRunning];
    [timer invalidate];
    timer = nil;
    
    [self backAction];
    
    
}



#pragma mark ----设置扫描线动画----
- (void)lineAnimation{
    
    if (upOrdrow == NO) {
        num++;
        _linImgV.frame = CGRectMake(kLeadSpace, kTopH + 2*num, kRectW2H, 12);
        
        if (2*num >= kRectW2H - 12) {
            upOrdrow = YES;
            _linImgV.image = [UIImage imageNamed:@"Icon_SaoLine"];
        }
        
    }else{
        num--;
        _linImgV.frame = CGRectMake(kLeadSpace, kTopH + 2*num, kRectW2H, 12);
        
        if (num == 0) {
            _linImgV.image = [UIImage imageNamed:@"Icon_SaoLineOn"];
            upOrdrow = NO;
        }
        
    }
    
}



#pragma mark  ------懒加载------
- (UIPageControl *)page{
    
    if (!_page) {
        
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _page.center = CGPointMake(kScreenW/2, kTopH + kRectW2H + 20);
        _page.numberOfPages = 1;
        _page.currentPageIndicatorTintColor = [UIColor redColor];
        
    }
    
    return _page;
}


- (UIButton *)oneButt{
    
    if (!_oneButt) {
        
        _oneButt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _oneButt.center = CGPointMake(kScreenW/2, kTopH + kRectW2H + 50);
        [_oneButt setTitle:@"条形码" forState:UIControlStateNormal];
        [_oneButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _oneButt.titleLabel.font = [UIFont systemFontOfSize:18];
        [_oneButt addTarget:self action:@selector(oneAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _oneButt;
}


- (UIButton *)twoButt{
    
    if (!_twoButt) {
        
        _twoButt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _twoButt.center = CGPointMake(kScreenW/2 + 100, kTopH + kRectW2H + 50);
        [_twoButt setTitle:@"二维码" forState:UIControlStateNormal];
        [_twoButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _twoButt.titleLabel.font = [UIFont systemFontOfSize:18];
        [_twoButt addTarget:self action:@selector(twoAction) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _twoButt;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

//    NSLog(@"内存警告");

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

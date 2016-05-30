//
//  UIImage+blurry.m
//  saoMaTest
//
//  Created by fami_Lbb on 16/5/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import "UIImage+blurry.h"

@implementation UIImage (blurry)

+(UIImage *)blurryImageWithBlurryRect:(CGRect)blurryRect clearRect:(CGRect)clearRect{
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContext(blurryRect.size);
    //创建一个不透明类型的Quartz 2d绘画环境，相当与一个画布
    CGContextRef con = UIGraphicsGetCurrentContext();
    //填充颜色
    CGContextSetRGBFillColor(con, 0, 0, 0, 0.6);
    
    CGRect rect = blurryRect;
    
    //将该矩形填充上颜色，大小
    CGContextFillRect(con, rect);
    
    rect = clearRect;
    //将该区域内的背景设为透明
    CGContextClearRect(con, rect);
    //从当前上下文中获取一个UIImage对象
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}



@end

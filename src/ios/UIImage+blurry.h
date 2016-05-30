//
//  UIImage+blurry.h
//  saoMaTest
//
//  Created by fami_Lbb on 16/5/18.
//  Copyright © 2016年 fami_Lbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (blurry)

/*
 添加遮盖层以及透明层
 
 blurryRect 遮盖层的Rect
 
 clearRect  透明层的Rect
 
 */

+ (UIImage *)blurryImageWithBlurryRect:(CGRect)blurryRect clearRect:(CGRect)clearRect;

@end

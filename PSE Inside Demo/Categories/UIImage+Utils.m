//
//  UIImage+Utils.m
//  Mobile
//
//  Created by Iván Galaz-Jeria on 2/14/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *) imageWithColor:(UIColor *)color
                       frame:(CGRect) frame
                cornerRadius:(CGFloat) radius {
    
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [color setFill];
    
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:radius] addClip];
    
    UIRectFill(frame);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

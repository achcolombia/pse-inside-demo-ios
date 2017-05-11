//
//  UIImage+Utils.h
//  Mobile
//
//  Created by Iván Galaz-Jeria on 2/14/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

+ (UIImage *) imageWithColor:(UIColor *)color;
+ (UIImage *) imageWithColor:(UIColor *)color
                       frame:(CGRect) frame
                cornerRadius:(CGFloat) radius;
@end

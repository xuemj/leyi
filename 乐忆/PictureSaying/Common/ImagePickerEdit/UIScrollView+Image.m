//
//  UIScrollView+Image.m
//  O_M
//
//  Created by hamzsy on 11/19/12.
//
//

#import "UIScrollView+Image.h"

@implementation UIScrollView (Image)

- (UIImage *) viewToImage:(CGFloat)scale {
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,
                                           YES,
                                           scale);
    
    CGPoint offset=self.contentOffset;
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return visibleScrollViewImage;
}

@end

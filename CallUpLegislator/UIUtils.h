//
//  UIUtils.h
//
//  Created by Ming Yang on 4/4/14.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

+ (UIColor*)colorForParty:(NSString*)party;

+ (CGFloat)detailLabelFontSize;

+ (UIImage*)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIAlertView*)createAlertViewForDisabledLocationService;

+ (UIAlertView*)createAlertViewForUnauthorizedLocationService;

+ (UIAlertView*)createAlertViewForNetworkConnectivity;

+ (UIColor*)navigationBarColor;

+ (UIColor*)navigationBarBackButtonColor;


@end

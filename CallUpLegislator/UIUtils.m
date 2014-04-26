//
//  UIUtils.m
//
//  Created by Ming Yang on 4/4/14.
//

#import "UIUtils.h"

@implementation UIUtils

+ (UIColor*)colorForParty:(NSString *)party {
    
    if ([party rangeOfString:@"國民黨"].location!=NSNotFound) {
        return [UIColor colorWithRed:0 green:0x0c / 255.0 blue:0x85 / 255.0 alpha:1];
    }
    if ([party rangeOfString:@"民主進步"].location!=NSNotFound) {
        return [UIColor colorWithRed:0 green:0x8c / 255.0 blue:0 alpha:1];
    }
    if ([party rangeOfString:@"親民黨"].location!=NSNotFound) {
        return [UIColor colorWithRed:0xff / 255.0 green:0x4b / 255.0 blue:0 alpha:1];
    }
    if ([party rangeOfString:@"無黨團結"].location!=NSNotFound) {
        return [UIColor colorWithRed:0xb8 / 255.0 green:0 blue:0x40 / 255.0 alpha:1];
    }
    if ([party rangeOfString:@"台灣團結"].location!=NSNotFound) {
        return [UIColor colorWithRed:0x89 / 255.0 green:0x34 / 255.0 blue:0 alpha:1];
    }
    return [UIColor darkGrayColor];
}

+ (CGFloat)detailLabelFontSize {
    return 14.0f;
}

+ (UIImage*)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CGFloat)sizeOfFont:(UIFont*)font forString:(NSString*)string fitSize:(CGSize)boundingSize {
    
    CGFloat fontSize = 1;
    while (true) {
        UIFont* sizedFont = [font fontWithSize:fontSize];
        CGSize size = [string sizeWithFont:sizedFont];
        if (size.width > boundingSize.width || size.height > boundingSize.height) {
            return fontSize - 1;
        }
        fontSize+=1.0;
    }
    return fontSize;
}

+ (UIAlertView*)createAlertViewForDisabledLocationService {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"定位服務"
                                                        message:@"定位服務尚未啟用，請至「設定 -> 隱私 -> 定位服務」打開"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
    return alertView;
}

+ (UIAlertView*)createAlertViewForUnauthorizedLocationService {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"定位服務"
                                                        message:@"定位服務尚未授權予此程式，請至「設定 -> 隱私 -> 定位服務」打開"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
    return alertView;
}

+ (UIAlertView*)createAlertViewForNetworkConnectivity {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"網路連線"
                                                    message:@"無法連上網路，請啟用行動網路或是Wifi"
                                                   delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
    return alert;
}

+ (UIColor*)navigationBarColor {
    return [UIColor colorWithRed:251.0/255.0 green:191.0/255.0 blue:5.0/255.0 alpha:1.0];
}

+ (UIColor*)navigationBarBackButtonColor {
    return [UIColor darkGrayColor];
}

@end

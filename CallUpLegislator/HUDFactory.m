//
//  HUDFactory.m
//
//  Created by Ming Yang on 4/17/12.
//

#import "HUDFactory.h"

@implementation HUDFactory

+ (MBProgressHUD*)createAndInstallHUDInView:(UIView*)view delegate:(id<MBProgressHUDDelegate>)delegate {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.square = YES;
    hud.delegate = delegate;
    hud.opacity = 0.7f;
    hud.labelFont = [UIFont systemFontOfSize:15.0f];
    CGFloat hudWidth = view.frame.size.width * [Constants HUDWidthToScreenRatio];
    hud.fixedSize = CGSizeMake(hudWidth, hudWidth);
    [view addSubview:hud];
    return hud;
}

+ (NSTimeInterval)HUDHideDelay {
    return 1;
}

@end

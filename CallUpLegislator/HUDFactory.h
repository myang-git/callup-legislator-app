//
//  HUDFactory.h
//
//  Created by Ming Yang on 4/17/12.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Constants.h"

@interface HUDFactory : NSObject {
    
}

+ (MBProgressHUD*)createAndInstallHUDInView:(UIView*)view delegate:(id<MBProgressHUDDelegate>)delegate;
+ (NSTimeInterval)HUDHideDelay;

@end

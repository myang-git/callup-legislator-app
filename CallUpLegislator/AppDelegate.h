//
//  AppDelegate.h
//
//  Created by Ming Yang on 3/16/13.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (nonatomic) BOOL canMakePhoneCall;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end

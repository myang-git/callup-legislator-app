//
//  WebViewController.h
//  Petition
//
//  Created by Ming Yang on 4/11/14.
//

#import <UIKit/UIKit.h>
#import "HUDFactory.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, MBProgressHUDDelegate, UIActionSheetDelegate> {
    MBProgressHUD* hud;
    IBOutlet UIBarButtonItem* btnReload;
    IBOutlet UIBarButtonItem* btnShare;
}

- (IBAction)btnReloadPressed:(id)sender;
- (IBAction)btnSharePressed:(id)sender;

@property (nonatomic, retain) IBOutlet UIWebView* webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnReload;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* btnShare;
@property (nonatomic, copy) NSString* urlString;

@end

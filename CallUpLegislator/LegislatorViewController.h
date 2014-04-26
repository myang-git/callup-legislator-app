//
//  LegislatorViewController.h
//
//  Created by Ming Yang on 4/5/14.
//

#import <UIKit/UIKit.h>
#import "ActionCell.h"
#import "AddressViewController.h"
#import "UIUtils.h"
#import "WebViewController.h"
#import "LyModel.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface LegislatorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    
    int NAME_SECTION;
    int ELECTORAL_DISTRICT_SECTION;
    int ADDRESS_SECTION;
    int PHONE_SECTION;
    int EMAIL_SECTION;
    int REFERENCES_SECTION;
    
    IBOutlet UITableView* tableView;
    NSDictionary* legislator;
    NSMutableArray* sections;
    NSMutableArray* cellConfigurators;
}

- (id)initWithNibName:(NSString *)nibNameOrNil legislator:(NSDictionary*)_legislator bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end

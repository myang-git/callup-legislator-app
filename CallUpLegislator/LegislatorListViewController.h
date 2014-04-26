//
//  LegislatorListViewController.h
//
//  Created by Ming Yang on 4/4/14.
//

#import <UIKit/UIKit.h>
#import "LegislatorCell.h"
#import "LegislatorViewController.h"

@interface LegislatorListViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
    IBOutlet UITableView* tableView;
    NSArray* legislatorList;
    BOOL displayPartyName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil legislatorList:(NSArray*)list bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic) BOOL displayPartyName;

@end

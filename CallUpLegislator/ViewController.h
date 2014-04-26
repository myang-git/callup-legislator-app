//
//  ViewController.h
//
//  Created by Ming Yang on 3/16/13.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LyModel.h"
#import "ActionCell.h"
#import "MBProgressHUD.h"
#import "HUDFactory.h"
#import "LegislatorGroupTableViewController.h"
#import "PartyGroupViewController.h"
#import "Reachability.h"

@interface ViewController : UITableViewController <MBProgressHUDDelegate, CLLocationManagerDelegate> {
    ActionCell* locationCell;
    ActionCell* nameCell;
    ActionCell* cityCell;
    ActionCell* partyCell;
    BOOL isWaitingForLocation;
    BOOL _reloading;
    MBProgressHUD* hud;
}

@end

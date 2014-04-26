//
//  ViewController.m
//  Petition
//
//  Created by Ming Yang on 3/16/13.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;

#define _DEBUG_

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIUtils navigationBarColor];
    self.navigationController.navigationBar.tintColor = [UIUtils navigationBarBackButtonColor];

    locationCell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"locationCell"
                                              target:self
                                              action:@selector(locationCellPressed:)];
    locationCell.isLocationServiceRequired = YES;
    locationCell.isNetworkConnectivityRequired = YES;
    locationCell.textLabel.text = @"目前所在地區的立委";
    locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    nameCell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:@"nameCell"
                                          target:self
                                          action:@selector(nameCellPressed:)];
    nameCell.textLabel.text = @"以姓名尋找";
    nameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cityCell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:@"cityCell"
                                          target:self
                                          action:@selector(cityCellPressed:)];
    cityCell.textLabel.text = @"以城市尋找";
    cityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    partyCell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"partyCell"
                                           target:self
                                           action:@selector(partyCellPressed:)];
    partyCell.textLabel.text = @"以政黨尋找";
    partyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    hud = [HUDFactory createAndInstallHUDInView:[[[UIApplication sharedApplication] delegate] window] delegate:self];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    NSAttributedString* refreshControlTitle = [[NSAttributedString alloc] initWithString:@"更新資料中..."];
    refreshControl.attributedTitle = refreshControlTitle;
    [refreshControlTitle release];
    [refreshControl addTarget:self action:@selector(reloadTableViewDataSource:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [refreshControl release];
    
    self.title = @"我找立委";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return locationCell;
    }
    else if (indexPath.section==1) {
        return nameCell;
    }
    else if (indexPath.section==2) {
        return cityCell;
    }
    else if (indexPath.section==3) {
        return partyCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = (ActionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell performAction];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (void)didFindLegislator:(NSDictionary*)legislator atLocation:(CLLocation*)location withLocationManager:(CLLocationManager*)locationManager {
    [hud hide:YES];
    LegislatorViewController* vc = [[LegislatorViewController alloc] initWithNibName:@"LegislatorView"
                                                                          legislator:legislator
                                                                              bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)didNotFindLegislatorWithError:(NSError*)error andLocationManager:(CLLocationManager*)locationManager {
    [hud hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"找不到所在位置的選區立委，可能是定位功能尚未就緒，請稍候再試。"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (!isWaitingForLocation) {
        return;
    }
    isWaitingForLocation = NO;
    [[LyModel getInstance] findLegislatorByLocation:newLocation
                                            success:^(NSDictionary *legislator) {
                                                [self didFindLegislator:legislator atLocation:newLocation withLocationManager:locationManager];
                                            }
                                            failure:^(NSError *error) {
                                                [self didNotFindLegislatorWithError:error andLocationManager:locationManager];
                                            }];
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    [locationManager release];
}

- (void)locationCellPressed:(ActionCell*)cell {
    
    hud.labelText = @"定位尋找中...";
    [hud show:YES];
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    isWaitingForLocation = YES;
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        if (isWaitingForLocation) {
            isWaitingForLocation = NO;
            NSError* error = [NSError errorWithDomain:@"location-service" code:980 userInfo:nil];
            [self didNotFindLegislatorWithError:error andLocationManager:locationManager];
        }
    });
}

- (void)nameCellPressed:(ActionCell*)cell {
    NSDictionary* groups = [[LyModel getInstance] groupByAttributes:@"last-name-phonetic-index", @"last-name", nil];
    LegislatorGroupTableViewController* vc = [[LegislatorGroupTableViewController alloc] initWithNibName:@"LegislatorGroupView"
                                                                                         legislatorGroups:groups
                                                                                                  bundle:nil];
    vc.title = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)cityCellPressed:(ActionCell*)cell {
    NSDictionary* groups = [[LyModel getInstance] groupByAttributes:@"sector", @"city", nil];
    LegislatorGroupTableViewController* vc = [[LegislatorGroupTableViewController alloc] initWithNibName:@"LegislatorGroupView"
                                                                                        legislatorGroups:groups
                                                                                                  bundle:nil];
    vc.title = cell.textLabel.text;
    NSArray* sectorRankArray = [NSArray arrayWithObjects:@"北", @"中", @"南", @"東", @"澎", @"金", @"馬", @"山", @"平", @"全", @"僑", nil];
    
    NSComparator sectorComparator = ^NSComparisonResult(id obj1, id obj2) {
        NSString* sector1 = (NSString*)obj1;
        NSString* sector2 = (NSString*)obj2;
        NSUInteger rank1 = [sectorRankArray indexOfObject:sector1];
        NSUInteger rank2 = [sectorRankArray indexOfObject:sector2];
        if (rank1>rank2) {
            return NSOrderedDescending;
        }
        else if(rank1<rank2) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    };
    vc.displayElementValueForSingletonGroup = NO;
    [vc sortTableIndexByComparator:sectorComparator];
    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)partyCellPressed:(ActionCell*)cell {
    NSDictionary* groups = [[LyModel getInstance] groupByAttributes:@"party", nil];
    PartyGroupViewController* vc = [[PartyGroupViewController alloc] initWithNibName:@"LegislatorGroupView"
                                                                    legislatorGroups:groups
                                                                              bundle:nil];
    vc.displayPartyNameInLegislatorList = NO;
    vc.title = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

#pragma mark pull to refresh

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource:(UIRefreshControl*)control {
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    Reachability* reachability = [Reachability reachabilityWithHostName:@"8.8.8.8"];
    if ([reachability isReachable]) {
        [control beginRefreshing];
        [[LyModel getInstance] downloadLegislatorList:^{
            [control endRefreshing];
        }
                                              failure:^{
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"無法更新"
                                                                                                  message:@"資料內容可能有錯，請稍後重試。"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"好的"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  [alert release];
                                                  [control endRefreshing];
                                              }];
        
    }
    else {
        UIAlertView* alert = [UIUtils createAlertViewForNetworkConnectivity];
        [alert show];
        [alert release];
        [control endRefreshing];
    }
}



- (void)dealloc {
    [locationCell release];
    [nameCell release];
    [cityCell release];
    [partyCell release];
    hud.delegate = nil;
    [hud release];
    [super dealloc];
}

@end

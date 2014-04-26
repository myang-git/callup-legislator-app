//
//  LegislatorGroupTableViewController.h
//
//  Created by Ming Yang on 3/30/14.
//

#import <UIKit/UIKit.h>
#import "LegislatorCell.h"
#import "LegislatorListViewController.h"
#import "LegislatorViewController.h"

@interface LegislatorGroupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* table;
    int groupDepth;
    NSDictionary* legislatorGroups;
    NSMutableArray* keys;
    UITableViewStyle tableStyle;
    BOOL displayElementValueForSingletonGroup;
    BOOL displayPartyNameInLegislatorList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil legislatorGroups:(NSDictionary*)group bundle:(NSBundle *)nibBundleOrNil;

- (void)sortTableIndexByComparator:(NSComparator)comparator;

- (void)transformTableIndex:(NSDictionary*)mapping;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView;

@property (nonatomic, retain) IBOutlet UITableView* table;
@property (readonly) NSDictionary* legislatorGroups;
@property (readonly) NSArray* groupKeys;
@property (nonatomic) BOOL displayElementValueForSingletonGroup;
@property (nonatomic) BOOL displayPartyNameInLegislatorList;

@end

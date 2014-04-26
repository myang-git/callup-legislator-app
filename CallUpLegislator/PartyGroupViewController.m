//
//  PartyGroupViewController.m
//
//  Created by Ming Yang on 4/3/14.
//

#import "PartyGroupViewController.h"

@interface PartyGroupViewController ()

@end

@implementation PartyGroupViewController

- (void)viewDidLoad {
    groupKeys = [super.legislatorGroups keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* array1 = (NSArray*)obj1;
        NSArray* array2 = (NSArray*)obj2;
        if (array1.count > array2.count) {
            return NSOrderedAscending;
        }
        else if(array1.count < array2.count) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    [groupKeys retain];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return super.legislatorGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"legislator-cell"];
    if (cell==nil) {
        cell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleValue1
                                 reuseIdentifier:@"legislator-cell"
                                          target:self
                                          action:@selector(cellPressed:)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell autorelease];
    }
    NSString* party = [groupKeys objectAtIndex:indexPath.section];
    NSArray* legislatorsForParty = [super.legislatorGroups objectForKey:party];
    cell.textLabel.text = [groupKeys objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIUtils colorForParty:party];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d位", (int)legislatorsForParty.count];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIUtils detailLabelFontSize]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setProperty:legislatorsForParty forKey:@"legislator-list"];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = (ActionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell performAction];
}

- (void)cellPressed:(ActionCell*)cell {
    NSArray* legislatorsForParty = (NSArray*)[cell propertyForKey:@"legislator-list"];
    UIViewController* vc = nil;
    if (legislatorsForParty.count>1) {
        LyModel* submodel = [LyModel createWithLegislators:legislatorsForParty];
        NSDictionary* groups = [submodel groupByAttributes:@"last-name-phonetic-index", @"last-name", nil];
        LegislatorGroupTableViewController* groupViewController = [[LegislatorGroupTableViewController alloc] initWithNibName:@"LegislatorGroupView"
                                                                                            legislatorGroups:groups
                                                                                                      bundle:nil];
        groupViewController.title = cell.textLabel.text;
        groupViewController.displayPartyNameInLegislatorList = self.displayPartyNameInLegislatorList;
        [submodel release];
        vc = groupViewController;
    }
    else {
        NSDictionary* legislator = legislatorsForParty.firstObject;
        LegislatorViewController* legislatorViewController = [[LegislatorViewController alloc] initWithNibName:@"LegislatorView" legislator:legislator bundle:nil];
        legislatorViewController.title = [legislator objectForKey:@"name"];
        vc = legislatorViewController;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [groupKeys release];
    [super dealloc];
}

@end

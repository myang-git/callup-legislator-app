//
//  LegislatorGroupTableViewController.m
//
//  Created by Ming Yang on 3/30/14.
//

#import "LegislatorGroupTableViewController.h"

@interface LegislatorGroupTableViewController ()

@end

@implementation LegislatorGroupTableViewController

@synthesize table;
@synthesize displayPartyNameInLegislatorList;

- (id)initWithNibName:(NSString *)nibNameOrNil legislatorGroups:(NSDictionary*)groups bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        legislatorGroups = groups;
        [legislatorGroups retain];
        NSArray* tempKeys = [legislatorGroups.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString* key1 = (NSString*)obj1;
            NSString* key2 = (NSString*)obj2;
            return [key1 localizedCompare:key2];
        }];
        keys = [[NSMutableArray alloc] initWithArray:tempKeys];
        self.displayElementValueForSingletonGroup = YES;
        self.displayPartyNameInLegislatorList = YES;
    }
    return self;
}

- (void)sortTableIndexByComparator:(NSComparator)comparator {
    [keys sortUsingComparator:comparator];
}

- (void)transformTableIndex:(NSDictionary*)mapping {
    
}

- (NSDictionary*)legislatorGroups {
    return self->legislatorGroups;
}

- (NSArray*)groupKeys {
    return self->keys;
}

- (BOOL)displayElementValueForSingletonGroup {
    return self->displayElementValueForSingletonGroup;
}

- (void)setDisplayElementValueForSingletonGroup:(BOOL)_displayElementValueForSingletonGroup {
    self->displayElementValueForSingletonGroup = _displayElementValueForSingletonGroup;
    [self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [keys objectAtIndex:section];
    NSDictionary* legislators = [legislatorGroups objectForKey:key];
    return legislators.count;
}

- (void)configureCell:(ActionCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor darkTextColor];
    NSString* key = [keys objectAtIndex:indexPath.section];
    NSDictionary* subgroup = [legislatorGroups objectForKey:key];
    NSArray* subgroupKeys = [subgroup.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* str1 = (NSString*)obj1;
        NSString* str2 = (NSString*)obj2;
        return [str1 localizedCompare:str2];
    }];
    NSString* subkey = [subgroupKeys objectAtIndex:indexPath.row];
    NSArray* legislatorList = [[legislatorGroups objectForKey:key] objectForKey:subkey];
    if (self.displayElementValueForSingletonGroup) {
        if (legislatorList.count>1) {
            cell.textLabel.text = subkey;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu位", (unsigned long)legislatorList.count];
        }
        else {
            NSDictionary* legislator = legislatorList.firstObject;
            NSString* name = [legislator objectForKey:@"name"];
            cell.textLabel.text = name;
            if (self.displayPartyNameInLegislatorList) {
                NSString* party = [legislator objectForKey:@"party"];
                cell.detailTextLabel.text = party;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIUtils detailLabelFontSize]];
                cell.detailTextLabel.textColor = [UIUtils colorForParty:party];
            }
        }
    }
    else {
        cell.textLabel.text = subkey;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu位", (unsigned long)legislatorList.count];
    }
    NSArray* legislator = [[legislatorGroups objectForKey:key] objectForKey:subkey];
    [cell setProperty:legislator forKey:@"legislator-list"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section: %ld, row: %ld", (unsigned long)indexPath.section, (unsigned long)indexPath.row);
    ActionCell* cell = [tableView dequeueReusableCellWithIdentifier:@"legislator-cell"];
    if (cell==nil) {
        cell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleValue1
                                 reuseIdentifier:@"legislator-cell"
                                          target:self
                                          action:@selector(cellPressed:)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell autorelease];
    }
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = (ActionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell performAction];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [keys objectAtIndex:section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return keys;
}

- (void)cellPressed:(ActionCell*)cell {
    NSArray* legislatorList = (NSArray*)[cell propertyForKey:@"legislator-list"];
    if (legislatorList.count==1) {
        NSDictionary* legislator = legislatorList.firstObject;
        LegislatorViewController* vc = [[LegislatorViewController alloc] initWithNibName:@"LegislatorView"
                                                                              legislator:legislator
                                                                                  bundle:nil];
        vc.title = [legislator objectForKey:@"name"];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    else {
        LegislatorListViewController* vc = [[LegislatorListViewController alloc] initWithNibName:@"LegislatorListView"
                                                                                  legislatorList:legislatorList
                                                                                          bundle:nil];
        vc.title = cell.textLabel.text;
        vc.displayPartyName = self.displayPartyNameInLegislatorList;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)dealloc {
    [table release];
    [keys release];
    [legislatorGroups release];
    [super dealloc];
}

@end

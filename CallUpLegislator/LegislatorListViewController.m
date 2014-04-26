//
//  LegislatorListViewController.m
//
//  Created by Ming Yang on 4/4/14.
//

#import "LegislatorListViewController.h"

@interface LegislatorListViewController ()

@end

@implementation LegislatorListViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil legislatorList:(NSArray*)list bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        legislatorList = list;
        [legislatorList retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return legislatorList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)setDisplayPartyName:(BOOL)display {
    self->displayPartyName = display;
    [self.tableView reloadData];
}

- (BOOL)displayPartyName {
    return self->displayPartyName;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LegislatorCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"legislator-cell"];
    if (cell==nil) {
        cell = [[LegislatorCell alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:@"legislator-cell"
                                              target:self
                                              action:@selector(cellPressed:)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell autorelease];
        
    }
    cell.legislator = [legislatorList objectAtIndex:indexPath.section];
    cell.displayPartyName = self.displayPartyName;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIUtils detailLabelFontSize]];
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = (ActionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell performAction];
}


- (void)cellPressed:(LegislatorCell*)cell {
    LegislatorViewController* vc = [[LegislatorViewController alloc] initWithNibName:@"LegislatorView" legislator:cell.legislator bundle:nil];
    vc.title = [cell.legislator objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)dealloc {
    [legislatorList release];
    [super dealloc];
}

@end

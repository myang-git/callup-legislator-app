//
//  LegislatorViewController.m
//
//  Created by Ming Yang on 4/5/14.
//

#import "LegislatorViewController.h"

@interface LegislatorViewController ()

@end

@implementation LegislatorViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil legislator:(NSDictionary *)_legislator bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->legislator = _legislator;
        [legislator retain];
        self->sections = [[NSMutableArray alloc] init];
        self->cellConfigurators = [[NSMutableArray alloc] init];
        int sec = 0;
        [self->sections addObject:@""];
        [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configureNameCell:forIndexPath:)]];
        NAME_SECTION = sec++;
        
        [self->sections addObject:@"選區"];
        [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configureElectoralDistrictCcell:forIndexPath:)]];
        ELECTORAL_DISTRICT_SECTION = sec++;
        
        [self->sections addObject:@"服務處"];
        [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configureAddressCell:forIndexPath:)]];
        ADDRESS_SECTION = sec++;
        
        [self->sections addObject:@"電話"];
        [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configurePhoneCell:forIndexPath:)]];
        PHONE_SECTION = sec++;
        
        NSDictionary* contacts = [self->legislator objectForKey:@"contacts"];
        if (contacts!=nil && ![[NSNull null] isEqual:contacts]) {
            NSString* email = [contacts objectForKey:@"email"];
            if (email!=nil && ![[NSNull null] isEqual:email]) {
                [self->sections addObject:@"Email"];
                [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configureEmailCell:forIndexPath:)]];
                EMAIL_SECTION = sec++;
            }
        }
        
        NSDictionary* references = [self->legislator objectForKey:@"references"];
        if (references.count>0) {
            [self->sections addObject:@"參考資訊"];
            [self->cellConfigurators addObject:[NSValue valueWithPointer:@selector(configureReferencesCell:forIndexPath:)]];
            REFERENCES_SECTION = sec++;
        }
 
        
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
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==NAME_SECTION) {
        return 1;
    }
    
    if(section==ADDRESS_SECTION) {
        NSDictionary* contacts = [legislator objectForKey:@"contacts"];
        if (contacts==nil || [[NSNull null] isEqual:contacts]) {
            return 0;
        }
        NSDictionary* addressMap = [contacts objectForKey:@"address"];
        return addressMap.count;
    }
    
    if (section==ELECTORAL_DISTRICT_SECTION) {
        return 1;
    }
    
    if (section==PHONE_SECTION) {
        NSDictionary* contacts = [legislator objectForKey:@"contacts"];
        if (contacts==nil || [[NSNull null] isEqual:contacts]) {
            return 0;
        }
        NSDictionary* phoneMap = [contacts objectForKey:@"phone"];
        return phoneMap.count;
    }
    
    if (section==EMAIL_SECTION) {
        return 1;
    }
    
    if (section==REFERENCES_SECTION) {
        NSDictionary* refs = [legislator objectForKey:@"references"];
        return refs.count;
    }
    
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section==NAME_SECTION) {
        return [sections objectAtIndex:section];
    }
    
    if(section==ADDRESS_SECTION) {
        NSDictionary* contacts = [legislator objectForKey:@"contacts"];
        if (contacts==nil || [[NSNull null] isEqual:contacts]) {
            return nil;
        }
        return [sections objectAtIndex:section];
    }
    
    if (section==PHONE_SECTION) {
        NSDictionary* contacts = [legislator objectForKey:@"contacts"];
        if (contacts==nil || [[NSNull null] isEqual:contacts]) {
            return nil;
        }
        return [sections objectAtIndex:section];
    }
    
    if (section==EMAIL_SECTION) {
        return [sections objectAtIndex:section];
    }
    
    if (section==REFERENCES_SECTION) {
        return [sections objectAtIndex:section];
    }
    
    return nil;
}

- (void)configureElectoralDistrictCcell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    NSString* city = [legislator objectForKey:@"city"];
    NSString* electoralDistrict = [legislator objectForKey:@"electoral-district"];
    NSString* fullString = nil;
    if ([[LyModel getInstance] cityIsElectoralDistrict:city] || ![[LyModel getInstance] isRegionalElectoralDistrict:electoralDistrict]) {
        fullString = electoralDistrict;
    }
    else {
        NSString* city = [legislator objectForKey:@"city"];
        fullString = [city stringByAppendingString:electoralDistrict];
    }
    cell.textLabel.text = fullString;
}

- (void)configureNameCell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    NSString* name = [legislator objectForKey:@"name"];
    NSString* party = [legislator objectForKey:@"party"];
    UIImage* partyColorImage = [UIUtils imageWithColor:[UIUtils colorForParty:party] andSize:CGSizeMake(100, 100)];
    cell.imageView.image = partyColorImage;
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.textLabel.text = name;
    cell.detailTextLabel.text = party;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIUtils detailLabelFontSize]];
}

- (void)addressCellPressed:(ActionCell*)cell {
    AddressViewController* vc = [[AddressViewController alloc] initWithNibName:@"AddressView" bundle:nil];
    NSString* address = (NSString*)[cell propertyForKey:@"address"];
    NSString* location = (NSString*)[cell propertyForKey:@"location"];
    vc.title = location;
    vc.address = address;
    vc.placeName = location;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)configureAddressCell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    NSDictionary* contacts = [legislator objectForKey:@"contacts"];
    NSDictionary* addressMap = [contacts objectForKey:@"address"];
    NSArray* addressList = addressMap.allKeys;
    NSString* location = [addressList objectAtIndex:indexPath.row];
    cell.textLabel.text = location;
    NSString* fullAddress = [addressMap objectForKey:location];
    NSString* simplifiedAddress = [self simplifyAddress:fullAddress];
    cell.detailTextLabel.text = simplifiedAddress;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.action = @selector(addressCellPressed:);
    [cell setProperty:fullAddress forKey:@"address"];
    [cell setProperty:location forKey:@"location"];
}

- (void)openPhoneCall:(ActionCell*)cell {
    NSString* url = [NSString stringWithFormat:@"tel://%@", cell.detailTextLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)configurePhoneCell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    NSDictionary* contacts = [legislator objectForKey:@"contacts"];
    NSDictionary* phoneMap = [contacts objectForKey:@"phone"];
    NSArray* phoneList = phoneMap.allKeys;
    NSString* location = [phoneList objectAtIndex:indexPath.row];
    cell.textLabel.text = location;
    cell.detailTextLabel.text = [phoneMap objectForKey:location];
    cell.target = self;
    cell.action = @selector(openPhoneCall:);
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.canMakePhoneCall) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (NSString*)simplifyAddress:(NSString*)fullAddress {
    NSCharacterSet* charSet = [NSCharacterSet characterSetWithCharactersInString:@"路街村鎮里"];
    NSCharacterSet* numberSet = [NSCharacterSet decimalDigitCharacterSet];
    
    if ([[NSNull null] isEqual:fullAddress]) {
        NSLog(@"fullAddress is NSNull");
    }
    int end = (int)(fullAddress.length - 1);
    for (; end>=0; end--) {
        unichar ch = [fullAddress characterAtIndex:end];
        if ([charSet characterIsMember:ch]) {
            break;
        }
    }
    
    int start = 0;
    for (int i=0; i<fullAddress.length; i++) {
        unichar ch = [fullAddress characterAtIndex:i];
        if (![numberSet characterIsMember:ch]) {
            start = i;
            break;
        }
    }
    NSString* simplified = [fullAddress substringWithRange:NSMakeRange(start, end - start + 1)];
    return simplified;
}

- (void)emailCellPressed:(ActionCell*)cell {
    NSString* email = (NSString*)[cell propertyForKey:@"email"];
    NSString* name = [self->legislator objectForKey:@"name"];
    MFMailComposeViewController* vc = [[MFMailComposeViewController alloc] init];
    [vc setSubject:[NSString stringWithFormat:@"%@委員您好", name]];
    [vc setToRecipients:[NSArray arrayWithObject:email]];
    vc.mailComposeDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureEmailCell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    NSString* email = [[self->legislator objectForKey:@"contacts"] objectForKey:@"email"];
    cell.textLabel.text = email;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.action = @selector(emailCellPressed:);
    [cell setProperty:email forKey:@"email"];
}

- (void)openReferenceSite:(ActionCell*)cell {
    NSString* url = (NSString*)[cell propertyForKey:@"reference"];
    if (url==nil || [[NSNull null] isEqual:url]) {
        NSLog(@"cell.properties[reference] is null");
    }
    WebViewController* vc = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
    vc.urlString = url;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)configureReferencesCell:(ActionCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    
    NSDictionary* refs = [self->legislator objectForKey:@"references"];
    NSArray* keys = [refs.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString* s1 = (NSString*)obj1;
        NSString* s2 = (NSString*)obj2;
        return [s1 compare:s2];
    }];
    NSDictionary* referenceTypeNameMap = [NSDictionary dictionaryWithObjectsAndKeys:@"facebook", @"facebook", @"Wikipedia", @"wikipedia", @"立委投票指南", @"g0v.ly.vote", nil];
    NSString* type = [keys objectAtIndex:indexPath.row];
    NSString* typeName = [referenceTypeNameMap objectForKey:type];
    if (typeName==nil) {
        typeName = type;
    }
    NSString* referenceURL = [refs objectForKey:type];
    if (referenceURL==nil || [[NSNull null] isEqual:referenceURL]) {
        NSLog(@"referenceURL is null");
    }
    [cell setProperty:referenceURL forKey:@"reference"];
    UIImage* icon = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", type]];
    cell.textLabel.text = typeName;
    cell.target = self;
    cell.action = @selector(openReferenceSite:);
    cell.isNetworkConnectivityRequired = YES;
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.image = icon;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[ActionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell" target:self action:nil];
        [cell autorelease];
    }

    cell.action = nil;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIUtils detailLabelFontSize]];
    cell.detailTextLabel.text = nil;
    cell.isNetworkConnectivityRequired = NO;
    cell.isLocationServiceRequired = NO;
    NSValue* pCellConfigurator = [cellConfigurators objectAtIndex:indexPath.section];
    SEL cellConfigurator = (SEL)pCellConfigurator.pointerValue;
    [self performSelector:cellConfigurator withObject:cell withObject:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell* cell = (ActionCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell performAction];
}

- (void)dealloc {
    [sections release];
    [cellConfigurators release];
    [legislator release];
    [super dealloc];
}

@end

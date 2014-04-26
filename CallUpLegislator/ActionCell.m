//
//  ActionCell.m
//
//  Created by Ming Yang on 8/18/11.
//

#import "ActionCell.h"

@implementation ActionCell

@synthesize target;
@synthesize action;
@synthesize isNetworkConnectivityRequired;
@synthesize isLocationServiceRequired;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)_target action:(SEL)_action
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self->target = _target;
        [self->target retain];
        self->action = _action;
        self.isNetworkConnectivityRequired = NO;
        self.isLocationServiceRequired = NO;
        self->properties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [super setSelected:NO animated:YES];
    }
    // Configure the view for the selected state
    if (selected) {
        //[self performAction];
    }
}

- (BOOL)checkLocationService {
    BOOL locationServiceEnabled = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (!locationServiceEnabled) {
        UIAlertView* alertView = [UIUtils createAlertViewForDisabledLocationService];
        [alertView show];
        [alertView release];
        return NO;
    }
    if (authorizationStatus!=kCLAuthorizationStatusAuthorized) {
        UIAlertView* alertView = [UIUtils createAlertViewForUnauthorizedLocationService];
        [alertView show];
        [alertView release];
        return NO;
    }
    return YES;
}

- (BOOL)checkNetworkConnectivity {
    BOOL isReachable = [[Reachability reachabilityWithHostName:@"8.8.8.8"] isReachable];
    if (!isReachable) {
        UIAlertView* alert = [UIUtils createAlertViewForNetworkConnectivity];
        [alert show];
        [alert release];
    }
    return isReachable;
}

- (void)performAction {
    if (self.isNetworkConnectivityRequired) {
        BOOL networkConnectivityAvailable = [self checkNetworkConnectivity];
        if (!networkConnectivityAvailable) {
            return;
        }
    }
    
    if (self.isLocationServiceRequired) {
        BOOL locationServiceAvailable = [self checkLocationService];
        if (!locationServiceAvailable) {
            return;
        }
    }
    
    if (self.target!=nil && self.action!=nil) {
        [self.target performSelector:self.action withObject:self];
    }
}

- (NSObject*)propertyForKey:(NSString*)key {
    return [self->properties objectForKey:key];
}

- (void)setProperty:(NSObject*)value forKey:(NSString*)key {
    [self->properties setObject:value forKey:key];
}

- (void)dealloc {
    [self->target release];
    [self->properties release];
    [super dealloc];
}

@end

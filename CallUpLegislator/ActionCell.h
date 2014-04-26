//
//  ActionCell.h
//
//  Created by Ming Yang on 8/18/11.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "UIUtils.h"

@interface ActionCell : UITableViewCell {
    id target;
    SEL action;
    NSMutableDictionary* properties;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)_target action:(SEL)_action;
- (void)performAction;
- (NSObject*)propertyForKey:(NSString*)key;
- (void)setProperty:(NSObject*)value forKey:(NSString*)key;

@property (nonatomic, retain) id target;
@property (nonatomic) SEL action;
@property (nonatomic) BOOL isNetworkConnectivityRequired;
@property (nonatomic) BOOL isLocationServiceRequired;

@end

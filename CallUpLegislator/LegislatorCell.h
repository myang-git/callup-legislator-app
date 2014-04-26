//
//  LegislatorCell.h
//  Petition
//
//

#import "ActionCell.h"
#import "UIUtils.h"

@interface LegislatorCell : ActionCell {
    NSDictionary* legislator;
    BOOL displayPartyName;
}

@property (nonatomic, retain) NSDictionary* legislator;
@property (nonatomic) BOOL displayPartyName;

@end

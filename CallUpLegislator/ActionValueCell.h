//
//  ActionValueCell.h
//  Petition
//
//

#import "ActionCell.h"

@interface ActionValueCell : ActionCell {
    NSString* value;
    NSString* group;
}

@property (nonatomic, copy) NSString* value;
@property (nonatomic, copy) NSString* group;

@end

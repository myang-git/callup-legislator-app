//
//  ActionValueCell.m
//  Petition
//
//

#import "ActionValueCell.h"

@implementation ActionValueCell

@synthesize value;
@synthesize group;

- (void)dealloc {
    [value release];
    [group release];
    [super dealloc];
}

@end

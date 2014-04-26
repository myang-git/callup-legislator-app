//
//  LegislatorCell.m
//  Petition
//
//

#import "LegislatorCell.h"

@implementation LegislatorCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (NSDictionary*)legislator {
    return self->legislator;
}

- (BOOL)displayPartyName {
    return self->displayPartyName;
}

- (void)setDisplayPartyName:(BOOL)_displayPartyName {
    self->displayPartyName = _displayPartyName;
    if (self->displayPartyName) {
        [self setPartyName];
    }
    else {
        [self clearPartyName];
    }
    [self setNeedsDisplay];
}

- (void)clearPartyName {
    self.detailTextLabel.text = nil;
    self.detailTextLabel.textColor = [UIColor darkTextColor];
}

- (void)setPartyName {
    NSString* party = [self->legislator objectForKey:@"party"];
    self.detailTextLabel.text = party;
    self.detailTextLabel.textColor = [UIUtils colorForParty:party];
}

- (void)setLegislator:(NSDictionary *)_legislator {
    [self->legislator release];
    self->legislator = _legislator;
    [self->legislator retain];
    self.textLabel.text = [self->legislator objectForKey:@"name"];
    if (self.displayPartyName) {
    }
}

- (void)dealloc {
    [self->legislator release];
    [super dealloc];
}

@end

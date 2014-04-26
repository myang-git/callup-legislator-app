//
//  LyModel.h
//
//  Created by Ming Yang on 3/30/14.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#include "AFNetworking.h"

@interface LyModel : NSObject {
    NSMutableArray* legislatorList;
    NSMutableDictionary* electoralDistrictMap;
    NSDictionary* partyShortNameMap;
    NSSet* nonRegionalElectoralDistricts;
}

+ (LyModel*)getInstance;

+ (LyModel*)createWithLegislators:(NSArray*)legislators;

- (void)findLegislatorByLocation:(CLLocation*)location
                         success:(void (^)(NSDictionary* legislator))success
                         failure:(void (^)(NSError *error))failure;


- (BOOL)cityIsElectoralDistrict:(NSString*)city;

- (BOOL)isRegionalElectoralDistrict:(NSString*)district;

- (NSString*)shortNameForParty:(NSString*)party;

- (NSDictionary*)groupByAttributes:(NSString*)firstAttribute,...;

- (void)downloadLegislatorList:(void (^)(void))success failure:(void (^)(void))failure;

@end

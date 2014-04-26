//
//  LyModel.m
//
//  Created by Ming Yang on 3/30/14.
//

#import "LyModel.h"

@implementation LyModel

static LyModel* SINGLETON = nil;
static NSString* const LYDATA_URL = @"https://raw.githubusercontent.com/myang-git/taiwan-electoral-data/master/legislator-list.json";

+ (LyModel*)getInstance {
    @synchronized([LyModel class]) {
        if (SINGLETON==nil) {
            SINGLETON = [[LyModel alloc] init];
        }
        return SINGLETON;
    }
}

+ (LyModel*)createWithLegislators:(NSArray*)legislators {
    return [[LyModel alloc] setLegislators:legislators];
}

- (id)setLegislators:(NSArray*)legislators {
    legislatorList = [[NSMutableArray alloc] initWithArray:legislators];
    return self;
}

- (id)loadElectoralDistricts:(NSDictionary*)districts {
    electoralDistrictMap = [[NSMutableDictionary alloc] initWithDictionary:districts];
    return self;
}

- (id)init {
    if (self = [super init]) {
        partyShortNameMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"國", @"中國國民黨", @"民", @"民主進步黨", @"親", @"親民黨", @"台", @"台灣團結聯盟", @"盟", @"無黨團結聯盟", nil];
        nonRegionalElectoralDistricts = [[NSSet alloc] initWithObjects:@"山地原住民", @"平地原住民", @"全國不分區", @"僑居國外國民", nil];
        NSArray* legislatorListFromFile = [self readLegislatorListFromFile];
        [self setLegislators:[self processParsedLegislatorList:legislatorListFromFile]];
        [self loadElectoralDistricts:[self loadElectoralDistrictData]];
    }
    else {
        self = nil;
    }
    return self;
}

- (NSArray*)readLegislatorListFromFile {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"legislator-list" ofType:@"json"];
    NSString* legislatorListJsonString = [NSString stringWithContentsOfFile:path
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:nil];
    NSData* jsonData = [legislatorListJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* legislatorListFromJson = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:0
                                                                        error:nil];
    return legislatorListFromJson;
}

- (NSArray*)processParsedLegislatorList:(NSArray*)parsedList {
    NSMutableArray* list = [NSMutableArray array];
    for (NSDictionary* legislator in parsedList) {
        NSNumber* active = [legislator objectForKey:@"active"];
        NSLog(@"active: %@, type: %@", active, active.class);
        if (!active.boolValue) {
            continue;
        }
        NSMutableDictionary* augmented = [NSMutableDictionary dictionaryWithDictionary:legislator];
        NSString* name = [legislator objectForKey:@"name"];
        NSString* lastName = [name substringToIndex:1];
        [augmented setValue:lastName forKey:@"last-name"];
        [list addObject:augmented];
    }
    return list;
}

- (NSDictionary*)loadElectoralDistrictData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"electoral-district-map" ofType:@"json"];
    NSString* electoralDistrictMapJsonString = [NSString stringWithContentsOfFile:path
                                                                         encoding:NSUTF8StringEncoding
                                                                            error:nil];
    NSData* jsonData = [electoralDistrictMapJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* map = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    return map;
}


- (NSDictionary*)groupHelperWithDepth:(int)depth attributes:(NSArray*)attributes subgroup:(NSArray*)subgroup {

    NSMutableDictionary* temp = [NSMutableDictionary dictionary];
    NSString* attr = [attributes objectAtIndex:depth];
    for (NSDictionary* legislator in subgroup) {
        NSString* value = [legislator objectForKey:attr];
        if ([temp objectForKey:value]==nil) {
            [temp setObject:[NSMutableArray array] forKey:value];
        }
        [[temp objectForKey:value] addObject:legislator];
    }
    
    if (depth==attributes.count-1) {
        return temp;
    }
    
    NSMutableDictionary* maps = [NSMutableDictionary dictionary];

    for (NSString* attrValue in temp) {
        NSArray* subgroup = [temp objectForKey:attrValue];
        [maps setObject:[self groupHelperWithDepth:depth+1 attributes:attributes subgroup:subgroup] forKey:attrValue];
    }
    
    return maps;
}

- (NSDictionary*)groupByAttributes:(NSString*)firstAttribute,... {
    va_list attributes;
    va_start(attributes, firstAttribute);
    NSMutableArray* attributeArray = [NSMutableArray array];
    for (NSString* attribute = firstAttribute; attribute!=nil; attribute = va_arg(attributes, NSString*)) {
        [attributeArray addObject:attribute];
    }
    return [self groupHelperWithDepth:0 attributes:attributeArray subgroup:legislatorList];
}

- (BOOL)isNull:(id)value {
    return value==nil || [[NSNull null] isEqual:value];
}

- (NSDictionary*)findElectoralDistrictByCity:(NSString*)city locality:(NSString*)locality sublocality:(NSString*)sublocality {
    id target = [electoralDistrictMap objectForKey:city];
    if ([self isNull:target]) {
        return nil;
    }
    if (![target isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:target, @"district", city, @"city", nil];
    }
    
    target = [((NSDictionary*)target) objectForKey:locality];
    if ([self isNull:target]) {
        return nil;
    }
    if (![target isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:target, @"district", city, @"city", locality, @"locality", nil];
    }
    
    target = [((NSDictionary*)target) objectForKey:sublocality];
    if ([self isNull:target]) {
        return nil;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:target, @"district", city, @"city", locality, @"locality", sublocality, @"sublocality", nil];
}

- (NSDictionary*)findLegislatorForOverseas {
    for (NSDictionary* legislator in legislatorList) {
        NSString* electoralDistrict = [legislator objectForKey:@"electoral-district"];
        if ([electoralDistrict isEqualToString:@"僑居國外國民"]) {
            return legislator;
        }
    }
    return nil;
}

- (NSDictionary*)findLegislatorByCity:(NSString*)city locality:(NSString*)locality sublocality:(NSString*)sublocality {
    NSDictionary* district = [self findElectoralDistrictByCity:city locality:locality sublocality:sublocality];
    if (district==nil) {
        return nil;
    }
    NSString* districtCity = [district objectForKey:@"city"];
    NSString* districtName = [district objectForKey:@"district"];
    
    for (NSDictionary* legislator in legislatorList) {
        NSString* legislatorCity = [legislator objectForKey:@"city"];
        NSString* legislatorDistrict = [legislator objectForKey:@"electoral-district"];
        if ([legislatorCity isEqualToString:districtCity] && [legislatorDistrict isEqualToString:districtName]) {
            return legislator;
        }
    }
    return nil;
}

- (NSDictionary*)parseGeocoderResult:(id)JSON {
    NSArray* results = [JSON objectForKey:@"results"];
    NSString* country = nil;
    NSString* city = nil;
    NSString* locality = nil;
    NSString* sublocality = nil;
    BOOL found = NO;
    for (NSDictionary* result in results) {
        NSArray* addressComponents = [result objectForKey:@"address_components"];
        for (NSDictionary* addressComponent in addressComponents) {
            NSArray* types = [addressComponent objectForKey:@"types"];
            for (NSString* type in types) {
                if (city==nil && [type caseInsensitiveCompare:@"administrative_area_level_2"]==NSOrderedSame) {
                    city = [[addressComponent objectForKey:@"long_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    break;
                }
                else if (locality==nil && [type caseInsensitiveCompare:@"locality"]==NSOrderedSame) {
                    locality = [[addressComponent objectForKey:@"long_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    break;
                }
                else if(sublocality==nil && [type caseInsensitiveCompare:@"sublocality"]==NSOrderedSame) {
                    sublocality = [[addressComponent objectForKey:@"long_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    break;
                }
                else if (country==nil && [type caseInsensitiveCompare:@"country"]==NSOrderedSame) {
                    country = [[addressComponent objectForKey:@"short_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    break;
                }
            }
        }
        found = (city!=nil && locality!=nil);
        if (found) {
            break;
        }
    }
    if (!found) {
        if (sublocality!=nil && [sublocality caseInsensitiveCompare:@"連江縣"]==NSOrderedSame) {
            city = @"連江縣";
            locality = @"連江縣";
        }
    }
    NSDictionary* location = [NSDictionary dictionaryWithObjectsAndKeys:city, @"city", locality, @"locality", sublocality, @"sublocality", country, @"country" ,nil];
    return location;
}

- (void)findLegislatorByLocation:(CLLocation*)location
                         success:(void (^)(NSDictionary* legislator))success
                         failure:(void (^)(NSError *error))failure {
    NSString* urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%.6f,%.6f&language=zh-TW&sensor=true", location.coordinate.latitude, location.coordinate.longitude];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation* op =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSDictionary* geolocation = [self parseGeocoderResult:JSON];
                                                        NSString* country = [geolocation objectForKey:@"country"];
                                                        NSString* city = [geolocation objectForKey:@"city"];
                                                        NSString* locality = [geolocation objectForKey:@"locality"];
                                                        NSString* sublocality = [geolocation objectForKey:@"sublocality"];
                                                        NSDictionary* legislator = nil;
                                                        
                                                        if ([@"TW" isEqualToString:country]) {
                                                            legislator = [self findLegislatorByCity:city locality:locality sublocality:sublocality];
                                                        }
                                                        else {
                                                            legislator = [self findLegislatorForOverseas];
                                                        }
                                                        
                                                        if (legislator!=nil) {
                                                            success(legislator);
                                                        }
                                                        else {
                                                            failure([NSError errorWithDomain:@"geocoding" code:990 userInfo:nil]);
                                                        }
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        failure(error);
                                                    }];
    [op start];
}

- (BOOL)cityIsElectoralDistrict:(NSString*)city {
    id district = [electoralDistrictMap objectForKey:city];
    if (district==nil || [[NSNull null] isEqual:district]) {
        return NO;
    }
    if ([district isKindOfClass:[NSString class]]) {
        return [city isEqualToString:district];
    }
    else {
        return NO;
    }
    
}

- (BOOL)isRegionalElectoralDistrict:(NSString*)district {
    return ![nonRegionalElectoralDistricts containsObject:district];
}

- (NSString*)shortNameForParty:(NSString *)party {
    return [partyShortNameMap objectForKey:party];
}

- (void)dealloc {
    [partyShortNameMap release];
    [legislatorList release];
    [electoralDistrictMap release];
    [nonRegionalElectoralDistricts release];
    [super dealloc];
}

- (void)downloadLegislatorList:(void (^)(void))success failure:(void (^)(void))failure {
    NSURL* url = [NSURL URLWithString:LYDATA_URL];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    [request setValue:@"text/json" forHTTPHeaderField:@"content-type"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/plain", @"text/json", @"application/json", @"text/javascript", nil]];
    AFJSONRequestOperation* op =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        @try {
                                                            NSArray* newList = [self processParsedLegislatorList:JSON];
                                                            [self setLegislators:newList];
                                                            success();
                                                        }
                                                        @catch (NSException *exception) {
                                                            NSLog(@"%@", exception.description);
                                                            failure();
                                                        }
                                                        
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        failure();
                                                    }];
    [op start];
}

@end

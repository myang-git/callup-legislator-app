//
//  AddressViewController.m
//
//  Created by Ming Yang on 4/9/14.
//

#import "AddressViewController.h"

@interface AddressViewController ()

@end

@implementation AddressViewController
@synthesize address;
@synthesize placeName;
@synthesize mapViewPlaceholder;
@synthesize addressTextView;

static double const DEFAULT_LAT = 25.0439998;
static double const DEFAULT_LNG = 121.5195803;
static float const DEFAULT_ZOOM = 17;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addressLocation = CLLocationCoordinate2DMake(-9999, -9999);
        finishedMapInitialization = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:DEFAULT_LAT
                                                            longitude:DEFAULT_LNG
                                                                 zoom:DEFAULT_ZOOM];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 640) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;
    [self.mapViewPlaceholder removeFromSuperview];
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:self.addressTextView];
    [self startLookingUpCoordinatesForAddress:self.address];
}

- (void)configureAddressTextView {
    [self.addressTextView sizeToFit];
    CGRect addressFrame = self.addressTextView.frame;
    CGSize viewSize = self.view.frame.size;
    int newFrameX = (int)((viewSize.width - addressFrame.size.width) / 2.0);
    CGRect newAddressFrame = CGRectMake(newFrameX, addressFrame.origin.y, addressFrame.size.width, addressFrame.size.height);
    self.addressTextView.frame = newAddressFrame;
}

- (void)mapView:(GMSMapView *)mapView_ idleAtCameraPosition:(GMSCameraPosition *)position {
    if (!finishedMapInitialization && CLLocationCoordinate2DIsValid(addressLocation)) {
        GMSMarker* marker = [GMSMarker markerWithPosition:addressLocation];
        marker.title = self.placeName;
        marker.map = mapView_;
        marker.snippet = self.address;
        [mapView setSelectedMarker:marker];
        self.addressTextView.text = self.address;
        [self.addressTextView selectAll:self];
        [self.addressTextView sizeToFit];
        [self configureAddressTextView];
        finishedMapInitialization = YES;
    }
}

- (CLLocationCoordinate2D)parseGeocodingResultData:(id)data {
    NSString* status = [data objectForKey:@"status"];
    if (status==nil || ![status isEqualToString:@"OK"]) {
        return CLLocationCoordinate2DMake(-9999, -9999);
    }
    NSArray* results = [data objectForKey:@"results"];
    if (results==nil || results.count==0) {
        return CLLocationCoordinate2DMake(-9999, -9999);
    }
    NSDictionary* result1 = [results firstObject];
    NSDictionary* geometry = [result1 objectForKey:@"geometry"];
    if (geometry==nil) {
        return CLLocationCoordinate2DMake(-9999, -9999);
    }
    NSDictionary* location = [geometry objectForKey:@"location"];
    if (location==nil) {
        return CLLocationCoordinate2DMake(-9999, -9999);
    }
    double lat = [[location objectForKey:@"lat"] doubleValue];
    double lng = [[location objectForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(lat, lng);
    
    return coordinates;
}

- (void)setMapAtDefaultLocation {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:DEFAULT_LAT
                                                            longitude:DEFAULT_LNG
                                                                 zoom:DEFAULT_ZOOM];
    mapView.camera = camera;
}

- (void)setMapAtLocation:(CLLocationCoordinate2D)location {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:DEFAULT_ZOOM];
    mapView.camera = camera;
    addressLocation = location;
}

- (void)unableToFindLocationWithError:(NSError*)error {
    [self setMapAtDefaultLocation];
}

- (void)startLookingUpCoordinatesForAddress:(NSString*)address_ {
    if ([address_ rangeOfString:@"連江"].location!=NSNotFound) {
        address_ = [address_ stringByReplacingOccurrencesOfString:@"連江縣" withString:@"馬祖"];
    }
    NSString* addressWithTaiwan = [@"台灣" stringByAppendingString:address_];
    NSString* urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", addressWithTaiwan];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation* op =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        CLLocationCoordinate2D location = [self parseGeocodingResultData:JSON];
                                                        if (CLLocationCoordinate2DIsValid(location)) {
                                                            [self setMapAtLocation:location];
                                                        }
                                                        else {
                                                            [self unableToFindLocationWithError:nil];
                                                        }
        
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        [self unableToFindLocationWithError:error];
                                                    }];
    [op start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [address release];
    [placeName release];
    [mapViewPlaceholder release];
    [addressTextView release];
    [super dealloc];
}

@end

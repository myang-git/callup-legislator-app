//
//  AddressViewController.h
//
//  Created by Ming Yang on 4/9/14.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AFNetworking.h"

@interface AddressViewController : UIViewController <GMSMapViewDelegate> {
    GMSMapView* mapView;
    BOOL finishedMapInitialization;
    CLLocationCoordinate2D addressLocation;
}

@property (nonatomic, retain) IBOutlet UIView* mapViewPlaceholder;
@property (nonatomic, retain) IBOutlet UITextView* addressTextView;
@property (nonatomic, copy) NSString* placeName;
@property (nonatomic, copy) NSString* address;

@end

//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Kagan Riedel on 1/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *myMapView;
    NSArray *busStops;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://dev.mobilemakers.co/lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         busStops = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"row"];
         NSLog(@"%i", busStops.count);
         
         
         for (NSDictionary *busStop in busStops)
         {
             NSString *longitude = busStop[@"location"][@"longitude"];
             NSString *latitude = busStop[@"location"][@"latitude"];
             
             CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
             
         
             MKPointAnnotation *annotation = [MKPointAnnotation new];
             annotation.title = busStop[@"cta_stop_name"];
             annotation.coordinate = location;
             [myMapView addAnnotation:annotation];
         
         }
         
     }];
    
    
    
    
  
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(41.89373984, -87.63532979);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [myMapView setRegion:region animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation)
    {
        return nil;
    }
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapAnnotation"];
    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
        //Watch out! make sure this is MKPinAnnotationView instead of MKAnnotationView!!!
    } else {
        annotationView.annotation = annotation;
    }
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}




@end

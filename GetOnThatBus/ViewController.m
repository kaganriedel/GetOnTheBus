//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Kagan Riedel on 1/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "BusAnnotation.h"
#import "MapDetailViewController.h"

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
         
         for (NSDictionary *busStop in busStops)
         {
             NSString *longitude = busStop[@"location"][@"longitude"];
             NSString *latitude = busStop[@"location"][@"latitude"];
             
             CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
            
             BusAnnotation *annotation = [BusAnnotation new];
             annotation.title = busStop[@"cta_stop_name"];
             annotation.subtitle = busStop[@"routes"];
             annotation.coordinate = location;
             annotation.transfers = busStop[@"inter_modal"];
             annotation.clLocation = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
             
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

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(BusAnnotation*)annotation
{
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
    if ([annotation.transfers isEqualToString:@"Metra"])
    {
        annotationView.image = [UIImage imageNamed:@"Metra.gif"];
    } else if ([annotation.transfers isEqualToString:@"Pace"])
    {
        annotationView.image = [UIImage imageNamed:@"Pace.png"];
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    MapDetailViewController *vc = segue.destinationViewController;
    BusAnnotation *busAnnotation = sender.annotation;
    vc.busAnnotation = busAnnotation;
}

@end

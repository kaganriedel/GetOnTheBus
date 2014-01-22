//
//  MapDetailViewController.m
//  GetOnThatBus
//
//  Created by Kagan Riedel on 1/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MapDetailViewController.h"

@interface MapDetailViewController ()
{
    __weak IBOutlet UILabel *routesLabel;
    __weak IBOutlet UILabel *transfersLabel;
    __weak IBOutlet UILabel *addressLabel;
    
}

@end

@implementation MapDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _busAnnotation.title;
    routesLabel.text = _busAnnotation.subtitle;
    
    if (_busAnnotation.transfers != nil) {
        transfersLabel.text = _busAnnotation.transfers;
    }
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:_busAnnotation.clLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        addressLabel.text = placemark.name;
        NSLog(@"Found %@", placemark.name);
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

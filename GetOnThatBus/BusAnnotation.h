//
//  BusAnnotation.h
//  GetOnThatBus
//
//  Created by Kagan Riedel on 1/21/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BusAnnotation : MKPointAnnotation
@property NSString *transfers;
@property CLLocation *clLocation;
@end

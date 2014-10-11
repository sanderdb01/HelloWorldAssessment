//
//  HWLocation.h
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/9/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HWConstants.h"

@interface HWLocation : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipPostalCode;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *officeImage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address2;
@property float distanceFromUser;

-(id)initWithDictionaryData:(NSDictionary *)locationDictionary;


@end

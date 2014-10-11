//
//  HWLocation.m
//  HelloWorldAssesment
//
//  Created by David Sanders on 10/9/14.
//  Copyright (c) 2014 Bitfountain.io. All rights reserved.
//

#import "HWLocation.h"
#import "HWConstants.h"

@implementation HWLocation

-(id)initWithDictionaryData:(NSDictionary *)locationDictionary
{
    self = [super init];
    
    self.address = locationDictionary[kHWAddressKey];
    self.city = locationDictionary[kHWCityKey];
    self.state = locationDictionary[kHWStateKey];
    self.zipPostalCode = locationDictionary[kHWZipPostalCodeKey];
    self.phone = locationDictionary[kHWPhoneKey];
    self.fax = locationDictionary[kHWFaxKey];
    self.longitude = locationDictionary[kHWLongitudeKey];
    self.latitude = locationDictionary[kHWLatitudeKey];
    self.officeImage = locationDictionary[kHWOfficeImageKey];
    self.name = locationDictionary[kHWNameKey];
    self.address2 = locationDictionary[kHWAddress2Key];
    
    return self;
}

@end

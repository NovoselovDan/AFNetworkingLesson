//
//  PLCPlaceMapper.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCPlaceMapper.h"
#import "PLCPlace.h"

NSString *const APIKey = @"AIzaSyBhpEhL8vvERVuY9ynrHuElB7kEKdWyiHI";

@implementation PLCPlaceMapper

+ (PLCPlace *)placeWithDictionary:(NSDictionary *)dictionary
{
    PLCPlace *result = [PLCPlace new];
    NSString *name = dictionary[@"name"] ? : @"";
    NSString *address = dictionary[@"formatted_address"] ? : @"";
    
    result.name = name;
    result.address = address;
    
    NSArray *photos = dictionary[@"photos"];
    
    if (photos.count == 0) {
        result.imageURL = nil;
        return result;
    }
    
    NSDictionary *photo = photos.firstObject;
    NSString *photoRef = photo[@"photo_reference"] ? : @"";
    if (![photoRef isEqualToString:@""]) {
        result.imageURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@", photoRef, APIKey];
    } else {
        result.imageURL = nil;
    }
    
    NSLog(@"result URL: %@", result.imageURL);

    return result;
}

@end

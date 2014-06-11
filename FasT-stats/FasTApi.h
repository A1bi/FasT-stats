//
//  FasTApi.h
//  FasT-stats
//
//  Created by Albrecht Oster on 11.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FasTApiResponseBlock)(NSDictionary *response);

@class MKNetworkEngine;

@interface FasTApi : NSObject
{
    MKNetworkEngine *netEngine;
}

+ (FasTApi *)defaultApi;
- (void)registerDeviceTokenWithServer:(NSString *)token;

@end

//
//  FasTApi.m
//  FasT-stats
//
//  Created by Albrecht Oster on 11.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "FasTApi.h"

#import <AFNetworking.h>

static FasTApi *defaultApi = nil;

@interface FasTApi ()
{
    AFHTTPSessionManager *http;
}

- (void)POST:(NSString *)path data:(NSDictionary *)data callback:(FasTApiResponseBlock)callback;

@end


@implementation FasTApi

+ (FasTApi *)defaultApi
{
    if (!defaultApi) {
        defaultApi = [[super allocWithZone:NULL] init];
    }
    return defaultApi;
}

- (id)init
{
    self = [super init];
    if (self) {
        http = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_HOST]];
        [http setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [http setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

#pragma mark public methods

- (void)registerDeviceTokenWithServer:(NSString *)appName token:(NSString *)token settings:(NSDictionary *)settings
{
    NSString *path = [NSString stringWithFormat:@"/api/push_notifications"];
    NSDictionary *data = @{@"app": appName, @"token": token, @"settings": settings};
    [self POST:path data:data callback:NULL];
}

#pragma mark private methods

- (void)POST:(NSString *)path data:(NSDictionary *)data callback:(FasTApiResponseBlock)callback
{
    [http POST:path parameters:data progress:nil success:^(NSURLSessionDataTask *task, id response) {
        if (callback) callback(response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        if (callback) callback(nil);
    }];
}

@end

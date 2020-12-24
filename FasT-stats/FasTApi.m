//
//  FasTApi.m
//  FasT-stats
//
//  Created by Albrecht Oster on 11.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "FasTApi.h"

@interface FasTApi ()

+ (void)makeRequestWithMethod:(NSString *)method action:(NSString *)action parameters:(NSDictionary *)params data:(NSDictionary *)data completion:(nullable void (^)(id _Nullable response, NSError * _Nullable error))completion;
+ (NSURLSession *)session;
+ (NSURL *)urlWithPath:(NSString *)action params:(NSDictionary *)params;

@end


@implementation FasTApi

#pragma mark public methods

+ (void)registerDeviceTokenWithServer:(NSString *)appName token:(NSString *)token settings:(NSDictionary *)settings
{
    NSString *path = [NSString stringWithFormat:@"/api/push_notifications"];
    NSDictionary *data = @{@"app": appName, @"token": token, @"settings": settings};
    [self makeRequestWithMethod:@"POST" action:path parameters:nil data:data completion:NULL];
}

#pragma mark private methods

+ (void)makeRequestWithMethod:(NSString *)method action:(NSString *)action parameters:(NSDictionary *)params data:(NSDictionary *)data completion:(nullable void (^)(id _Nullable, NSError * _Nullable))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlWithPath:action params:params]];
    request.HTTPMethod = method;
    
    if (data) {
        NSData *body = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
        request.HTTPBody = body;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSURLSessionDataTask *task = [[self session] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!completion) return;
        
        NSDictionary *jsonResponse;
        if (data) {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }
        completion(jsonResponse, error);
    }];
    
    [task resume];
}

+ (NSURLSession *)session {
    static NSURLSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = @{ @"Accept": @"application/json" };
        sharedSession = [NSURLSession sessionWithConfiguration:config];
    });
    return sharedSession;
}

+ (NSURL *)urlWithPath:(NSString *)path params:(NSDictionary *)params {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunknown-escape-sequence"
    NSString *url = [NSString stringWithFormat:@"%@%@", NSStringize(API_HOST), path];
    #pragma clang diagnostic pop

    NSURLComponents *components = [NSURLComponents componentsWithString:url];

    if (params) {
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in params) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:params[key]]];
        }
        components.queryItems = queryItems;
    }

    return components.URL;
}


@end

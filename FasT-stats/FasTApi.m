//
//  FasTApi.m
//  FasT-stats
//
//  Created by Albrecht Oster on 11.06.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "FasTApi.h"
#import "MKNetworkEngine.h"

static FasTApi *defaultApi = nil;

#ifdef DEBUG
    static NSString *kFasTApiUrl = FAST_API_URL;
#else
    static NSString *kFasTApiUrl = @"theater-kaisersesch.de";
#endif


@interface FasTApi ()

- (void)makeRequestWithPath:(NSString *)path method:(NSString *)method data:(NSDictionary *)data callback:(FasTApiResponseBlock)callback;

@end


@implementation FasTApi

+ (FasTApi *)defaultApi
{
    if (!defaultApi) {
        defaultApi = [[super allocWithZone:NULL] init];
    }
    return defaultApi;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self defaultApi] retain];
}

- (id)init
{
    self = [super init];
    if (self) {
        netEngine = [[MKNetworkEngine alloc] initWithHostName:kFasTApiUrl];
    }
    return self;
}

#pragma mark public methods

- (void)registerDeviceTokenWithServer:(NSString *)token
{
    NSString *path = [NSString stringWithFormat:@"/api/push_notifications"];
    NSDictionary *data = @{@"app": @"stats", @"token": token};
    
    [self makeRequestWithPath:path method:@"POST" data:data callback:NULL];
}

#pragma mark private methods

- (void)makeRequestWithPath:(NSString *)path method:(NSString *)method data:(NSDictionary *)data callback:(FasTApiResponseBlock)callback
{
	MKNetworkOperation *op = [netEngine operationWithPath:path params:data httpMethod:method ssl:YES];
	[op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
	
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		if (callback) callback([completedOperation responseJSON]);
        
	} errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
		NSLog(@"%@", error);
        if (callback) callback(nil);
	}];
    
#if DEBUG
    [op setShouldContinueWithInvalidCertificate:YES];
#endif
	
	[netEngine enqueueOperation:op];
}

@end

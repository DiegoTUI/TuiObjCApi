//
//  TuiUrlReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiUrlReader.h"
#import "TuiHttpRequest.h"

#define TUI_NUMBER_OF_CONNECTION_RETRIES 3

#pragma mark - Private Interface
@interface TuiUrlReader ()

@end

#pragma mark - Implementation
@implementation TuiUrlReader

#pragma mark - Public methods
+(TuiUrlReader *)sharedInstance
{
    static TuiUrlReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiUrlReader alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSData *)readFromUrl:(TuiParametrizedUrl *)url {
    NSData *response = nil;
    
    NSInteger retries = TUI_NUMBER_OF_CONNECTION_RETRIES;
    NSInteger current = 0;
    
    if (self.testOffline)
        @throw [NSException exceptionWithName:@"TuiOfflineException" reason:@"Offline for tests" userInfo:nil];
    
    while (current < retries)
    {
        @try {
            if ([url isPost])
                response = [TuiHttpRequest synchronousPostRequestWithURL:[url getRawURL]];
            else
                response = [TuiHttpRequest synchronousGetRequestWithURL:[url getRawURL]];
            self.offline = false;
            return response;
        }
        @catch (NSException *exception) { //Could be offline exception or any other error
            if (current == (retries - 1))
            {
                self.offline = true;
                @throw exception;
            }
            NSLog(@"Error in connection, retrying: %@", url);
        }
        current ++;
    }
    // should never get here anyway
    @throw [NSException exceptionWithName:@"TuiOfflineException" reason:@"No connection" userInfo:nil];
}

#pragma mark - Private methods


@end

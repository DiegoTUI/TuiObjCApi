//
//  TuiJsonReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiJsonReader.h"
#import "TuiUrlReader.h"
#import "NSDictionary+Tui.h"

#pragma mark - Private interface
@interface TuiJsonReader()

@end

#pragma mark - Implementation
@implementation TuiJsonReader

#pragma mark - Public methods
+(TuiJsonReader *)sharedInstance {
    static TuiJsonReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiJsonReader alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSDictionary *)readJsonFromUrl:(TuiParametrizedUrl *)url {
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url];
    
    NSError *JSONError = nil;
    id JSONDictionary = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0
                                                          error:&JSONError];
    if (JSONError)
        @throw [NSException exceptionWithName:@"TuiInvalidUrlException" reason:[NSString stringWithFormat:@"Exception reading JSON from %@",url] userInfo:[JSONError userInfo]];
    
    return [(NSDictionary *)JSONDictionary dictionaryByUnescapingStringsInValues];
}

-(NSDictionary *)readJsonFromString:(NSString *)string {
    NSData *response = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *JSONError = nil;
    id JSONDictionary = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0
                                                          error:&JSONError];
    if (JSONError)
        @throw [NSException exceptionWithName:@"TuiInvalidJsonStringException" reason:[NSString stringWithFormat:@"Exception reading JSON from %@",string] userInfo:[JSONError userInfo]];
    
    return [(NSDictionary *)JSONDictionary dictionaryByUnescapingStringsInValues];
}

#pragma mark - Private methods

@end

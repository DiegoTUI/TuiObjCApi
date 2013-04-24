//
//  TuiJsonStorer.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiJsonStorer.h"
#import "TuiClassManager.h"
#import "NSObject+Tui.h"
#import "TuiContextCache.h"
#import "TuiJsonReader.h"

#pragma mark - Private interface
@interface TuiJsonStorer ()

@end

#pragma mark - Implementation
@implementation TuiJsonStorer

#pragma mark - Public Methods
+(TuiJsonStorer *)sharedInstance {
    static TuiJsonStorer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiJsonStorer alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)storeObject:(NSObject *)object
          withName:(NSString *)name {
    NSError *error;
    NSDictionary *jsonobject = nil;
    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]])
        jsonobject = (NSDictionary *)object;
    else
        jsonobject = [object convertObjectToJson];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:jsonobject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil)
        @throw [NSException exceptionWithName:@"TuiJsonParsingException" reason:[NSString stringWithFormat:@"Error while parsing object: %@ with code: %d and description: %@",object,[error code],[error localizedDescription]] userInfo:[error userInfo]];
    
    
    NSString *jsonstring = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    
    [[TuiContextCache sharedInstance] storeValue:jsonstring forKey:name];
    
}

-(void)deleteObjectWithName:(NSString *)name {
    [[TuiContextCache sharedInstance] removeObjectWithKey:name];
}

-(NSObject *)retrieveObjectOfType:(Class)type
                         withName:(NSString *)name {
    NSString *jsonstring = (NSString *)[[TuiContextCache sharedInstance]readValueForKey:name];
    
    if (jsonstring == nil)
        return nil;
    
    NSDictionary *jsonobject = [[TuiJsonReader sharedInstance] readJsonFromString:jsonstring];
    
    return [[TuiJsonReader sharedInstance] readObjectOfClass:type usingDictionary:jsonobject];
}

#pragma mark - Private methods


@end

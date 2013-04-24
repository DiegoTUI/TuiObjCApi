//
//  TuiContextCache.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiContextCache.h"

#pragma mark - Private interface
@interface TuiContextCache()

@property (strong,nonatomic) NSUserDefaults *userDefaults;

@end

#pragma mark - Implementation
@implementation TuiContextCache

#pragma mark - Public methods
+(TuiContextCache *)sharedInstance
{
    static TuiContextCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiContextCache alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)setTestUserDefaults:(NSUserDefaults *)userDefaults
{
    _userDefaults = userDefaults;
}

-(id)readValueForKey:(NSString *)key
{
    return [_userDefaults objectForKey:key];
}

-(void)removeObjectWithKey:(NSString *)key
{
    [_userDefaults removeObjectForKey:key];
}

-(void)storeValue:(id)value forKey:(NSString *)key
{
    [_userDefaults setObject:value forKey:key];
}

#pragma mark - Private methods

#pragma mark - NSObject methods
-(TuiContextCache *)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

@end

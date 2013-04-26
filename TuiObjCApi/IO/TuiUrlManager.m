//
//  TuiUrlManager.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/26/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiUrlManager.h"
#import "TuiJsonReader.h"
#import "TuiJsonStorer.h"
#import "TuiContextCache.h"
//#import "TuiParametrizedUrl.h"

#pragma mark - Private interface
@interface TuiUrlManager ()

//The dictionary with the keys and feeds
@property (strong, nonatomic) NSDictionary *urlList;
//The base URL for the calls
@property (strong,nonatomic) NSString *baseUrl;

/**
 * Read the list of urls from _baseUrl and store the results in _urlList
 */
-(void)readUrlList;

/**
 * Reads the param url string.
 * @param key the original key.
 * @return the parametrized url as a string.
 * @throws TuiObjectNotFoundException.
 */
-(NSString *)readUrlForKey:(NSString *)key;

@end

#pragma mark - Implementation
@implementation TuiUrlManager

#pragma mark - Public methods
-(TuiParametrizedUrl *)getUrlWithKey:(NSString *)key {
    NSString *rawurl = [self readUrlForKey:key];
    return [[TuiParametrizedUrl alloc] initWithUrl:rawurl];
}

#pragma mark - Private methods
-(void)readUrlList {
    TuiParametrizedUrl *url = [[TuiParametrizedUrl alloc] initWithUrl:_baseUrl];
    @try {
        _urlList = [[TuiJsonReader sharedInstance] readJsonFromUrl:url];
        [[TuiJsonStorer sharedInstance] storeObject:_urlList
                                           withName:@"url_list"];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not read XML file");
        NSDictionary *retrieved = (NSDictionary *)[[TuiJsonStorer sharedInstance] retrieveObjectOfType:[NSDictionary class] withName:@"url_list"];
        if (retrieved != nil)
            _urlList = retrieved;
    }
}

-(NSString *)readUrlForKey:(NSString *)key {
    //check if we have the list of urls cached
    if ([[TuiContextCache sharedInstance] readValueForKey:@"url_list"]) {
        return (NSString *)[_urlList valueForKey:key];
    }
    
    [self readUrlList];
    
    if (![[TuiContextCache sharedInstance] readValueForKey:@"url_list"])
        @throw [NSException exceptionWithName:@"TuiObjectNotFoundException" reason:[NSString stringWithFormat:@"Servers not available"] userInfo:nil];
    return (NSString *)[_urlList valueForKey:key];
}

#pragma mark - NSObject methods
-(TuiUrlManager *)init {
    self = [super init];
    if (self) {
        _baseUrl = @"http://54.246.80.107/api/list_url_services.php";
        _urlList = [NSDictionary dictionary];
        [self readUrlList];
    }
    return self;
}

@end

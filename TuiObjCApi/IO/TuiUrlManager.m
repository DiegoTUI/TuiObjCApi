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
#import "TuiParametrizedUrl.h"

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

@end

#pragma mark - Implementation
@implementation TuiUrlManager

#pragma mark - Public methods

#pragma mark - Private methods
-(void)readUrlList {
   /* @try {
        _urlList = [[TuiJsonReader sharedInstance] readJsonFromURL:_baseUrl withMethod:@"GET"];
        [[TuiJsonStorer sharedInstance] storeObject:_xmlList
                                           withName:[@"xml_list" stringByAppendingString:_feed]];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not read XML file");
        NSDictionary *retrieved = (NSDictionary *)[[TuiJsonStorer sharedInstance] retrieveObjectOfType:[NSDictionary class] withName:[@"xml_list" stringByAppendingString:_feed]];
        if (retrieved != nil)
            _xmlList = retrieved;
    }*/
}

#pragma mark - NSObject methods
-(TuiUrlManager *)init {
    self = [super init];
    if (self) {
        _baseUrl = @"http://54.246.80.107/api/list_url_services.php";
        _urlList = [NSDictionary dictionary];
    }
    return self;
}

@end

//
//  TuiXmlManager.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/22/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlManager.h"
#import "TuiJsonReader.h"
#import "TuiJsonStorer.h"
#import "TuiContextCache.h"
#import "TuiParametrizedXml.h"
#import "NSDictionary+Tui.h"

#pragma mark - Private interface
@interface TuiXmlManager ()

//The dictionary with the keys and feeds
@property (strong, nonatomic) NSDictionary *xmlList;
//The base URL for the calls
@property (strong,nonatomic) NSString *baseURL;
//The type of feed used for this XML manager
@property (strong, nonatomic) NSString *feed;

/**
 * Read the list of xmls from the given URL and store the results in _xmlList
 * @param url the url to read from.
 */
-(void)readXmlListFromUrl:(NSString *)url;

/**
 * Reads the param xml string.
 * @param key the original key.
 * @return the parametrized url as a string.
 * @throws TuiObjectNotFoundException.
 */
-(NSString *)readXmlForKey:(NSString *)key;

/**
 * Converts all the values of _xmlList to strings.
 * @throws TuiJsonParsingException.
 */
-(void)stringifyXmlList;

@end

#pragma mark - Implementation
@implementation TuiXmlManager

#pragma mark - Public methods
-(TuiXmlManager *)initWithJsonFeed {
    self = [self init];
    if (self) {
        _feed = @"json";
        NSString *url = [_baseURL stringByAppendingString:_feed];
        [self readXmlListFromUrl:url];
        
    }
    return self;
}

-(TuiXmlManager *)initWithXmlFeed {
    self = [self init];
    if (self) {
        _feed = @"xml";
        NSString *url = [_baseURL stringByAppendingString:_feed];
        [self readXmlListFromUrl:url];
        
    }
    return self;
}

-(TuiParametrizedXml *)getXmlWithKey:(NSString *)key {
    NSString *xmlstring = [self readXmlForKey:key];
    if ([_feed isEqualToString:@"json"])
        return [[TuiParametrizedXml alloc] initWithJsonString:xmlstring];
    return [[TuiParametrizedXml alloc] initWithXmlString:xmlstring];
}

#pragma mark - Private methods
-(void)readXmlListFromUrl:(NSString *)url {
    
    @try {
        _xmlList = [[TuiJsonReader sharedInstance] readJsonFromURL:url withMethod:@"GET"];
        [[TuiJsonStorer sharedInstance] storeObject:_xmlList
                                           withName:[@"xml_list" stringByAppendingString:_feed]];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not read URL file");
        NSDictionary *retrieved = (NSDictionary *)[[TuiJsonStorer sharedInstance] retrieveObjectOfType:[NSDictionary class] withName:[@"xml_list" stringByAppendingString:_feed]];
        if (retrieved != nil)
            _xmlList = retrieved;
    }
    @finally {
        [self stringifyXmlList];
    }
    
}

-(NSString *)readXmlForKey:(NSString *)key {
    //check if we have the list of xmls cached
    if ([[TuiContextCache sharedInstance] readValueForKey:[@"xml_list" stringByAppendingString:_feed]]) {
        return (NSString *)[_xmlList valueForKey:key];
    } 
    
    [self readXmlListFromUrl:[_baseURL stringByAppendingString:_feed]];
    
    if (![[TuiContextCache sharedInstance] readValueForKey:[@"xml_list" stringByAppendingString:_feed]])
        @throw [NSException exceptionWithName:@"TuiObjectNotFoundException" reason:[NSString stringWithFormat:@"Servers not available"] userInfo:nil];
     return (NSString *)[_xmlList valueForKey:key];   
}

-(void)stringifyXmlList {
    NSMutableDictionary *mutableXmlList = [_xmlList mutableCopy];
    for (NSString *key in _xmlList) {
        id value = _xmlList[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *stringValue = [(NSDictionary *)value toJsonString];
            if (stringValue == nil)
                @throw [NSException exceptionWithName:@"TuiJsonParsingException" reason:[NSString stringWithFormat:@"Error while parsing dictionary: %@",_xmlList] userInfo:nil];
            [mutableXmlList setValue:stringValue forKey:key];
        }
    }
    _xmlList = (NSDictionary *)mutableXmlList;
}

#pragma mark - NSObject methods
-(TuiXmlManager *)init {
    self = [super init];
    if (self) {
        _baseURL = @"http://54.246.80.107/api/list_xml_services.php?format=";
        _xmlList = [NSDictionary dictionary];
    }
    return self;
}

@end

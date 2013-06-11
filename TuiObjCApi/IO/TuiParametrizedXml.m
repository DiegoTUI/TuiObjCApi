//
//  TuiParametrizedXml.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedXml.h"
#import "NSString+Tui.h"
#import "NSDictionary+Tui.h"

#pragma mark - Private interface
@interface TuiParametrizedXml ()

//The JSON String with the $parameters$ to be replaced
@property (strong, nonatomic) NSString *baseJson;
//The XML String with the $parameters$ to be replaced
@property (strong, nonatomic) NSString *baseXml;
//The parameters that will replace the $xxxxx$ strings either in the baseJson or in the baseXml
@property (strong, nonatomic) NSMutableDictionary *parameters;
//aux private property for producing xml string
@property (strong, nonatomic) NSString *xmlString;

/**
 * Gets the baseString and replaces all the parameters
 * @return the base string with the parameters replaced.
 */
-(NSString *)replaceAll;

@end

#pragma mark - Implementation
@implementation TuiParametrizedXml

#pragma mark - Public methods
-(TuiParametrizedXml *)initWithJsonString:(NSString *)jsonString {
    self = [super init];
    
    if (self) {
        _baseJson = jsonString;
        _parameters = [NSMutableDictionary dictionary];
        _baseXml = nil;
    }
    
    return self;
}

-(TuiParametrizedXml *)initWithXmlString:(NSString *)xmlString {
    self = [super init];
    
    if (self) {
        _baseXml = xmlString;
        _parameters = [NSMutableDictionary dictionary];
        _baseJson = nil;
    }
    
    return self;
}

-(TuiParametrizedXml *)addValue:(NSString *)value
                         forKey:(NSString*)key {
    if (value != nil)
        [_parameters setValue:value forKey:key];
    
    return self;
}

-(TuiParametrizedXml *)addKeysAndValuesFromDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary) {
        //only add those keys whose value is a NSString
        if ([dictionary[key] isKindOfClass:[NSString class]])
            [self addValue:dictionary[key] forKey:key];
    }
    return self;
}

-(NSString *)getXmlString{
    //Replace all the parameters in the json string
    NSString *replacedString = [self replaceAll];
    //return the xml
    if (_baseJson) { //We are dealing with JSON
        NSError *jsonError = nil;
        NSDictionary *replacedJson = [NSJSONSerialization JSONObjectWithData:[replacedString dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
        if (jsonError)
            @throw [NSException exceptionWithName:@"TuiInvalidJsonException" reason:[NSString stringWithFormat:@"Exception parsing JSON from string %@",replacedString] userInfo:[jsonError userInfo]];
        
        //return [self produceXmlWithJson:replacedJson];
        return [replacedJson produceXml];
    }
    //We are dealing with XML
    return replacedString;
}

-(NSString *)getBaseString {
    if (_baseJson)
        return _baseJson;
    return _baseXml;
}

#pragma mark - Private methods

-(NSString *)replaceAll {
    NSString *result = _baseJson ? _baseJson : _baseXml;
    
    for (NSString *key in _parameters) {
        //look for the first occurrence of "$key$" in the remainder of result
        NSString *searchkey = [NSString stringWithFormat:@"$%@$", key];
        result = [result stringByReplacingFirstOccurrenceOfString:searchkey
                                                       withString:_parameters[key]];
    }
    
    return result;
}

@end

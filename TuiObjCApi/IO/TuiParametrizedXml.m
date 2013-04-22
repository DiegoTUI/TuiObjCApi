//
//  TuiParametrizedXml.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedXml.h"
#import "NSString+Tui.h"

#pragma mark - Private interface
@interface TuiParametrizedXml ()

@property (strong, nonatomic, readwrite) NSString *baseJson;
@property (strong, nonatomic, readwrite) NSMutableDictionary *parameters;
//aux private property for producing xml string
@property (strong, nonatomic) NSString *xmlString;

/**
 * Iterative method that fills the private property xmlString
 * @param name the name of the element to add to the XML string.
 * @param body the dictionary that defines the element to be parsed.
 */
-(void)xmlfyElementWithName:(NSString *)name
                    andBody:(NSDictionary *)body;

/**
 * Gets the baseJson and replaces all the parameters
 * @return the json string with the parameters replaced.
 */
-(NSString *)replaceAll;

/**
 * Produces an xml string from a properly formatted JSON Dictionary
 * The "@" prefix is used for attributes, the "#" field is used for value.
 * @return the json string with the parameters replaced.
 */
-(NSString *)produceXmlWithJson:(NSDictionary *)xmlJson;

@end

#pragma mark - Implementation
@implementation TuiParametrizedXml

#pragma mark - Public methods
-(TuiParametrizedXml *)initWithJsonString:(NSString *)jsonString {
    self = [super init];
    
    if (self) {
        _baseJson = jsonString;
        _parameters = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(TuiParametrizedXml *)addValue:(NSString *)value forKey:(NSString*)key {
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
    NSString *replacedJsonString = [self replaceAll];
    //return the xml
    NSError *jsonError = nil;
    NSDictionary *replacedJson = [NSJSONSerialization JSONObjectWithData:[replacedJsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
    if (jsonError)
        @throw [NSException exceptionWithName:@"TuiInvalidJsonException" reason:[NSString stringWithFormat:@"Exception parsing JSON from string %@",replacedJsonString] userInfo:[jsonError userInfo]];
    
    return [self produceXmlWithJson:replacedJson];
    
}

#pragma mark - Private methods
-(void)xmlfyElementWithName:(NSString *)name
                    andBody:(NSDictionary *)body {
    NSMutableArray *items = [[body allKeys] mutableCopy];
    if (name != nil) { //don't do this if there is a list
        //title
        _xmlString = [NSString stringWithFormat:@"%@<%@", _xmlString, name];
        //attributes
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", @"@"];
        NSArray *attributes = [items filteredArrayUsingPredicate:predicate];
        for (NSString *attribute in attributes) {
            _xmlString = [NSString stringWithFormat:@"%@ %@=\"%@\"", _xmlString, [attribute substringFromIndex:1], body[attribute]];
            [items removeObject:attribute];
        }
        _xmlString = [NSString stringWithFormat:@"%@>", _xmlString];
        //value
        if ([body objectForKey:@"#"] != nil) { //there is a value to add
            _xmlString = [NSString stringWithFormat:@"%@%@", _xmlString, body[@"#"]];
            [items removeObject:@"#"];
        }
    }
    //elements, that is, the rest of stuff in items
    for (NSString *element in items) {
        if ([body[element] isKindOfClass:[NSDictionary class]]) { //it's a dictionary
            [self xmlfyElementWithName:element andBody:body[element]];
        }
        else if ([body[element] isKindOfClass:[NSArray class]]) { //it's an array
            _xmlString = [NSString stringWithFormat:@"%@<%@>", _xmlString, element];
            for (NSDictionary *item in body[element]) {
                [self xmlfyElementWithName:nil andBody:item];
            }
            _xmlString = [NSString stringWithFormat:@"%@</%@>", _xmlString, element];
        }
        else  { //other
            [self xmlfyElementWithName:element andBody:[NSDictionary dictionary]];
        }
    }
    //close tag. Only when the name is not nil.
    if (name != nil)
        _xmlString = [NSString stringWithFormat:@"%@</%@>", _xmlString, name];
}

-(NSString *)replaceAll {
    NSString *result = _baseJson;
    
    for (NSString *key in _parameters) {
        //look for the first occurrence of "$key$" in the remainder of result
        NSString *searchkey = [NSString stringWithFormat:@"$%@$", key];
        result = [result stringByReplacingFirstOccurrenceOfString:searchkey
                                                       withString:_parameters[key]];
    }
    
    return result;
}

-(NSString *)produceXmlWithJson:(NSDictionary *)xmlJson
{
    _xmlString = @"";
    
    for (NSString *element in xmlJson) {
        if ([xmlJson[element] isKindOfClass:[NSDictionary class]]) { //It's a dictionary
            [self xmlfyElementWithName:element andBody:xmlJson[element]];
        }
        else if ([xmlJson[element] isKindOfClass:[NSArray class]]) { //It's an array
            _xmlString = [NSString stringWithFormat:@"%@<%@>", _xmlString, element];
            for (NSDictionary *item in xmlJson[element]) {
                [self xmlfyElementWithName:nil andBody:item];
            }
            _xmlString = [NSString stringWithFormat:@"%@</%@>", _xmlString, element];
        }
        else  { //other
            [self xmlfyElementWithName:element andBody:[NSDictionary dictionary]];
        }
    }
    
    return _xmlString;
}

@end

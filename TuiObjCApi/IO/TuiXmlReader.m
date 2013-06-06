//
//  TuiXmlReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlReader.h"
#import "RXMLElement.h"
#import "NSString+Tui.h"

#pragma mark - Private interface
@interface TuiXmlReader ()
/**
 * Reads a block of xml, and returns the value of the element coded in key
 * @param key the key coded as "value1.value2.value3"
 * @param xml the xml document to look into
 * @return value of key in the xml.
 */
-(NSString *)readValueForKey:(NSString *)key
                     fromXml:(RXMLElement *)xml;

/**
 * Returns the path for a given key
 * @param key the key coded as "value1.value2.@value3"
 * @return the path ommitting the attributes
 */
-(NSString *)getPathForKey:(NSString *)key;

/**
 * Returns the attribute for a given key
 * @param key the key coded as "value1.value2.@value3"
 * @return the attribute of the given key
 */
-(NSString *)getAttributeForKey:(NSString *)key;

/**
 * Parses an xml element with a description map and return the dictionary produced
 * @param element the xml to be parsed
 * @param descriptionMap the map describing wich fields should be read from the xml
 * @return the dictionary produced after parsing
 */
-(NSDictionary *)produceObjectForElement:(RXMLElement *)element
                      withDescriptionMap:(NSArray *)descriptionMap;
-(NSDictionary *)produceObjectForElement2:(RXMLElement *)element
                      withDescriptionMap:(NSArray *)descriptionMap;

@end

#pragma mark - Implementation
@implementation TuiXmlReader

#pragma mark - Public methods
+(TuiXmlReader *)sharedInstance {
    static TuiXmlReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiXmlReader alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSArray *)readObjectsFromXmlString:(NSString *)xmlString
                          lookingFor:(NSString *)key
                 usingDescriptionMap:(NSArray *)descriptionMap {
    __block NSMutableArray *result = [NSMutableArray array];
    //Read the xml
    RXMLElement *xml = [RXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
    if (key.length > 0) {
        [xml iterate:key usingBlock:^(RXMLElement *element) {
            NSDictionary *jsonobject = [self produceObjectForElement2:element withDescriptionMap:descriptionMap];
            [result addObject:jsonobject];
        }];
    } else {
        [result addObject:[self produceObjectForElement2:xml
                                     withDescriptionMap:descriptionMap]];
    }
    
    return (NSArray *)result;
}

#pragma mark - Private methods
-(NSString *)readValueForKey:(NSString *)key
                     fromXml:(RXMLElement *)xml {
    NSString *path = [self getPathForKey:key];
    __block NSString *attribute = [self getAttributeForKey:key];
    __block NSString *result = nil;
    if (path.length > 0) { //there is a path to go to
        [xml iterate:path usingBlock:^(RXMLElement *element) {
            if (attribute.length > 0) {  //There is path and attribute
                result = [element attribute:attribute];
            } else {    //there is a path, but no attribute
                result = element.text;
            }
        }];
    } else {    //There is no path
        if (attribute.length > 0) { //No path, but attribute
            result = [xml attribute:attribute];
        } else {    //No path, no attribute
            result = xml.text;
        }
    }
    return result;
}

-(NSString *)getPathForKey:(NSString *)key {
    if ([key hasPrefix:@"@"])
        return @"";
    NSRange rng = [key rangeOfString:@".@"];
    if (rng.location != NSNotFound) {
        return [key substringToIndex:rng.location];
    }
    return key;
}

-(NSString *)getAttributeForKey:(NSString *)key {
    NSRange rng = [key rangeOfString:@"@"];
    if (rng.location != NSNotFound) {
        return [key substringFromIndex:rng.location+1];
    }
    return @"";
}

-(NSDictionary *)produceObjectForElement2:(RXMLElement *)element
                      withDescriptionMap:(NSArray *)descriptionMap {
    //create the object to return
    NSMutableDictionary *jsonobject = [NSMutableDictionary dictionary];
    //Go through the elements in the description map
    for (id item in descriptionMap) {
        if ([item isKindOfClass:[NSString class]]) {    //If it's a string, look for the value in the xml and add it to the result
            NSString *content = [element child:item].text;
            id value = content==nil ? [NSNull null] : content;
            [jsonobject setValue:value forKey:item];
        }
        else if ([item isKindOfClass:[NSDictionary class]]) {   //If it's a dictionary, explore it
            //make sure that the dictionary has exactly 1 key
            if ([[item allKeys] count] != 1)
                @throw [NSException exceptionWithName:@"TuiInvalidDescriptionMapException" reason:[NSString stringWithFormat:@"Invalid description map. Too many keys in dictionary: %@", [item allKeys]] userInfo:item];
            //there is only one key. Iterate it
            for (NSString *fieldname in item) {
                __block id dictvalue = item[fieldname];
                if ([dictvalue isKindOfClass:[NSArray class]]) { //The dictionary encloses an array. It's a list
                    __block NSMutableArray *sublist = [NSMutableArray array];
                    //We have to iterate the field name
                    [element iterate:fieldname usingBlock:^(RXMLElement *arrayelement) {
                        [sublist addObject:[self produceObjectForElement2:arrayelement withDescriptionMap:dictvalue]];
                    }];
                    //array completed, let's add it to the dictionary
                    [jsonobject setValue:sublist forKey:[fieldname listify]];
                }
                //The dictionary encloses a string
                else if ([dictvalue isKindOfClass:[NSString class]]) {
                    NSString *content = [self readValueForKey:dictvalue fromXml:element];
                    id value = content==nil ? [NSNull null] : content;
                    [jsonobject setValue:value forKey:fieldname];
                }
            }
        }
    }
    
    return jsonobject;
}

-(NSDictionary *)produceObjectForElement:(RXMLElement *)element
                      withDescriptionMap:(NSArray *)descriptionMap {
    //create the object to return
    NSMutableDictionary *jsonobject = [NSMutableDictionary dictionary];
    //Go through the elements in the description map
    for (id item in descriptionMap) {
        if ([item isKindOfClass:[NSString class]]) {    //If it's a string, look for the value in the xml and add it to the result
            NSString *content = [element child:item].text;
            id value = content==nil ? [NSNull null] : content;
            [jsonobject setValue:value forKey:item];
        }
        else if ([item isKindOfClass:[NSDictionary class]]) {   //If it's a dictionary, explore it
            //make sure that the dictionary has exactly 1 key
            if ([[item allKeys] count] != 1)
                @throw [NSException exceptionWithName:@"TuiInvalidDescriptionMapException" reason:[NSString stringWithFormat:@"Invalid description map. Too many keys in dictionary: %@", [item allKeys]] userInfo:item];
            //there is only one key. Iterate it
            for (NSString *fieldname in item) {
                __block id dictvalue = item[fieldname];
                if ([dictvalue isKindOfClass:[NSArray class]]) { //The dictionary encloses an array. It's a list
                    //only one dictionary in the array
                    if (([dictvalue count] != 1) || !([[dictvalue objectAtIndex:0] isKindOfClass:[NSDictionary class]]))
                        @throw [NSException exceptionWithName:@"TuiInvalidDescriptionMapException" reason:[NSString stringWithFormat:@"Invalid description map. Too many dictionaries in array: %@", dictvalue] userInfo:nil];
                    __block NSMutableArray *sublist = [NSMutableArray array];
                    __block NSDictionary *listdict = [dictvalue objectAtIndex:0];
                    //We have to iterate the field name
                    [element iterate:fieldname usingBlock:^(RXMLElement *arrayelement) {
                        NSMutableDictionary *innerobject = [NSMutableDictionary dictionary];
                        for (NSString *innerkey in listdict) {
                            NSString *content = [self readValueForKey:listdict[innerkey] fromXml:arrayelement];
                            //NSString *content = [arrayelement child:listdict[innerkey]].text;
                            id value = content==nil ? [NSNull null] : content;
                            [innerobject setValue:value forKey:innerkey];
                        }
                        [sublist addObject:innerobject];
                    }];
                    //array completed, let's add it to the dictionary
                    [jsonobject setValue:sublist forKey:[fieldname listify]];
                }
                //The dictionary encloses a string
                else if ([dictvalue isKindOfClass:[NSString class]]) {
                    NSString *content = [self readValueForKey:dictvalue fromXml:element];
                    id value = content==nil ? [NSNull null] : content;
                    [jsonobject setValue:value forKey:fieldname];
                }
            }
        }
    }
    
    return jsonobject;
}

@end

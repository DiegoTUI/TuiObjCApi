//
//  NSDictionary+Tui.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "NSDictionary+Tui.h"
#import "NSString+Tui.h"

#pragma mark - Private interface


#pragma mark - Implementation
@implementation NSDictionary (Tui)
#pragma mark - Public methods

-(NSDictionary *)dictionaryByMappingValuesWithBlock:(id (^)(id obj))block {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (NSString *key in self) {
        [newDictionary setValue:block([self valueForKey:key]) forKey:key];
    }
    return (NSDictionary *)newDictionary;
}

-(NSDictionary *)dictionaryByUnescapingStringsInValues
{
    return [self dictionaryByMappingValuesWithBlock:^id(id value) {
        if ([value isKindOfClass:[NSString class]]) {
            value = [value stringByUnescapingISO8859];
        }
        
        return value;
    }];
}

-(NSString *)toJsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = nil;
    
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(NSString *)produceXml {
    NSString *xmlString = @"";
    for (NSString *key in self) {
        xmlString = [xmlString stringByAppendingString:[self processNodeWithKey:key
                                                                         andValue:self[key]]];
    }
    return xmlString;
}

#pragma mark - Private methods
-(NSString *)processNodeWithKey:(NSString *)key
                       andValue:(id)value {
    NSString *result = @"";
    if ([key isEqualToString:@"#list"]) { //It's a "no-key" list
        if (![value isKindOfClass:[NSArray class]])
            @throw [NSException exceptionWithName:@"TuiInvalidNodeException" reason:@"Invalid node. #list key not followed by a NSArray kind of value" userInfo:nil];
        for (NSDictionary *item in value) {
            for (NSString *innerKey in item) {
                if (![item[innerKey] isKindOfClass:[NSArray class]])
                    @throw [NSException exceptionWithName:@"TuiInvalidNodeException" reason:@"Invalid node. Item in #list key not followed by a NSArray kind of value" userInfo:nil];
                for (NSDictionary *innerItem in (NSArray *)item[innerKey]) {
                    result = [result stringByAppendingString:[self processNodeWithKey:innerKey andValue:innerItem]];
                }
            }
        }
    }
    else {  //It's a "regular" node
        result = [result stringByAppendingString:[NSString stringWithFormat:@"<%@",key]];
        if ([value isKindOfClass:[NSString class]]) {   //"regular" value
            result = [result stringByAppendingString:[NSString stringWithFormat:@">%@",value]];
        } else if ([value isKindOfClass:[NSArray class]]) { //it's a "keyed" list
            result = [result stringByAppendingString:@">\n"];
            for (NSDictionary *item in value) {
                for (NSString *innerKey in item) {
                    if (![item[innerKey] isKindOfClass:[NSArray class]])
                        @throw [NSException exceptionWithName:@"TuiInvalidNodeException" reason:@"Invalid node. Item in #list key not followed by a NSArray kind of value" userInfo:nil];
                    for (NSDictionary *innerItem in (NSArray *)item[innerKey]) {
                        result = [result stringByAppendingString:[self processNodeWithKey:innerKey andValue:innerItem]];
                    }
                }
            }
        } else if ([value isKindOfClass:[NSDictionary class]]) { //it's a dictionary
            NSArray *innerKeys = [value allKeys];
            NSMutableArray *attributes = [NSMutableArray array];
            NSString *textValue = nil;
            NSMutableArray *other = [NSMutableArray array];
            for (NSString *innerKey in innerKeys) {
                if ([innerKey hasPrefix:@"@"])
                    [attributes addObject:[innerKey substringFromIndex:1]];
                else if ([innerKey isEqualToString:@"#value"])
                    textValue = value[innerKey];
                else
                    [other addObject:innerKey];
            }
            //check the attributes first
            for (NSString *attribute in attributes) {
                NSString *attributeName = [NSString stringWithFormat:@"@%@", attribute];
                result = [result stringByAppendingString:[NSString stringWithFormat:@" %@=\"%@\"", attribute, value[attributeName]]];
            }
            //close tag
            result = [result stringByAppendingString:@">\n"];
            //check the text value
            if (textValue != nil)
                result = [result stringByAppendingString:textValue];
            //process the other nodes
            for (NSString *innerKey in other) {
                result = [result stringByAppendingString:[self processNodeWithKey:innerKey andValue:value[innerKey]]];
            }
        }
        //close tag
        result = [result stringByAppendingString:[NSString stringWithFormat:@"</%@>\n", key]];
    }
    return result;
}

@end

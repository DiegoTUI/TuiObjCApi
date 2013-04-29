//
//  TuiXmlReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlReader.h"
#import "RXMLElement.h"

#pragma mark - Private interface

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
    //Go through the "key" objects in the xml string
    [xml iterate:key usingBlock:^(RXMLElement *element) {
        //create the object to add to the result
        NSMutableDictionary *jsonobject = [NSMutableDictionary dictionary];
        //Go through the elements in the description map
        for (id item in descriptionMap) {
            //If it's a string, look for the value in the xml and add it to the result
            if ([item isKindOfClass:[NSString class]]) {
                NSString *content = [element child:item].text;
                id value = content==nil ? [NSNull null] : content;
                [jsonobject setValue:value forKey:item];
            } //If it's a dictionary, explore it
            else if ([item isKindOfClass:[NSDictionary class]]) {
                //make sure that the dictionary has exactly 1 key
                if ([[item allKeys] count] != 1)
                    @throw [NSException exceptionWithName:@"TuiInvalidDescriptionMapException" reason:[NSString stringWithFormat:@"Invalid description map. Too many keys in dictionary: %@", [item allKeys]] userInfo:item];
                //there is only one key. Iterate it
                for (NSString *fieldname in item) {
                    __block id dictvalue = item[fieldname];
                    //The dictionary encloses an array
                    if ([dictvalue isKindOfClass:[NSArray class]]) {
                        //only one dictionary in the array
                        if (([dictvalue count] != 1) || !([[dictvalue objectAtIndex:0] isKindOfClass:[NSDictionary class]]))
                            @throw [NSException exceptionWithName:@"TuiInvalidDescriptionMapException" reason:[NSString stringWithFormat:@"Invalid description map. Too many dictionaries in array: %@", dictvalue] userInfo:nil];
                        __block NSMutableArray *sublist = [NSMutableArray array];
                        __block NSDictionary *listdict = [dictvalue objectAtIndex:0];
                        //We have to iterate the field name
                        [element iterate:fieldname usingBlock:^(RXMLElement *arrayelement) {
                            NSMutableDictionary *innerobject = [NSMutableDictionary dictionary];
                            for (NSString *innerkey in listdict) {
                                NSString *content = [arrayelement child:listdict[innerkey]].text;
                                id value = content==nil ? [NSNull null] : content;
                                [innerobject setValue:value forKey:innerkey];
                            }
                            [sublist addObject:innerobject];
                        }];
                        //array completed, let's add it to the dictionary
                        [jsonobject setValue:sublist forKey:fieldname];
                    }
                    //The dictionary encloses a string
                    else if ([dictvalue isKindOfClass:[NSString class]]) {
                        //we have to see if there is an attribute at the end of the dictvalue string
                        NSRange rng = [dictvalue rangeOfString:@".@"];
                        //there is an attribute at the end of the string
                        if (rng.location != NSNotFound) {
                            NSString *path = [dictvalue substringToIndex:rng.location];
                            NSString *attribute = [dictvalue substringFromIndex:(rng.location+2)];
                            NSString *content = [[element child:path] attribute:attribute];
                            id value = content==nil ? [NSNull null] : content;
                            [jsonobject setValue:value forKey:fieldname];
                            
                        } //there is no attribute at the end of the string
                        else {
                            NSString *content = [element child:dictvalue].text;
                            id value = content==nil ? [NSNull null] : content;
                            [jsonobject setValue:value forKey:fieldname];
                        }
                    }
                }
            }
        }
        //Add the object to the array of results
        [result addObject:jsonobject];
    }];
    
    return (NSArray *)result;
}

#pragma mark - Private methods

@end

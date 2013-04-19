//
//  TuiParametrizedXml.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedXml.h"

#pragma mark - Private interface
@interface TuiParametrizedXml ()

@property (strong, nonatomic, readwrite) NSMutableDictionary *parameters;
@property (strong, nonatomic) NSString *xmlString;

/**
 * Iterative method that fills the private property xmlString
 * @param name the name of the element to add to the XML string.
 * @param body the dictionary that defines the element to be parsed.
 */
-(void)xmlfyElementWithName:(NSString *)name
                    andBody:(NSDictionary *)body;

@end

#pragma mark - Implementation
@implementation TuiParametrizedXml

#pragma mark - Synthesized properties

#pragma mark - Public methods
-(TuiParametrizedXml *) initWithDictionary:(NSDictionary *)parameters{
    self = [super init];
    
    if (self){
        _parameters = [parameters mutableCopy];
        _xmlString = @"";
    }
    
    return self;
}

-(NSString *)getXmlString{
    _xmlString = @"";
    
    for (NSString *element in _parameters) {
        if ([_parameters[element] isKindOfClass:[NSDictionary class]]) { //It's a dictionary
            [self xmlfyElementWithName:element andBody:_parameters[element]];
        }
        else if ([_parameters[element] isKindOfClass:[NSArray class]]) { //It's an array
            _xmlString = [NSString stringWithFormat:@"%@<%@>", _xmlString, element];
            for (NSDictionary *item in _parameters[element]) {
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
    //close tag. TODO: check this!!! Name might as well be nil!!!rr
    _xmlString = [NSString stringWithFormat:@"%@</%@>", _xmlString, name];
}

@end

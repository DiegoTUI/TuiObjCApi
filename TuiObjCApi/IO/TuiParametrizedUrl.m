//
//  TuiParametrizedUrl.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/26/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedUrl.h"
#import "NSString+Tui.h"

#pragma mark - Private interface
@interface TuiParametrizedUrl ()

//The string with the full URL and the $parameters$ to be replaced
@property (strong, nonatomic) NSString *baseUrl;
//The parameters that will replace the $xxxxx$ strings either in the baseJson or in the baseXml
@property (strong, nonatomic) NSMutableDictionary *parameters;
//is it a POST call or a GET call?
@property (nonatomic) BOOL post;

/**
 * Gets the baseUrl and replaces all the parameters
 * @return the base url with the parameters replaced.
 */
-(NSString *)replaceAll;

@end

#pragma mark - Implementation
@implementation TuiParametrizedUrl

#pragma mark - Public methods
-(TuiParametrizedUrl *)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _baseUrl = url;
        _parameters = [NSMutableDictionary dictionary];
        _post = NO;
    }
    return self;
}

-(TuiParametrizedUrl *)addValue:(NSString *)value
                         forKey:(NSString*)key {
    if (value != nil)
        [_parameters setValue:value forKey:key];
    
    return self;
}

-(TuiParametrizedUrl *)addKeysAndValuesFromDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary) {
        //only add those keys whose value is a NSString
        if ([dictionary[key] isKindOfClass:[NSString class]])
            [self addValue:dictionary[key] forKey:key];
    }
    return self;
}

-(void)setPost:(BOOL)post {
    _post = post;
}

-(BOOL)isPost {
    return _post;
}

-(NSString *)getRawURL {
    return [self replaceAll];
}

-(NSString *)getBaseString {
    return _baseUrl;
}

#pragma mark - Private methods
-(NSString *)replaceAll {
    NSString *result = _baseUrl;
    
    for (NSString *key in _parameters) {
        //look for the first occurrence of "$key$" in the remainder of result
        NSString *searchkey = [NSString stringWithFormat:@"$%@$", key];
        result = [result stringByReplacingFirstOccurrenceOfString:searchkey
                                                       withString:_parameters[key]];
    }
    
    return result;
}

@end

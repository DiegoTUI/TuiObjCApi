//
//  NSDictionary+Tui.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "NSDictionary+Tui.h"
#import "NSString+Tui.h"

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
        if ([value isKindOfClass:[NSString class]])
        {
            value = [value stringByUnescapingISO8859];
        }
        
        return value;
    }];
}

@end

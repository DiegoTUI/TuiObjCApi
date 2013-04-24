//
//  NSObject+Tui.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "NSObject+Tui.h"
#import "TuiClassManager.h"

@implementation NSObject (Tui)

-(NSDictionary *)convertObjectToJson {
    NSMutableDictionary *jsonobject = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *properties = [TuiClassManager getPropertiesForObject:self];
    
    for (NSString *property in properties)
    {
        id value = [self valueForKey:property];
        
        if (value != nil)
        {
            [jsonobject setValue:value forKey:property];
        }
    }
    
    return (NSDictionary *)jsonobject;
}

@end

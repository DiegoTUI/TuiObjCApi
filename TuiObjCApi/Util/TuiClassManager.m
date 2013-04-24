//
//  TuiClassManager.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiClassManager.h"
#import <objc/runtime.h>

#pragma mark - Implementation
@implementation TuiClassManager

+(NSArray*)getPropertiesForObject:(NSObject *)object {
    Class objectclass = [object class];
    NSUInteger numberofproperties;
    
    objc_property_t *properties = class_copyPropertyList(objectclass, &numberofproperties);
    
    NSMutableArray *classproperties  = [NSMutableArray arrayWithCapacity:numberofproperties];
    
    for (int i = 0; i < numberofproperties ; i++)
    {
        const char* propertyname = property_getName(properties[i]);
        [classproperties addObject:[NSString  stringWithCString:propertyname encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return classproperties;
}

+(NSArray*)getPropertiesForClass:(Class)objectClass {
    NSUInteger numberofproperties;
    
    objc_property_t *properties = class_copyPropertyList(objectClass, &numberofproperties);
    
    NSMutableArray *classproperties  = [NSMutableArray arrayWithCapacity:numberofproperties];
    
    for (int i = 0; i < numberofproperties ; i++)
    {
        const char* propertyname = property_getName(properties[i]);
        [classproperties addObject:[NSString  stringWithCString:propertyname encoding:NSUTF8StringEncoding]];
    }
    
    free(properties);
    
    return classproperties;
}

+(NSString *)getTypeOfProperty:(NSString *)propertyName
                     forObject:(NSObject *)object {
    if (![object respondsToSelector:NSSelectorFromString(propertyName)])
        return @"MIBObjectDoesNotRespondToProperty";
    
    const char * type = property_getAttributes(class_getProperty([object class], [propertyName UTF8String]));
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    
    return propertyType;
}

+(BOOL)invokeSelector:(NSString *)selectorName
             inObject:(NSObject *)object
        withArguments:(NSArray *)arguments {
    SEL selector = NSSelectorFromString(selectorName);
    Method method = class_getInstanceMethod([object class], selector);
    int argumentCount = method_getNumberOfArguments(method);
    
    if(argumentCount != [arguments count])
        return NO; // Not enough arguments in the array
    
    NSMethodSignature *signature = [object methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:object];
    [invocation setSelector:selector];
    
    for(int i=0; i<[arguments count]; i++)
    {
        id arg = [arguments objectAtIndex:i];
        [invocation setArgument:&arg atIndex:i+2]; // The first two arguments are the hidden arguments self and _cmd
    }
    
    [invocation invoke]; // Invoke the selector
    
    return YES;
}

+(BOOL)object:(id)object respondsToSetter:(NSString *)settername {
    SEL selector = NSSelectorFromString(settername);
    
    if ([object respondsToSelector:selector])
    {
        Method method = class_getInstanceMethod([object class], selector);
        NSInteger argumentCount = method_getNumberOfArguments(method);
        
        if (argumentCount !=1)
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

@end

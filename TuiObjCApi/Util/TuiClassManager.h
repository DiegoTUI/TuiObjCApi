//
//  TuiClassManager.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A set of toold to manage class introspection
 * @author diego
 */
@interface TuiClassManager : NSObject

/**
 * Gets the properties of a class in a NSArray
 * @param the object to be analyzed
 * @return an array of NSStrings containing the properties of the object
 * @author diego
 */
+(NSArray*)getPropertiesForObject:(NSObject *)object;

/**
 * Gets the properties of a class in a NSArray forcing a type
 * @param the object to be analyzed
 * @param the class of the object
 * @return an array of NSStrings containing the properties of the object
 * @author diego
 */
+(NSArray*)getPropertiesForClass:(Class)objectClass;

/**
 * Checks if the object responds to a certain property,
 * and it it does, returns the type of that property
 * @param the name of the property
 * @param the object you want to check.
 * @return the type of the property - @"MIBObjectDoesNotRespondToProperty" is the object does not respond to the property
 */
+(NSString *)getTypeOfProperty:(NSString *)propertyName
                     forObject:(NSObject *)object;

/**
 * Invokes a certain selector in a class
 * @return YES is the selector was invoked, NO if it wasn't
 * @author diego
 */
+(BOOL)invokeSelector:(NSString *)selectorName
             inObject:(NSObject *)object
        withArguments:(NSArray *)arguments;

/**
 * Checks if a certain setter exists for an object.
 * @param the name of the setter
 * @param the object you want to check.
 * @return YES if if found the setter, NO if it didn't
 */
+(BOOL)object:(id)object respondsToSetter:(NSString *)settername;

@end

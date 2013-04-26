//
//  TuiJsonReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiJsonReader.h"
#import "TuiUrlReader.h"
#import "NSDictionary+Tui.h"
#import "NSString+Tui.h"
#import "TuiClassManager.h"
#import "TuiDateFormatter.h"

#pragma mark - Private interface
@interface TuiJsonReader()

/**
 * Set all attributes in a target object. For each JSON key-value, search
 * for an attribute on the target object with the name of the key and set
 * its value.
 *
 * @param object the JSON object that contains the values.
 * @param target where to set the attributes.
 * @return a dictionary with the fields of the object and YES/NO to indicate if the field was properly set
 */
-(NSDictionary *)setAllValuesInObject:(NSObject *)target
                      usingDictionary:(NSDictionary *)JSONObject;

/**
 * Set a single value on an object.
 * @param object the JSON object with the value for the field.
 * @param key the key for the field.
 * @param target the object to set.
 * @return YES if it succeeded, NO otherwise
 */
-(BOOL)setValueInObject:(NSObject *)target
               usingKey:(NSString *)key
           inDictionary:(NSDictionary *)JSONObject;

/**
 * Set a field on an object.
 * @param object the JSON object with the value for the field.
 * @param key the key for the field.
 * @param target the object to set.
 * @return YES if it succeeded, NO otherwise
 */
-(BOOL)setFieldInObject:(NSObject *)target
               usingKey:(NSString *)key
           inDictionary:(NSDictionary *)JSONObject;

/**
 * Gets the setter for a variable.
 * @param type class name.
 * @param key variable name.
 * @return a setter method.
 */
-(NSString *)getSetterForClass:(Class)type
                       withKey:(NSString *)key;

/**
 * Set a value using a setter on an object.
 * @param object the JSON object with the value for the field.
 * @param key the key for the field.
 * @param target the object to set.
 * @return an array of NSObjects created from the JSON.
 */
-(BOOL)setWithSetterInObject:(NSObject *)target
                    usingKey:(NSString *)key
                inDictionary:(NSDictionary *)JSONObject;
/**
 * Receives an object and adapts the type of the output
 * @param object the object to adapt the type
 * @param type the type to adapt the object to
 * @return an object of any type.
 */
-(NSObject *)adaptObject:(NSObject *)object
                  toType:(NSString *)type;

/**
 * Gets the type of object in a JSONObject
 * @param the JSON object
 * @return an the type of the object
 */
-(Class)getTypeOfObjectinDictionary:(NSDictionary *)JSONObject;

/**
 * Read an array of objects.
 * @param type the type of the array.
 * @param JSONArray array of NSDictionaries containing key=>values of objects.
 * @return an array of NSObjects created from the JSON.
 */
-(NSArray *)readObjectsOfClass:(Class)type
                     fromArray:(NSArray *)JSONArray;

@end

#pragma mark - Implementation
@implementation TuiJsonReader

#pragma mark - Public methods
+(TuiJsonReader *)sharedInstance {
    static TuiJsonReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiJsonReader alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSDictionary *)readJsonFromUrl:(TuiParametrizedUrl *)url {
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url];
    
    NSError *JSONError = nil;
    id JSONDictionary = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0
                                                          error:&JSONError];
    if (JSONError)
        @throw [NSException exceptionWithName:@"TuiInvalidUrlException" reason:[NSString stringWithFormat:@"Exception reading JSON from %@",url] userInfo:[JSONError userInfo]];
    
    return [(NSDictionary *)JSONDictionary dictionaryByUnescapingStringsInValues];
}

-(NSDictionary *)readJsonFromString:(NSString *)string {
    NSData *response = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *JSONError = nil;
    id JSONDictionary = [NSJSONSerialization JSONObjectWithData:response
                                                        options:0
                                                          error:&JSONError];
    if (JSONError)
        @throw [NSException exceptionWithName:@"TuiInvalidJsonStringException" reason:[NSString stringWithFormat:@"Exception reading JSON from %@",string] userInfo:[JSONError userInfo]];
    
    return [(NSDictionary *)JSONDictionary dictionaryByUnescapingStringsInValues];
}

-(NSObject *)readObjectOfClass:(Class)type
               usingDictionary:(NSDictionary *)JSONObject {
    NSObject *target = [[type alloc] init];
    //if the object is an NSDictionary, return JSONObject
    if ([target isKindOfClass:[NSDictionary class]]) 
        return JSONObject;
    //if the object is an NSMutableDictionary, return mutable version of JSONObject
    if ([target isKindOfClass:[NSMutableDictionary class]])
        return [JSONObject mutableCopy];
    
    //Browse the dictionary and biuld the object
    [self setAllValuesInObject:target usingDictionary:JSONObject];
    
    return target;
}

#pragma mark - Private methods
-(NSDictionary *)setAllValuesInObject:(NSObject *)target
                      usingDictionary:(NSDictionary *)JSONObject {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[JSONObject count]];
    
    for (NSString *key in JSONObject)
    {
        BOOL succeed = [self setValueInObject:target usingKey:key inDictionary:JSONObject];
        [result setValue:[NSNumber numberWithBool:succeed] forKey:key];
    }
    
    return (NSDictionary *)result;
}

-(BOOL)setValueInObject:(NSObject *)target
               usingKey:(NSString *)key
           inDictionary:(NSDictionary *)JSONObject {
    //try field
    BOOL setfield = [self setFieldInObject:target usingKey:key inDictionary:JSONObject];
    if (setfield)
        return YES;
    
    //try setter if field didn't work
    BOOL setsetter = [self setWithSetterInObject:target usingKey:key inDictionary:JSONObject];
    if (setsetter)
        return YES;
    
    //return NO if everything failed
    return NO;
}

-(BOOL)setFieldInObject:(NSObject *)target
               usingKey:(NSString *)key
           inDictionary:(NSDictionary *)JSONObject {
    NSString *fieldtoset = [key toCamelCase];
    
    NSObject *value = [JSONObject valueForKey:key];
    
    if (value != nil)
    {
        NSString *typeoffield = [TuiClassManager getTypeOfProperty:fieldtoset forObject:target];
        NSObject *adaptedvalue = [self adaptObject:value toType:typeoffield];
        
        @try {
            [target setValue:adaptedvalue forKey:fieldtoset];
            return YES;
            //NSLog(@"values -- %@ : %@", value, [target valueForKey:fieldtoset]);
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
}

-(NSString *)getSetterForClass:(Class)type
                       withKey:(NSString *)key {
    NSString *settername = [NSString stringWithFormat:@"set%@%@",
                            [[key substringToIndex:1] uppercaseString],
                            [key substringFromIndex:1]];
    //DANGER - id object = [[type alloc] init];
    id object = [type alloc];
    
    if ([TuiClassManager object:object respondsToSetter:settername])
        return settername;
    else
        return @"TuiNoSuchMethodException";
}

-(BOOL)setWithSetterInObject:(NSObject *)target
                    usingKey:(NSString *)key
                inDictionary:(NSDictionary *)JSONObject {
    NSString *setter = [self getSetterForClass:[target class] withKey:[key toCamelCase]];
    
    if ([setter isEqualToString:@"TuiNoSuchMethodException"])
        return NO;
    
    id value = [JSONObject valueForKey:key];
    
    if (value)
    {
        NSArray *arguments = [NSArray arrayWithObject:value];
        [TuiClassManager invokeSelector:setter inObject:target withArguments:arguments];
    }
    
    return YES;
}

-(NSObject *)adaptObject:(NSObject *)object
                  toType:(NSString *)type {
    if ([type isEqualToString:@"@\"NSDate\""])
        return (NSDate *)[[TuiDateFormatter sharedInstance] parseDateFromISO8601String:(NSString *)object];
    else if ([type isEqualToString:@"@\"NSArray\""] ||
             [type isEqualToString:@"@\"NSMutableArray\""])
    {
        id firstelement = nil;
        
        if ([(NSArray *)object count] > 0)
            firstelement = [(NSArray *)object objectAtIndex:0];
        
        if ([firstelement isKindOfClass:[NSDictionary class]])
        {
            return (NSArray *)[self readObjectsOfClass:[self getTypeOfObjectinDictionary:(NSDictionary *)firstelement] fromArray:(NSArray *)object];
        }
        return (NSArray *)object;
    }
    else if ([type isEqualToString:@"@\"NSDictionary\""] ||
             [type isEqualToString:@"@\"NSMutableDictionary\""])
    {
        NSMutableDictionary *adapteddictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString *key in (NSDictionary *)object) {
            id value = [(NSDictionary *)object valueForKey:key];
            if (value != nil && [value isKindOfClass:[NSDictionary class]])
                [adapteddictionary setValue:[self readObjectOfClass:[self getTypeOfObjectinDictionary:(NSDictionary *)value] usingDictionary:(NSDictionary *)value] forKey:key];
            
        }
        return adapteddictionary;
    }
    
    return (NSString *)object;
}

-(Class)getTypeOfObjectinDictionary:(NSDictionary *)JSONObject {
    //TODO: use this class when needed
    /*if ([JSONObject valueForKey:@"destination_id"])
        return [MIBDestination class];
    else if ([JSONObject valueForKey:@"date"])
        return [MIBDay class];
    else if ([JSONObject valueForKey:@"time"])
        return [MIBScheduledThingToDo class];
    else if ([JSONObject valueForKey:@"activity_id"])
        return [MIBScheduledThingToDo class];
    else if ([JSONObject valueForKey:@"comment_id"])
        return [MIBComment class];*/
    
    return [NSObject class];
}

-(NSArray *)readObjectsOfClass:(Class)type
                     fromArray:(NSArray *)JSONArray {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *jsondictionary in JSONArray) {
        [objects addObject:[self readObjectOfClass:type usingDictionary:[jsondictionary dictionaryByUnescapingStringsInValues]]];
    }
    
    return (NSArray *)objects;
}


@end

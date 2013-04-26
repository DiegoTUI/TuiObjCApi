//
//  TuiJsonReader.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuiParametrizedUrl.h"

/**
 * A class to read and parse JSONs.
 * @author diego
 */
@interface TuiJsonReader : NSObject

/**
 * Returns a unique instance of the JSON reader.
 * @return a singleton.
 */
+(TuiJsonReader *)sharedInstance;

/**
 * Connect to the given URL, return a JSON object.
 * @param url the URL to read.
 * @return the JSON.
 */
-(NSDictionary *)readJsonFromUrl:(TuiParametrizedUrl *)url;

/**
 * Reads a string, generates a JSON object.
 * @param string the string to read.
 * @return the JSON.
 * @throws TuiInvalidJsonStringException
 */
-(NSDictionary *)readJsonFromString:(NSString *)string;

/**
 * Return an object of any type read from a JSON object.
 * @param object the JSON object.
 * @param type the class of the object to create.
 * @return the newly created object.
 */
-(NSObject *)readObjectOfClass:(Class)type
               usingDictionary:(NSDictionary *)JSONObject;

@end

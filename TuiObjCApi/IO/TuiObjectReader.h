//
//  TuiObjectReader.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to read Objects.
 * Uses NSDictionaries and produces native objects
 * @author diego
 */
@interface TuiObjectReader : NSObject

/**
 * Returns a unique instance of the JSON reader.
 * @return a singleton.
 */
+(TuiObjectReader *)sharedInstance;

/**
 * Return an object of any type read from a JSON object.
 * @param object the JSON object.
 * @param type the class of the object to create.
 * @return the newly created object.
 */
-(NSObject *)readObjectOfClass:(Class)type
               usingDictionary:(NSDictionary *)JSONObject;

@end

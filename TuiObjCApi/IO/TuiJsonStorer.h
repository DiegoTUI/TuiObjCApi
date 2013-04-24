//
//  TuiJsonStorer.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to store objects using TuiContextCache
 * @author diego
 */
@interface TuiJsonStorer : NSObject

/**
 * Returns a unique instance of the JSON Storer. 
 * @return a singleton.
 */
+(TuiJsonStorer *)sharedInstance;

/**
 * Store an object in local storage.
 * @param name of the object.
 * @param object the object to store.
 * @throws TuiJsonParsingException
 */
-(void)storeObject:(NSObject *)object
          withName:(NSString *)name;

/**
 * Delete an object from storage.
 * @param name of the object.
 */
-(void)deleteObjectWithName:(NSString *)name;

/**
 * Retrieve an object from local storage.
 * @param name of the object.
 * @return a model object (which may have expired), or null if the object is not found.
 */
-(NSObject *)retrieveObjectOfType:(Class)type
                         withName:(NSString *)name;

@end

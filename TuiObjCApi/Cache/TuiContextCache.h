//
//  TuiContextCache.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * A class to store preferences and cache objects.
 * It uses NSUserDefaults by now, but could switch to SQLite when needed
 * @author diego
 */
@interface TuiContextCache : NSObject

/**
 * Returns a unique instance of the Context Cache.
 * @return a singleton.
 */
+(TuiContextCache *)sharedInstance;

/**
 * Set the preferences object directly. Should only be called in tests.
 * @param preferences an iPhone shared preferences object.
 */
-(void)setTestUserDefaults:(NSUserDefaults *)userDefaults;

/**
 * Read a stored value from the preferences.
 * @param key the key for the value.
 * @return the stored value, or null if there is no value.
 */
-(id)readValueForKey:(NSString *)key;

/**
 * Delete a value from the preferences.
 * @param key the key that identifies the value.
 */
-(void)removeObjectWithKey:(NSString *)key;

/**
 * Store a value into the preferences.
 * @param key the key for the value.
 * @param value the new value to store.
 */
-(void)storeValue:(id)value forKey:(NSString *)key;

@end

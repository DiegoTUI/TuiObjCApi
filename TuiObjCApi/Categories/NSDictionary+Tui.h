//
//  NSDictionary+Tui.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tui)

/**
 * Produces a new dictionary by aplying a block to all values
 * @param block the block to apply to all values
 * @return the string unescaped.
 */
-(NSDictionary *)dictionaryByMappingValuesWithBlock:(id (^)(id obj))block;

/**
 * Produces a new dictionary unescaping the values (ISO8859)
 * @return the string unescaped.
 */
-(NSDictionary *)dictionaryByUnescapingStringsInValues;

/**
 * Produces a JSON string from the dictionary
 * @return the JSON string. Nil if there was an error.
 */
-(NSString *)toJsonString;

/**
 * Produces an xml string from a properly formatted JSON Dictionary
 * The "@" prefix is used for attributes, the "#value" field is used for value, the "#list" field for lists
 * Check TuiDictionaryTests for an example
 * @return the xml string produced.
 * @throws TuiInvalidNodeException
 */
-(NSString *)produceXml;

@end

//
//  TuiParametrizedXml.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An XML defined through a JSON set of parameters. 
 * These parameters are written into the JSON and transtated into a XML string for queries
 * The "@" prefix is used for attributes, the "#" field is used for value.
 * @author diego
 */

@interface TuiParametrizedXml : NSObject

//The JSON String with the parameters to be replaced
@property (strong, nonatomic, readonly) NSString *baseJson;
//The parameters that will replace the $xxxxx$ strings in the baseJson
@property (strong, nonatomic, readonly) NSMutableDictionary *parameters;

/**
 * Inits the object with a certain JSON string
 * @param parameters the dictionary to init the object.
 * @return self.
 */
-(TuiParametrizedXml *)initWithJsonString:(NSString *)jsonString;

/**
 * Add a new parameter, key=value.
 * @param key the key for the parameter.
 * @param value the value of the parameter.
 * @return this object.
 */
-(TuiParametrizedXml *)addValue:(NSString *)value forKey:(NSString*)key;

/**
 * Add the parameters contained in a dictionary.
 * @param dictionary the source for key-value pairs.
 * @return this object.
 */
-(TuiParametrizedXml *)addKeysAndValuesFromDictionary:(NSDictionary *)dictionary;

/**
 * Reads the parameters and produces an XML string ready to query
 * @throws TuiInvalidJsonException
 * @return XML string.
 */
-(NSString *)getXmlString;

@end

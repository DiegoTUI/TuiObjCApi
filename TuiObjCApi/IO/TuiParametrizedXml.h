//
//  TuiParametrizedXml.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/18/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An XML defined through a set of parameters. 
 * There are to init options:
 *      - Through a parametrized Json string.
 *          These parameters are written into the JSON and transtated into a XML string for queries
 *          The "@" prefix is used for attributes, the "#" field is used for value.
 *      - Through a parametrized Xml string.
 * In all cases it produces an XML string ready to send to a query.
 * @author diego
 */

@interface TuiParametrizedXml : NSObject

/**
 * Inits the object with a certain JSON string
 * @param jsonString the JSON string properly formatted.
 * @return self.
 */
-(TuiParametrizedXml *)initWithJsonString:(NSString *)jsonString;

/**
 * Inits the object with a certain XML string
 * @param xmlString the XML string properly formatted.
 * @return self.
 */
-(TuiParametrizedXml *)initWithXmlString:(NSString *)xmlString;

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

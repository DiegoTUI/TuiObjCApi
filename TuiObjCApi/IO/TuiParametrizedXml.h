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
 * These parameters are transtated into a XML string for queries
 * The "@" prefix is used for attributes, the "#" field is used for value.
 * @author diego
 */

@interface TuiParametrizedXml : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary *parameters;

/**
 * Inits the object with a certain dictionary
 * @param parameters the dictionary to init the object.
 * @return self.
 */
-(TuiParametrizedXml *)initWithDictionary:(NSDictionary *)parameters;

/**
 * Reads the parameters and produces an XML string ready to query
 * @return XML string.
 */
-(NSString *)getXmlString;

@end

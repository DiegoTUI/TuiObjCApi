//
//  TuiXmlManager.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/22/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuiParametrizedXml.h"

/**
 * Manages a list of parametrized xmls
 * @author diego
 */
@interface TuiXmlManager : NSObject

/**
 * Inits the object with the JSON feed. 
 * @return this object.
 */
-(TuiXmlManager *)initWithJsonFeed;

/**
 * Inits the object with the XML feed.
 * @return this object.
 */
-(TuiXmlManager *)initWithXmlFeed;

/**
 * Get the parametrized XML for the given key
 * @param key the key for the object in xml list.
 * @return a parametrized XML with no parameters in it.
 */
-(TuiParametrizedXml *)getXmlWithKey:(NSString *)key;

@end

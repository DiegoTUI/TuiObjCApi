//
//  NSObject+Tui.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tui)

/**
 * Write a NSObject as a JSON object.
 * @param object the object to convert.
 * @return the result in JSON.
 */
-(NSDictionary *)convertObjectToJson;

@end

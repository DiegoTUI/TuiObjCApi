//
//  TuiUrlManager.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/26/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuiParametrizedUrl.h"

/**
 * Manages a list of parametrized urls
 * @author diego
 */
@interface TuiUrlManager : NSObject

/**
 * Get the parametrized URL for the given key
 * @param key the key for the object in xml list.
 * @return a parametrized XML with no parameters in it.
 */
-(TuiParametrizedUrl *)getUrlWithKey:(NSString *)key;

@end

//
//  NSString+Tui.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/19/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tui)

/**
 * Checks if the NSString contains a certain string with options
 * @param string the string to look for.
 * @param options the oprtions of the search.
 * @return true if the string was found.
 */
-(BOOL)containsString:(NSString *)string
          withOptions:(NSStringCompareOptions)options;

/**
 * Checks if the NSString contains a certain string with no options
 * @param string the string to look for.
 * @return true if the string was found.
 */
-(BOOL)containsString:(NSString *)string;

@end

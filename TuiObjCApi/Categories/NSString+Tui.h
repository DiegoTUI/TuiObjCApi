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

/**
 * Replaces only the first occurence of a string with the provided value
 * @param original the string to be replaced.
 * @param replacement the replacement.
 * @return the string replaced.
 */
-(NSString *)stringByReplacingFirstOccurrenceOfString:(NSString *)original
                                           withString:(NSString *)replacement;

@end

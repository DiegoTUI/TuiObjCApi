//
//  NSString+Tui.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/19/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "NSString+Tui.h"

@implementation NSString (Tui)

-(BOOL)containsString:(NSString *)string
          withOptions:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

-(BOOL)containsString:(NSString *)string {
    return [self containsString:string withOptions:0];
}

-(NSString *)stringByReplacingFirstOccurrenceOfString:(NSString *)original
                                           withString:(NSString *)replacement {
    NSString *result = self;
    NSRange rOriginal = [self rangeOfString: original];
    if (rOriginal.location != NSNotFound) {
        result = [self stringByReplacingCharactersInRange:rOriginal
                                               withString:replacement];
    }
    return result;
}

@end

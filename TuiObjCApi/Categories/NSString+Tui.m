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
    if (rng.location == NSNotFound)
        NSLog(@"%@ is NOT contained in %@", string, self);
    else
        NSLog(@"%@ is contained in %@", string, self);
    return rng.location != NSNotFound;
}

-(BOOL)containsString:(NSString *)string {
    return [self containsString:string withOptions:0];
}

@end

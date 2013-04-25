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

-(NSString *)stringByUnescapingISO8859 {
    NSString *value = [NSString stringWithString:self];
    value = [value stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    value = [value stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return value;
}

-(NSString *)toCamelCase {
    NSString *transformedkey = [NSString stringWithString:self];
    NSRange position = [transformedkey rangeOfString:@"_"];
    while (position.location != NSNotFound) {
        transformedkey = [NSString stringWithFormat:@"%@%@%@",
                          [transformedkey substringToIndex:position.location],
                          [[transformedkey substringWithRange:NSMakeRange(position.location + 1, 1)] uppercaseString],
                          [transformedkey substringFromIndex:position.location + 2]];
        
        position = [transformedkey rangeOfString:@"_"];
    }
    
    return transformedkey;
}

-(NSString *)urlEncodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                        NULL,
                                                        (__bridge CFStringRef)self,
                                                        NULL,
                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                        kCFStringEncodingUTF8);
    return result;
}

@end

//
//  NSString+Tui.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/19/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#define ARC4RANDOM_MAX      0x100000000

#import "NSString+Tui.h"
#import <Security/SecRandom.h>
#import <stdlib.h>

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

+(NSString *)randomStringWithLength:(NSInteger)length {
    NSString *alphabet = [NSString getCurrentAlphabet];
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t randomResult = 0;
        int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t*)&randomResult);
        if (result != 0)
            randomResult = arc4random();
        u_int32_t r = randomResult % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [NSString stringWithString:s];
}

+(NSString *)crappyRandomStringWithLength:(NSInteger)length {
    NSString *alphabet = [NSString getCurrentAlphabet];
    NSString *result = @"";
    for (NSInteger i=0; i<length; i++) {
        result = [result stringByAppendingString:[alphabet substringWithRange:NSMakeRange(floorf(((double)arc4random()/ARC4RANDOM_MAX)*[alphabet length]), 1)]];
    }
    return result;
}

+(NSString *)getCurrentAlphabet {
    return @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
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

-(NSString *)listify {
    return [(NSString *)[[self componentsSeparatedByString:@"."] lastObject] stringByAppendingString:@"List"];
}

@end

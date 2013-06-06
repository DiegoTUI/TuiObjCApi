//
//  TuiRandomIdsTest.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 5/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiRandomIdsTest.h"
#import "NSString+Tui.h"

@implementation TuiRandomIdsTest

-(void)testDifferentIdsGoodAlgorithm {
    NSUInteger numberofids = 10000;
    NSMutableSet *set = [NSMutableSet set];
    for (NSInteger i=0; i<numberofids; i++) {
        NSString *stringtoadd = [NSString randomStringWithLength:8];
        STAssertEquals([stringtoadd length], (NSUInteger)8, @"Random id generated a key of incorrect length");
        [set addObject:stringtoadd];
    }
    STAssertEquals(numberofids, [set count], @"Random id generated %d repeated keys among %d", numberofids-[set count], numberofids);
}

-(void)testDifferentRandomIdsCrappyAlgorithm {
    NSUInteger numberofids = 10000;
    NSMutableSet *set = [NSMutableSet set];
    for (NSInteger i=0; i<numberofids; i++) {
        NSString *stringtoadd = [NSString crappyRandomStringWithLength:8];
        STAssertEquals([stringtoadd length], (NSUInteger)8, @"Random id generated a key of incorrect length");
        [set addObject:stringtoadd];
    }
    STAssertEquals(numberofids, [set count], @"Crappy random id generated %d repeated keys among %d", numberofids-[set count], numberofids);
}

@end

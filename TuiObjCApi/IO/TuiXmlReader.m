//
//  TuiXmlReader.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlReader.h"

#pragma mark - Private interface

#pragma mark - Implementation
@implementation TuiXmlReader

#pragma mark - Public methods
+(TuiXmlReader *)sharedInstance {
    static TuiXmlReader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiXmlReader alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Private methods

@end

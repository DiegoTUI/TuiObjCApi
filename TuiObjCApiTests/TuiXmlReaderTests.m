//
//  TuiXmlReaderTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlReaderTests.h"

@interface TuiXmlReaderTests ()

@property (strong, nonatomic) NSArray *hotelListMap;

@end

@implementation TuiXmlReaderTests

-(void)setUp {
    [super setUp];
    //Set up code here.
    _hotelListMap =@[@"Code",
                     @"Name",
                     @{@"DescriptionList":@[@{@"Description":@"Description",
                                              @"Language":@"Description.@languageCode"}]},
                     @{@"ImageList":@[@{@"Type":@"Image.Type",
                                        @"Description":@"Image.Description",
                                        @"Url":@"Image.Url"}]},
                     @{@"Category":@"Category.@code"}];
}

-(void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

@end

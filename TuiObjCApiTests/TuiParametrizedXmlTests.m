//
//  TuiParametrizedXmlTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/19/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedXmlTests.h"
#import "TuiParametrizedXml.h"

@interface TuiParametrizedXmlTests ()

-(NSDictionary *)regularJsonXml;

@end

@implementation TuiParametrizedXmlTests

- (void)setUp {
    [super setUp];
    //Set-up code here
}

- (void)tearDown {
    //Tear-down code here.
    [super tearDown];
}

-(void)testRegularJson{
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithDictionary:[self regularJsonXml]];
    NSLog(@"created xml: %@", [paramxml getXmlString]);
}

#pragma mark - Private methods
-(NSDictionary *)regularJsonXml{
    NSDictionary *result = @{@"HotelListRQ": @{
                                     @"@echoToken":@"DummyEchoToken",
                                     @"@xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                                     @"@xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                                     @"@xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                                     @"Language":@{@"#":@"ENG"},
                                     @"Credentials":@{
                                             @"User":@{@"#":@"ISLAS"},
                                             @"Password":@{@"#":@"ISLAS"}
                                             },
                                     @"Destination":@{
                                             @"@code":@"PMI",
                                             @"@type":@"SIMPLE",
                                             @"Name":@{@"#":@"Palma"},
                                             @"#":@"Test"
                                             }
                                     }
                             };
    return result;
}

@end

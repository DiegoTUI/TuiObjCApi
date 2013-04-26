//
//  AtlasCallTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/25/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "AtlasCallTests.h"
#import "TuiXmlManager.h"
#import "TuiParametrizedXml.h"
#import "TuiUrlReader.h"
#import "NSString+Tui.h"


@interface AtlasCallTests ()

@property (strong, nonatomic) NSDictionary *paramHotelList;

@end

@implementation AtlasCallTests

-(void)setUp {
    [super setUp];
    //Set up code here.
    _paramHotelList = @{@"echoToken":@"DummyEchoToken",
                        @"xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                        @"xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                        @"xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                        @"Language":@"ENG",
                        @"Credentials_User":@"BDS",
                        @"Credentials_Password":@"BDS",
                        @"Destination_code":@"PMI",
                        @"Destination_type":@"SIMPLE"};
}

-(void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

-(void)testCallAtlasHotelListRQ {
    TuiXmlManager *xmlmanager = [[TuiXmlManager alloc] initWithJsonFeed];
    //get HotelListRQ
    TuiParametrizedXml *hotelListRQ = [xmlmanager getXmlWithKey:@"HotelListRQ"];
    [hotelListRQ addKeysAndValuesFromDictionary:_paramHotelList];
    NSString *xmlString = [hotelListRQ getXmlString];
    TuiParametrizedUrl *url = [[TuiParametrizedUrl alloc] initWithUrl:@"http://212.170.239.71/appservices/http/FrontendService?xml_request=$xml_request$"];
    [url addValue:xmlString forKey:@"xml_request"];
    [url setPost:YES];
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url];
    //NSData *response = [[TuiUrlReader sharedInstance] readPostFromUrl:baseurl withBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *responsestring = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Response from Atlas: %@", responsestring);
}

@end

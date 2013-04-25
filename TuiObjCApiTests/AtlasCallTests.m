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
    NSString *baseurl = @"http://212.170.239.71/appservices/http/FrontendService";
    //NSString *baseurl = @"http://54.246.80.107/api/test_post.php";
    //NSString *url = [NSString stringWithFormat:@"%@?%@", baseurl, [xmlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"%@?xml_request=%@", baseurl, xmlString];
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url withMethod:@"POST"];
    //NSData *response = [[TuiUrlReader sharedInstance] readPostFromUrl:baseurl withBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *responsestring = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Response from Atlas: %@", responsestring);
}

@end

//
//  TuiXmlReaderTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlReaderTests.h"
#import "TuiXmlManager.h"
#import "TuiUrlReader.h"
#import "TuiXmlReader.h"
#import "TuiUrlManager.h"

@interface TuiXmlReaderTests ()

@property (strong, nonatomic) NSArray *hotelListMap;
@property (strong, nonatomic) NSDictionary *paramHotelList;

-(void)checkDictionary:(NSDictionary *)dictionary
    withDescriptionMap:(NSArray *)descriptionMap;

@end

@implementation TuiXmlReaderTests

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

-(void)testParseHotelsFromAtlas {
    //get HotelListRQ
    TuiParametrizedXml *hotelListRQ = [[[TuiXmlManager alloc] initWithJsonFeed] getXmlWithKey:@"HotelListRQ"];
    [hotelListRQ addKeysAndValuesFromDictionary:_paramHotelList];
    NSString *xmlString = [hotelListRQ getXmlString];
    TuiParametrizedUrl *url = [[TuiUrlManager new] getUrlWithKey:@"ATLAS"];
    [url addValue:xmlString forKey:@"xml_request"];
    [url setPost:YES];
    NSDate *start = [NSDate date];
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url];
    NSTimeInterval interval = [start timeIntervalSinceNow];
    NSLog (@"Response from Atlas took %f seconds", interval);
    //NSData *response = [[TuiUrlReader sharedInstance] readPostFromUrl:baseurl withBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *xmlResponseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    start = [NSDate date];
    NSArray *hotels = [[TuiXmlReader sharedInstance] readObjectsFromXmlString:xmlResponseString lookingFor:@"Hotel" usingDescriptionMap:_hotelListMap];
    interval = [start timeIntervalSinceNow];
    NSLog (@"Xml parsing took %f seconds", interval);
    NSLog(@"Number of Hotels retrieved from Atlas: %d", [hotels count]);
    //NSLog(@"Hotels retrieved: %@", hotels);
    STAssertTrue([hotels count] > 750, @"Too few hotels retrieves from Atlas: %d", [hotels count]);
    for (NSDictionary *hotel in hotels) {
        [self checkDictionary:hotel withDescriptionMap:_hotelListMap];
    }
    
}

-(void)checkDictionary:(NSDictionary *)dictionary
    withDescriptionMap:(NSArray *)descriptionMap {
    for (id item in descriptionMap) {
        if ([item isKindOfClass:[NSString class]]) {
            STAssertTrue([dictionary objectForKey:item] != nil, @"Key %@ does not exist in dictionary %@", item, dictionary);
        } else if ([item isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in item) {
                STAssertTrue([dictionary objectForKey:key] != nil, @"Key %@ does not exist in dictionary %@", key, dictionary);
            }
        }
    }
}

@end

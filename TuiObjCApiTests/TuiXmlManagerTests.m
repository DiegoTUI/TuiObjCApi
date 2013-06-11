//
//  TuiXmlManagerTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiXmlManagerTests.h"
#import "TuiContextCache.h"
#import "TuiXmlManager.h"
#import "NSString+Tui.h"
#import "TuiDateFormatter.h"

@interface TuiXmlManagerTests ()

@property (strong, nonatomic) NSDictionary *paramHotelList;
@property (strong, nonatomic) NSDictionary *paramTicketAvail;

//Checks that the keys and values of a given dictionary are in the provided xml string
-(void)checkXmlString:(NSString *)xmlString
       withBaseString:(NSString *)baseString
        andDictionary:(NSDictionary *)dictionary;

@end

@implementation TuiXmlManagerTests

-(void)setUp {
    [super setUp];
    //Set-up code here
    [[TuiContextCache sharedInstance] setTestUserDefaults:[[NSUserDefaults alloc] init]];
    _paramHotelList = @{@"echoToken":@"DummyEchoToken",
                        @"xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                        @"xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                        @"xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                        @"Language":@"ENG",
                        @"Credentials_User":@"ISLAS",
                        @"Credentials_Password":@"ISLAS",
                        @"Destination_code":@"PMI",
                        @"Destination_type":@"SIMPLE",
                        @"Destination_Name":@"Palma"};
    NSDate *datefrom = [NSDate date];
    NSDateComponents *datecomponents = [[NSDateComponents alloc] init];
    datecomponents.day = 2;
    NSDate *dateto = [[[TuiDateFormatter sharedInstance] getCalendar] dateByAddingComponents:datecomponents toDate:datefrom options:0];
    NSString *datefromstring = [[[TuiDateFormatter sharedInstance] formatStringFromDate:datefrom] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *datetostring = [[[TuiDateFormatter sharedInstance] formatStringFromDate:dateto] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    _paramTicketAvail = @{@"echoToken":@"DummyEchoToken",
                          @"sessionId":@"DummySessionId",
                          @"xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                          @"xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                          @"xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                          @"Language":@"ENG",
                          @"Credentials_User":@"ISLAS",
                          @"Credentials_Password":@"ISLAS",
                          @"Destination_code":@"PMI",
                          @"Destination_type":@"SIMPLE",
                          @"PaginationData_itemsPerPage":@"25",
                          @"PaginationData_pageNumber":@"1",
                          @"ServiceOccupancy_AdultCount":@"1",
                          @"ServiceOccupancy_ChildCount":@"0",
                          @"DateFrom_date":datefromstring,
                          @"DateTo_date":datetostring};
}

-(void)tearDown {
    //Tear-down code here.
    [super tearDown];
}

-(void) testJsonFeed {
    TuiXmlManager *xmlmanager = [[TuiXmlManager alloc] initWithJsonFeed];
    //get HotelListRQ
    TuiParametrizedXml *hotelListRQ = [xmlmanager getXmlWithKey:@"HotelListRQ"];
    [hotelListRQ addKeysAndValuesFromDictionary:_paramHotelList];
    NSString *xmlString = [hotelListRQ getXmlString];
    NSLog(@"testJsonFeed HotelListRQ: %@", xmlString);
    [self checkXmlString:xmlString withBaseString:[hotelListRQ getBaseString] andDictionary:_paramHotelList];
    //get TicketAvailRQ
    TuiParametrizedXml *ticketAvailRQ = [xmlmanager getXmlWithKey:@"TicketAvailRQ"];
    [ticketAvailRQ addKeysAndValuesFromDictionary:_paramTicketAvail];
    xmlString = [ticketAvailRQ getXmlString];
    NSLog(@"testJsonFeed TicketAvailRQ: %@", xmlString);
    [self checkXmlString:xmlString withBaseString:[ticketAvailRQ getBaseString] andDictionary:_paramTicketAvail];
    
}

-(void) testXmlFeed {
    TuiXmlManager *xmlmanager = [[TuiXmlManager alloc] initWithXmlFeed];
    //get HotelListRQ
    TuiParametrizedXml *hotelListRQ = [xmlmanager getXmlWithKey:@"HotelListRQ"];
    [hotelListRQ addKeysAndValuesFromDictionary:_paramHotelList];
    NSString *xmlString = [hotelListRQ getXmlString];
    NSLog(@"testXmlFeed HotelListRQ: %@", xmlString);
    [self checkXmlString:xmlString withBaseString:[hotelListRQ getBaseString] andDictionary:_paramHotelList];
    //get TicketAvailRQ
    TuiParametrizedXml *ticketAvailRQ = [xmlmanager getXmlWithKey:@"TicketAvailRQ"];
    [ticketAvailRQ addKeysAndValuesFromDictionary:_paramTicketAvail];
    xmlString = [ticketAvailRQ getXmlString];
    NSLog(@"testJsonFeed TicketAvailRQ: %@", xmlString);
    [self checkXmlString:xmlString withBaseString:[ticketAvailRQ getBaseString] andDictionary:_paramTicketAvail];
}

-(void)checkXmlString:(NSString *)xmlString
       withBaseString:(NSString *)baseString
        andDictionary:(NSDictionary *)dictionary {
    //go through the dictionary
    for (NSString *key in dictionary) {
        if ([baseString containsString:[NSString stringWithFormat:@"$%@$",key]]){
            STAssertTrue([xmlString containsString:dictionary[key]], @"Value %@ for key %@ cant be found in xml %@", dictionary[key], key, xmlString);
        }
    }
}

@end

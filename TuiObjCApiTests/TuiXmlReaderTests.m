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
#import "NSString+Tui.h"

@interface TuiXmlReaderTests ()

@property (strong, nonatomic) NSArray *hotelListMap;
@property (strong, nonatomic) NSArray *ticketAvailMap;
@property (strong, nonatomic) NSDictionary *paramHotelList;
@property (strong, nonatomic) NSString *ticketAvailXmlString;

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
                     @{@"DescriptionList.Description":@[@{@"Description":@"",
                                                          @"Language":@"@languageCode"}]},
                     @{@"ImageList.Image":@[@{@"Type":@"Type",
                                              @"Description":@"Description",
                                              @"Url":@"Url"}]},
                     @{@"Category":@"Category.@code"}];
    
    _ticketAvailXmlString = @"<TicketAvailRS xsi-schemaLocation=\"http://www.hotelbeds.com/schemas/2005/06/messages TicketAvailRS.xsd\" totalItems=\"27\" echoToken=\"DummyEchoToken\"> \
	<AuditData> \
    <ProcessTime>647</ProcessTime> \
    <Timestamp>2013-05-13 10:49:38.031</Timestamp> \
    <RequestHost>10.162.29.83</RequestHost> \
    <ServerName>FORM</ServerName> \
    <ServerId>FO</ServerId> \
    <SchemaRelease>2005/06</SchemaRelease>  \
    <HydraCoreRelease>2.0.201304221213</HydraCoreRelease> \
    <HydraEnumerationsRelease>1.0.201304221213</HydraEnumerationsRelease> \
    <MerlinRelease>N/A</MerlinRelease> \
	</AuditData> \
	<PaginationData currentPage=\"1\" totalPages=\"2\"/> \
	<ServiceTicket xsi-type=\"ServiceTicket\" availToken=\"9ey6mENxtyujqkVKnqvpMA==\"> \
    <DateFrom date=\"DateFrom1\"/> \
    <DateTo date=\"DateTo1\"/> \
    <Currency code=\"EUR1\">Euro1</Currency> \
    <TicketInfo xsi-type=\"ProductTicket\"> \
    <Code>000200515</Code> \
    <Name>Ticket1</Name> \
    <DescriptionList> \
    <Description type=\"generalDescription\" languageCode=\"ENG\">Description 11</Description> \
    <Description type=\"generalDescription\" languageCode=\"SPA\">Descripcion 12</Description> \
    </DescriptionList> \
    <ImageList> \
    <Image> \
    <Type>L</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image11</Url> \
    </Image> \
    <Image> \
    <Type>S</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image12</Url> \
    </Image> \
    <Image> \
    <Type>S</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image13</Url> \
    </Image> \
    </ImageList> \
    </TicketInfo> \
	</ServiceTicket> \
	<ServiceTicket xsi-type=\"ServiceTicket\" availToken=\"9ey6mENxtyujqkVKnqvpMA==\"> \
    <DateFrom date=\"DateFrom2\"/> \
    <DateTo date=\"DateTo2\"/> \
    <Currency code=\"EUR2\">Euro2</Currency> \
    <TicketInfo xsi-type=\"ProductTicket\"> \
    <Code>000200515</Code> \
    <Name>Ticket2</Name> \
    <DescriptionList> \
    <Description type=\"generalDescription\" languageCode=\"ENG\">Description 21</Description> \
    <Description type=\"generalDescription\" languageCode=\"SPA\">Descripcion 22</Description> \
    </DescriptionList> \
    <ImageList> \
    <Image> \
    <Type>L</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image21</Url> \
    </Image> \
    <Image> \
    <Type>S</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image22</Url> \
    </Image> \
    <Image> \
    <Type>S</Type> \
    <Order>0</Order> \
    <VisualizationOrder>0</VisualizationOrder> \
    <Url>Image23</Url> \
    </Image> \
    </ImageList> \
    </TicketInfo> \
	</ServiceTicket> \
    </TicketAvailRS>";
    
    _ticketAvailMap =@[@{@"DateFrom":@"DateFrom.@date"},
                       @{@"DateTo":@"DateTo.@date"},
                       @"Currency",
                       @{@"CurrencyCode":@"Currency.@code"},
                       @{@"Name":@"TicketInfo.Name"},
                       @{@"TicketInfo.DescriptionList.Description":@[@{@"Description":@"",
                                                                       @"Type":@"@type"}]},
                       @{@"TicketInfo.ImageList.Image":@[@{@"Type":@"Type",
                                                           @"Url":@"Url"}]}];
}

-(void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

-(void)testTicketAvailXmlString {
    NSArray *tickets = [[TuiXmlReader sharedInstance] readObjectsFromXmlString:_ticketAvailXmlString lookingFor:@"ServiceTicket" usingDescriptionMap:_ticketAvailMap];
    STAssertTrue([tickets count] == 2, @"Wrong number of tickets parsed. Should be 2, and it is %d", [tickets count]);
    STAssertTrue([tickets[0][@"DateFrom"] isEqualToString:@"DateFrom1"], @"Wrong value for DateFrom in element 0: %@", tickets[0][@"DateFrom"]);
    STAssertTrue([tickets[0][@"DateTo"] isEqualToString:@"DateTo1"], @"Wrong value for DateTo in element 0: %@", tickets[0][@"DateTo"]);
    STAssertTrue([tickets[1][@"DateFrom"] isEqualToString:@"DateFrom2"], @"Wrong value for DateFrom in element 1: %@", tickets[1][@"DateFrom"]);
    STAssertTrue([tickets[1][@"DateTo"] isEqualToString:@"DateTo2"], @"Wrong value for DateTo in element 1: %@", tickets[1][@"DateTo"]);
    STAssertTrue([tickets[0][@"Currency"] isEqualToString:@"Euro1"], @"Wrong value for Currency in element 0: %@", tickets[0][@"Currency"]);
    STAssertTrue([tickets[0][@"CurrencyCode"] isEqualToString:@"EUR1"], @"Wrong value for CurrencyCode in element 0: %@", tickets[0][@"CurrencyCode"]);
    STAssertTrue([tickets[1][@"Currency"] isEqualToString:@"Euro2"], @"Wrong value for Currency in element 1: %@", tickets[1][@"Currency"]);
    STAssertTrue([tickets[1][@"CurrencyCode"] isEqualToString:@"EUR2"], @"Wrong value for CurrencyCode in element 1: %@", tickets[1][@"CurrencyCode"]);
    STAssertTrue([tickets[0][@"Name"] isEqualToString:@"Ticket1"], @"Wrong value for Name in element 0: %@", tickets[0][@"Name"]);
    STAssertTrue([tickets[1][@"Name"] isEqualToString:@"Ticket2"], @"Wrong value for Name in element 1: %@", tickets[1][@"Name"]);
    STAssertTrue([tickets[0][@"DescriptionList"] count] == 2, @"Wrong number of descriptions parsed for element 0: %d", [tickets[0][@"DescriptionList"] count]);
    STAssertTrue([tickets[0][@"ImageList"] count] == 3, @"Wrong number of images parsed for element 0: %d", [tickets[0][@"ImageList"] count]);
    STAssertTrue([tickets[1][@"DescriptionList"] count] == 2, @"Wrong number of descriptions parsed for element 1: %d", [tickets[1][@"DescriptionList"] count]);
    STAssertTrue([tickets[1][@"ImageList"] count] == 3, @"Wrong number of images parsed for element 1: %d", [tickets[1][@"ImageList"] count]);
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
                if ([item[key] isKindOfClass:[NSArray class]]) {
                    STAssertTrue([dictionary objectForKey:[key listify]] != nil, @"Key %@ does not exist in dictionary %@", [key listify], dictionary);
                }
                else {
                    STAssertTrue([dictionary objectForKey:key] != nil, @"Key %@ does not exist in dictionary %@", key, dictionary);
                }
            }
        }
    }
}

@end

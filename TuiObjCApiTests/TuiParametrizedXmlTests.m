//
//  TuiParametrizedXmlTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/19/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiParametrizedXmlTests.h"
#import "TuiParametrizedXml.h"
#import "NSString+Tui.h"

@interface TuiParametrizedXmlTests ()

@property (strong, nonatomic) NSDictionary *paramDictionary;

//Creates a regular base json string to be converted to xml
-(NSString *)regularBaseJsonString;
//Creates a "list" base json string to be converted to xml
-(NSString *)listBaseJsonString;
//Creates a regular base xml string to be converted to xml
-(NSString *)regularBaseXmlString;
//Creates a "list" base xml string to be converted to xml
-(NSString *)listBaseXmlString;
//Checks that the keys and values of a given dictionary are in the provided xml string
-(void)checkXmlString:(NSString *)xmlString
       withBaseString:(NSString *)baseString
        andDictionary:(NSDictionary *)dictionary;

@end

@implementation TuiParametrizedXmlTests

- (void)setUp {
    [super setUp];
    //Set-up code here
    _paramDictionary = @{@"echoToken":@"DummyEchoToken",
                         @"xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                         @"xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                         @"xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                         @"Language":@"ENG",
                         @"Credentials_User":@"ISLAS",
                         @"Credentials_Password":@"ISLAS",
                         @"Destination_code":@"PMI",
                         @"Destination_type":@"SIMPLE",
                         @"Destination":@"TEST",
                         @"Destination_Name":@"Palma",
                         @"ZoneList_Name_1":@"Zone1",
                         @"ZoneList_Name_2":@"Zone2",
                         @"ZoneList_Name_3":@"Zone3"
                         };
}

- (void)tearDown {
    //Tear-down code here.
    [super tearDown];
}

-(void)testRegularJson {
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithJsonString:[self regularBaseJsonString]];
    [paramxml addKeysAndValuesFromDictionary:_paramDictionary];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
          withBaseString:[self regularBaseJsonString]
           andDictionary:_paramDictionary];
}

-(void)testListJson {
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithJsonString:[self listBaseJsonString]];
    [paramxml addKeysAndValuesFromDictionary:_paramDictionary];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
          withBaseString:[self listBaseJsonString]
           andDictionary:_paramDictionary];
}

-(void)testRegularXml {
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithXmlString:[self regularBaseXmlString]];
    [paramxml addKeysAndValuesFromDictionary:_paramDictionary];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
          withBaseString:[self regularBaseJsonString]
           andDictionary:_paramDictionary];
}

-(void)testListXml{
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithXmlString:[self listBaseXmlString]];
    [paramxml addKeysAndValuesFromDictionary:_paramDictionary];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
          withBaseString:[self regularBaseJsonString]
           andDictionary:_paramDictionary];
}

#pragma mark - Private methods
-(NSString *)regularBaseJsonString {
    NSString *result = @"{\"HotelListRQ\": {\"@echoToken\":\"$echoToken$\",\"@xmlns\":\"$xmlns$\",\"@xmlns:xsi\":\"$xmlns:xsi$\",\"@xsi:schemaLocation\":\"$xsi:schemaLocation$\",\"Language\":{\"#\":\"$Language$\"},\"Credentials\":{\"User\":{\"#\":\"$Credentials_User$\"},\"Password\":{\"#\":\"$Credentials_Password$\"}},\"Destination\":{\"@code\":\"Destination_code\",\"@type\":\"$Destination_type$\",\"Name\":{\"#\":\"$Destination_Name$\"},\"#\":\"$Destination$\"}}}";
    return result;
}

-(NSString *)listBaseJsonString {
    NSString *result = @"{\"HotelListRQ\": {\"@echoToken\":\"$echoToken$\",\"@xmlns\":\"$xmlns$\",\"@xmlns:xsi\":\"$xmlns:xsi$\",\"@xsi:schemaLocation\":\"$xsi:schemaLocation$\",\"Language\":{\"#\":\"$Language$\"},\"Credentials\":{\"User\":{\"#\":\"$Credentials_User$\"},\"Password\":{\"#\":\"$Credentials_Password$\"}},\"Destination\":{\"@code\":\"Destination_code\",\"@type\":\"$Destination_type$\",\"Name\":{\"#\":\"$Destination_Name$\"},\"ZoneList\":[{\"Name\":{\"#\":\"$Zone_Name_1$\"}},{\"Name\":{\"#\":\"$Zone_Name_2$\"}},{\"Name\":{\"#\":\"$Zone_Name_3$\"}}],\"#\":\"$Destination$\"}}}";
    
    return result;
}

-(NSString *)regularBaseXmlString {
    NSString *result = @"<HotelListRQ echoToken=\"$echoToken$\" xmlns=\"$xmlns$\" xmlns:xsi=\"$xmlns:xsi$\" xsi:schemaLocation=\"$xsi:schemaLocation$\"><Language>$Language$</Language><Credentials><User>$Credentials_User$</User><Password>$Credentials_Password$</Password></Credentials><Destination code=\"$Destination_code$\" type=\"$Destination_type$\">$Destination$<Name>$Destination_Name$</Name></Destination</HotelListRQ>";
    return result;
}

-(NSString *)listBaseXmlString {
    NSString *result = @"<HotelListRQ echoToken=\"$echoToken$\" xmlns=\"$xmlns$\" xmlns:xsi=\"$xmlns:xsi$\" xsi:schemaLocation=\"$xsi:schemaLocation$\"><Language>$Language$</Language><Credentials><User>$Credentials_User$</User><Password>$Credentials_Password$</Password></Credentials><Destination code=\"$Destination_code$\" type=\"$Destination_type$\">$Destination$<Name>$Destination_Name$</Name><ZoneList><Name>$ZoneList_Name_1$</Name><Name>$ZoneList_Name_2$</Name><Name>$ZoneList_Name_3$</Name></ZoneList></Destination</HotelListRQ>";
    return result;
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

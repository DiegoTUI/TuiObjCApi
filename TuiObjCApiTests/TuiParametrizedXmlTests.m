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

//Creates a regular base json string to be converted to xml
-(NSString *)regularBaseJsonString;
//Creates a "list" base json string to be converted to xml
-(NSString *)listBaseJsonString;
//Checks that the keys and values of a given dictionary are in the provided xml string
-(void)checkXmlString:(NSString *)xmlString
         withBaseJson:(NSString *)baseJson
       andDictionary:(NSDictionary *)dictionary;

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
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithJsonString:[self regularBaseJsonString]];
    NSDictionary *paramdict = @{@"echoToken":@"DummyEchoToken",
                                @"xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                                @"xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                                @"xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                                @"Language":@"ENG",
                                @"Credentials_User":@"ISLAS",
                                @"Credentials_Password":@"ISLAS",
                                @"Destination_code":@"PMI",
                                @"Destination_type":@"SIMPLE",
                                @"Destination":@"TEST",
                                @"Destination_Name":@"Palma"
                                };
    [paramxml addKeysAndValuesFromDictionary:paramdict];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
            withBaseJson:[self regularBaseJsonString]
           andDictionary:paramdict];
}

-(void)testListJson{
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithJsonString:[self listBaseJsonString]];
    NSDictionary *paramdict = @{@"echoToken":@"DummyEchoToken",
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
                                @"Zone_Name_1":@"Zone1",
                                @"Zone_Name_2":@"Zone2",
                                @"Zone_Name_3":@"Zone3"
                                };
    [paramxml addKeysAndValuesFromDictionary:paramdict];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring
            withBaseJson:[self listBaseJsonString]
           andDictionary:paramdict];
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

-(void)checkXmlString:(NSString *)xmlString
         withBaseJson:(NSString *)baseJson
        andDictionary:(NSDictionary *)dictionary {
    //go through the dictionary
    for (NSString *key in dictionary) {
        if ([baseJson containsString:[NSString stringWithFormat:@"$%@$",key]]){
            STAssertTrue([xmlString containsString:dictionary[key]], @"Value %@ for key %@ cant be found in xml %@", dictionary[key], key, xmlString);
        }
    }
}

@end

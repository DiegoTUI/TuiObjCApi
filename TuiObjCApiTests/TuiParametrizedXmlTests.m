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

//Creates a regular dictionary to be converted to xml
-(NSDictionary *)regularJsonXml;
//Creates a "list" dictionary to be converted to xml
-(NSDictionary *)listJsonXml;
//Checks that the keys and values of a given dictionary are in the provided xml string
-(void)checkXmlString:(NSString *)xmlString
       withDictionary:(NSDictionary *)dictionary;

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
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring withDictionary:[self regularJsonXml]];
}

-(void)testListJson{
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithDictionary:[self listJsonXml]];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    [self checkXmlString:xmlstring withDictionary:[self listJsonXml]];
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

-(NSDictionary *)listJsonXml{
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
                                             @"ZoneList":@[
                                                     @{@"Name":@{@"#":@"Zone1"}},
                                                     @{@"Name":@{@"#":@"Zone2"}},
                                                     @{@"Name":@{@"#":@"Zone3"}}
                                                    ],
                                             @"Name":@{@"#":@"Palma"},
                                             @"#":@"Test"
                                             }
                                     }
                             };
    return result;
}

-(void)checkXmlString:(NSString *)xmlString
       withDictionary:(NSDictionary *)dictionary {
    //go through the dictionary
    for (NSString *key in dictionary) {
        //attributes
        if ([key hasPrefix:@"@"]) {
            
            STAssertTrue([xmlString containsString:[key substringFromIndex:1]], @"Attribute %@ was not found in xml: %@", [key substringFromIndex:1], xmlString);
            STAssertTrue([xmlString containsString:dictionary[key]], @"Value %@ of attribute %@ was not found in xml: %@", dictionary[key], [key substringFromIndex:1], xmlString);
        }
        //value
        else if ([key isEqualToString:@"#"]) {
            STAssertTrue([xmlString containsString:dictionary[key]], @"Value %@ of attribute %@ was not found in xml: %@", dictionary[key], [key substringFromIndex:1], xmlString);
        }
        //element
        else {
            //if it's a dictionary
            if ([dictionary[key] isKindOfClass:[NSDictionary class]]) {
                [self checkXmlString:xmlString withDictionary:dictionary[key]];
            }
            //if it's an array
            else if ([dictionary[key] isKindOfClass:[NSArray class]]) {
                for (id item in dictionary[key]) {
                    if ([item isKindOfClass:[NSDictionary class]]) {
                        [self checkXmlString:xmlString withDictionary:item];
                    }
                    else {
                        STFail(@"Malformed XML dictionary. Key %@ has an array of arrays in it: %@", key, dictionary);
                    }
                }
            }
        }
    }
}

@end

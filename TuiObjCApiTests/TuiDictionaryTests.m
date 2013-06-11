//
//  TuiDictionaryTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 11/06/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiDictionaryTests.h"
#import "NSDictionary+Tui.h"
#import "NSString+Tui.h"

@interface TuiDictionaryTests ()

@property (strong, nonatomic) NSDictionary *jsonObject;

//Checks that a node exists in a given xml string
-(void)checkNodeWithKey:(NSString *)key
                  value:(id)value
           andXmlString:(NSString *)xmlString;

@end

@implementation TuiDictionaryTests

-(void)setUp {
    [super setUp];
    //Set-up code here
    _jsonObject =@{@"HotelListRQ":@{
                           @"@echoToken":@"DummyEchoToken",
                           @"@xmlns":@"http://www.hotelbeds.com/schemas/2005/06/messages",
                           @"@xmlns:xsi":@"http://www.w3.org/2001/XMLSchema-instance",
                           @"@xsi:schemaLocation":@"http://www.hotelbeds.com/schemas/2005/06/messages HotelListRQ.xsd",
                           @"Language":@"ENG",
                           @"Credentials":@{
                                   @"User":@"ISLAS",
                                   @"Password":@"ISLAS"
                                   },
                           @"Destination":@{
                                   @"@code":@"PMI",
                                   @"@type":@"SIMPLE",
                                   @"Name":@"Palma",
                                   @"#value":@"CRAP"
                                   },
                           @"ZoneList":@[@{@"zone":@{@"@code":@"01",
                                                     @"Name":@"Magaluf"}},
                                         @{@"zone":@{@"@code":@"02",
                                                     @"Name":@"Ses Figueres"}},
                                         @{@"zone":@{@"@code":@"03",
                                                     @"Name":@"Sa Calobra"}}
                                         ],
                           @"#list":@[@{@"Classification":@{@"code":@"C1",
                                                            @"#value":@"Class1"}},
                                      @{@"Classification":@{@"code":@"C2",
                                                            @"#value":@"Class2"}}
                                      ]
                           }
                   };
}

-(void)tearDown {
    //Tear-down code here.
    [super tearDown];
}

-(void)testProduceXml {
    NSString *xmlstring = [_jsonObject produceXml];
    NSLog(@"created xml: %@", xmlstring);
    for (NSString *key in _jsonObject) {
        [self checkNodeWithKey:key value:_jsonObject[key] andXmlString:xmlstring];
    }
}

-(void)checkNodeWithKey:(NSString *)key
                  value:(id)value
           andXmlString:(NSString *)xmlString {
    if ([key hasPrefix:@"@"]) {
        STAssertTrue([xmlString containsString:[key substringFromIndex:1]], [NSString stringWithFormat:@"attribute key %@ not present in xmlString", key]);
    } else if ([key isEqualToString:@"#value"]) {
        STAssertTrue([xmlString containsString:(NSString *)value], [NSString stringWithFormat:@"value %@ not present in xmlString", (NSString *)value]);
    } else if ([key isEqualToString:@"#list"]) {
        if (![value isKindOfClass:[NSArray class]])
            STFail(@"#list key was not followed by NSArray");
        for (NSDictionary *item in (NSArray *)value) {
            for (NSString *innerKey in item) {
                [self checkNodeWithKey:innerKey value:item[innerKey] andXmlString:xmlString];
            }
        }
    } else {
        NSString *opening = [NSString stringWithFormat:@"<%@",key];
        NSString *closing = [NSString stringWithFormat:@"</%@>",key];
        STAssertTrue([xmlString containsString:opening], [NSString stringWithFormat:@"opening key %@ not present in xmlString", key]);
        STAssertTrue([xmlString containsString:closing], [NSString stringWithFormat:@"closing key %@ not present in xmlString", key]);
        if ([value isKindOfClass:[NSString class]]) {
            STAssertTrue([xmlString containsString:value], [NSString stringWithFormat:@"value %@ not present in xmlString", value]);
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)value) {
                for (NSString *innerKey in item) {
                    [self checkNodeWithKey:innerKey value:item[innerKey] andXmlString:xmlString];
                }
            }
        } else { //it's a NSDictionary
            if (![value isKindOfClass:[NSDictionary class]])
                STFail(@"Wrong Value type");
            for (NSString *innerKey in (NSDictionary *)value) {
                [self checkNodeWithKey:innerKey value:value[innerKey] andXmlString:xmlString];
            }
        }
    }
}

@end

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
#import "NSDictionary+Tui.h"

@interface TuiParametrizedXmlTests ()

@property (strong, nonatomic) NSDictionary *paramDictionary;
@property (strong, nonatomic) NSDictionary *jsonObject;

//Checks that a node exists in a given xml string
-(void)checkNodeWithKey:(NSString *)key
                  value:(id)value
              xmlString:(NSString *)xmlString
     andParamDictionary:(NSDictionary *)paramDictionary;

//Explores a param dictionary and gets the value for a key between $$
-(NSString *) getValueForKey:(NSString *)key
           inParamDictionary:(NSDictionary *)paramDictionary;

@end

@implementation TuiParametrizedXmlTests

-(void)setUp {
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
                         @"ZoneList_code_1":@"01",
                         @"ZoneList_code_2":@"02",
                         @"ZoneList_code_3":@"03",
                         @"ZoneList_Name_1":@"Alcudia",
                         @"ZoneList_Name_2":@"Andratx",
                         @"ZoneList_Name_3":@"Portals",
                         @"Classification_code_1":@"01",
                         @"Classification_code_2":@"02",
                         @"Classification_1":@"class1",
                         @"Classification_2":@"class2"
                         };
    _jsonObject =@{@"HotelListRQ":@{
                           @"@echoToken":@"$echoToken$",
                           @"@xmlns":@"$xmlns$",
                           @"@xmlns:xsi":@"$xmlns:xsi$",
                           @"@xsi:schemaLocation":@"$xsi:schemaLocation$",
                           @"Language":@"$Language$",
                           @"Credentials":@{
                                   @"User":@"$Credentials_User$",
                                   @"Password":@"$Credentials_Password$"
                                   },
                           @"Destination":@{
                                   @"@code":@"$Destination_code$",
                                   @"@type":@"$Destination_type$",
                                   @"Name":@"$Destination_Name$",
                                   @"#value":@"$Destination$"
                                   },
                           @"ZoneList":@[@{@"zone":@[@{@"@code":@"$ZoneList_code_1$",
                                                       @"Name":@"$ZoneList_Name_1$"},
                                                     @{@"@code":@"$ZoneList_code_2$",
                                                       @"Name":@"$ZoneList_Name_2$"},
                                                     @{@"@code":@"$ZoneList_code_3$",
                                                       @"Name":@"$ZoneList_Name_3$"}
                                                     ]
                                           }
                                   ],
                           @"#list":@[@{@"Classification":@[@{@"code":@"$Classification_code_1$",
                                                              @"#value":@"$Classification_1$"},
                                                            @{@"code":@"$Classification_code_2$",
                                                              @"#value":@"$Classification_2$"},
                                                            ]
                                        }
                                      ]
                           }
                   };
}

-(void)tearDown {
    //Tear-down code here.
    [super tearDown];
}

-(void)testJsonXmlConversion {
    NSString *jsonString = [_jsonObject toJsonString];
    TuiParametrizedXml *paramxml = [[TuiParametrizedXml alloc] initWithJsonString:jsonString];
    [paramxml addKeysAndValuesFromDictionary:_paramDictionary];
    NSString *xmlstring = [paramxml getXmlString];
    NSLog(@"created xml: %@", xmlstring);
    for (NSString *key in _jsonObject) {
        [self checkNodeWithKey:key value:_jsonObject[key] xmlString:xmlstring andParamDictionary:_paramDictionary];
        
    }
    
}

-(void)checkNodeWithKey:(NSString *)key
                  value:(id)value
              xmlString:(NSString *)xmlString
     andParamDictionary:(NSDictionary *)paramDictionary {
    if ([key hasPrefix:@"@"]) {
        STAssertTrue([xmlString containsString:[key substringFromIndex:1]], [NSString stringWithFormat:@"attribute key %@ not present in xmlString", key]);
    } else if ([key isEqualToString:@"#value"]) {
        NSString *realValue = [self getValueForKey:(NSString *)value inParamDictionary:paramDictionary];
        if (realValue != nil)
            STAssertTrue([xmlString containsString:realValue], [NSString stringWithFormat:@"value %@ not present in xmlString", realValue]);
    } else if ([key isEqualToString:@"#list"]) {
        if (![value isKindOfClass:[NSArray class]])
            STFail(@"#list key was not followed by NSArray");
        for (NSDictionary *item in (NSArray *)value) {
            for (NSString *innerKey in item) {
                [self checkNodeWithKey:innerKey value:item[innerKey] xmlString:xmlString andParamDictionary:paramDictionary];
            }
        }
    } else {
        NSString *opening = [NSString stringWithFormat:@"<%@",key];
        NSString *closing = [NSString stringWithFormat:@"</%@>",key];
        STAssertTrue([xmlString containsString:opening], [NSString stringWithFormat:@"opening key %@ not present in xmlString", key]);
        STAssertTrue([xmlString containsString:closing], [NSString stringWithFormat:@"closing key %@ not present in xmlString", key]);
        if ([value isKindOfClass:[NSString class]]) {
            NSString *realValue = [self getValueForKey:(NSString *)value inParamDictionary:paramDictionary];
            if (realValue != nil)
                STAssertTrue([xmlString containsString:realValue], [NSString stringWithFormat:@"value %@ not present in xmlString", realValue]);
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)value) {
                for (NSString *innerKey in item) {
                    [self checkNodeWithKey:innerKey value:item[innerKey] xmlString:xmlString andParamDictionary:paramDictionary];
                }
            }
        } else { //it's a NSDictionary
            if (![value isKindOfClass:[NSDictionary class]])
                STFail(@"Wrong Value type");
            for (NSString *innerKey in (NSDictionary *)value) {
                [self checkNodeWithKey:innerKey value:value[innerKey] xmlString:xmlString andParamDictionary:paramDictionary];
            }
        }
    }
}

-(NSString *) getValueForKey:(NSString *)key
           inParamDictionary:(NSDictionary *)paramDictionary {
    NSString *realKey = [key substringWithRange:NSMakeRange(1, [key length]-2)];
    return [paramDictionary valueForKey:realKey];
}



@end

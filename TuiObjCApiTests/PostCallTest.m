//
//  PostCallTest.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/25/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "PostCallTest.h"
#import "TuiUrlReader.h"

@implementation PostCallTest

-(void)setUp {
    [super setUp];
    //Set up code here.
}

-(void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

-(void)testQuery {
    NSString *url = @"http://54.246.80.107/api/test_post.php?field1=test1&field2=test2";
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url withMethod:@"POST"];
    //NSData *response = [[TuiUrlReader sharedInstance] readPostFromUrl:baseurl withBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *responsestring = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Response from Atlas: %@", responsestring);
}

@end

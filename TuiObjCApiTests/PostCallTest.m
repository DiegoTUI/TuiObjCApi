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
    TuiParametrizedUrl *url = [[TuiParametrizedUrl alloc] initWithUrl:@"http://54.246.80.107/api/test_post.php?field1=$field1$&field2=$field2$"];
    [url addValue:@"test1" forKey:@"field1"];
    [url addValue:@"test2" forKey:@"field2"];
    [url setPost:YES];
    NSData *response = [[TuiUrlReader sharedInstance] readFromUrl:url];
    //NSData *response = [[TuiUrlReader sharedInstance] readPostFromUrl:baseurl withBody:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *responsestring = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"Response from Atlas: %@", responsestring);
}

@end

//
//  TuiHttpRequest.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class with static methods to manage synchronous HTTP requests
 * @author diego
 */

@interface TuiHttpRequest : NSObject

/**
 * Sends a synchronous HTTP GET request
 * @param url the URL to call.
 * @return the data returned by the query.
 */
+(NSData *)synchronousGetRequestWithURL:(NSString *)url;

/**
 * Sends a synchronous HTTP POST request
 * @param url the URL to call.
 * @return the data returned by the query.
 */
+(NSData *)synchronousPostRequestWithURL:(NSString *)url;

@end

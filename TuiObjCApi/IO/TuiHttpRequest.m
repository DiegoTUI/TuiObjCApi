//
//  TuiHttpRequest.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiHttpRequest.h"

#pragma mark - Private interface
@interface TuiHttpRequest ()

/**
 * Process the HTTP status code returned by a query
 * @param StatusCode the status code returned by the query.
 * @param url the url that returned the status code.
 * @throws TuiUnauthorizedException.
 * @throws TuiInvalidUrlException.
 */
+(void)proccessHTTPStatusCode:(NSInteger)statusCode
                         inURL:(NSString *)url;

/**
 * Process the HTTP error returned by a query
 * @param error the error returned by the query.
 * @param url the url that returned the status code.
 * @throws TuiOfflineException.
 * @throws TuiUrlConnectionException.
 */
+(void)proccessHTTPError:(NSError *)error
                    inURL:(NSString *)url;


@end

#pragma mark - Implementation
@implementation TuiHttpRequest

#pragma mark - Public methods
+(NSData *)synchronousGetRequestWithURL:(NSString *)url
{
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *urlrequest = [NSURLRequest requestWithURL:nsurl];
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:&response error:&error];
    
    [TuiHttpRequest proccessHTTPError:error inURL:url];
    [TuiHttpRequest proccessHTTPStatusCode:[response statusCode] inURL:url];
    
    return result;
}

+(NSData *)synchronousPostRequestWithURL:(NSString *)url
{
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:nsurl];
    
    [urlrequest setHTTPMethod:@"POST"];
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:&response error:&error];
    
    [TuiHttpRequest proccessHTTPError:error inURL:url];
    [TuiHttpRequest proccessHTTPStatusCode:[response statusCode] inURL:url];
    
    return result;
}

#pragma mark - Private methods
+(void)proccessHTTPStatusCode:(NSInteger)statusCode
                         inURL:(NSString *)url;
{
    if (statusCode!= 200)
    {
        if (statusCode == 401)
            @throw [NSException exceptionWithName:@"TuiUnauthorizedException" reason:@"Invalid user data" userInfo:nil];
        
        @throw [NSException exceptionWithName:@"TuiInvalidUrlException" reason:[NSString stringWithFormat:@"%@ on url:%@",[NSHTTPURLResponse localizedStringForStatusCode:statusCode],url] userInfo:nil];
    }
}

+(void)proccessHTTPError:(NSError *)error
                    inURL:(NSString *)url
{
    if (error != nil)
    {
        if ([error code] == -1009) //Offline error
            @throw [NSException exceptionWithName:@"TuiOfflineException" reason:@"No connection" userInfo:[error userInfo]];
        
        @throw [NSException exceptionWithName:@"TuiUrlConnectionException" reason:[NSString stringWithFormat:@"Error while connecting to url: %@ with code: %d and description: %@",url,[error code],[error localizedDescription]] userInfo:[error userInfo]];
    }
    
}

@end

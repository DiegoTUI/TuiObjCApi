//
//  TuiUrlReader.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/23/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to read URLs. 
 * Retries the connection 3 times if offline.
 * @author diego
 */
@interface TuiUrlReader : NSObject

//A property to control offline connections
@property (nonatomic) BOOL offline;
//A property to simulate offline connections
@property (nonatomic) BOOL testOffline;

/**
 * Returns a unique instance of the URL manager. 
 * @return a singleton.
 */
+(TuiUrlReader *)sharedInstance;

/**
 * Connect to a given URL with a certain method. Return the data. No body is included for POST calls.
 * @param url the URL to read
 * @param method GET or POST
 * @return the data.
 * @throws TuiOfflineException
 */
-(NSData *)readFromUrl:(NSString *)url
            withMethod:(NSString *)method;

@end

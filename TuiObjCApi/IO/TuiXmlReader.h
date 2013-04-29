//
//  TuiXmlReader.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/29/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to read and parse XMLs.
 * Uses xml strings as input. Outputs NSDictionaries
 * Relies on RaptureXml for xml parsing - https://github.com/ZaBlanc/RaptureXML
 * @author diego
 */
@interface TuiXmlReader : NSObject

/**
 * Returns a unique instance of the JSON reader.
 * @return a singleton.
 */
+(TuiXmlReader *)sharedInstance;

@end

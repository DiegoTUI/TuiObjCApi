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

/**
 * Reads an xml looking for a tag and produces a JSON array out of it.
 * Takes an xml string as input and produces the JSON array of "key" object according to a "description map".
 * More info about the format of the description map in the TuiXmlReaderTests
 * @param xmlString the xml string
 * @param key the object to look for in the xml string (e.g. "Hotel")
 * @param descriptionMap the map describing wich fields should be read from the xml
 * @return a JSON object or a JSON array with the contents of the xml as specified by de description map.
 * @throws TuiInvalidDescriptionMapException
 */
-(id)readObjectsFromXmlString:(NSString *)xmlString
                               lookingFor:(NSString *)key
                      usingDescriptionMap:(NSArray *)descriptionMap;

@end

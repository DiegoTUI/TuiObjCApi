//
//  TuiParametrizedUrl.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/26/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A URL with a set of parameters to access it.
 * Usually converted to GET parameters: key1=value&key2=value&...
 * @author diego
 */
@interface TuiParametrizedUrl : NSObject

/**
 * Inits the base url and creates an empty set of parameters
 * @param url the url with the $parameters$ in it.
 * @return self.
 */
-(TuiParametrizedUrl *)initWithUrl:(NSString *)url;

/**
 * Add a new parameter, key=value.
 * @param key the key for the parameter.
 * @param value the value of the parameter.
 * @return this object.
 */
-(TuiParametrizedUrl *)addValue:(NSString *)value forKey:(NSString*)key;

/**
 * Add the parameters contained in a dictionary.
 * @param dictionary the source for key-value pairs.
 * @return this object.
 */
-(TuiParametrizedUrl *)addKeysAndValuesFromDictionary:(NSDictionary *)dictionary;

/**
 * Set the query method of the url.
 * @param post true if the url has to be called through POST.
 */
-(void)setPost:(BOOL)post;

/**
 * Decide if the URL should be sent using the POST method, or the default GET.
 * @return true if it was set to post.
 */
-(BOOL)isPost;

/**
 * Obtain the raw URL for a GET or POST request.
 * Replace all keys as $key$ with the values supplied in the map. For
 * example, if the URL is http://localhost/$pepito$.dot and the map contains
 * the pair pepito->juanito, the result will be
 * http://localhost/juanito.dot.
 * @return the resulting URL.
 */
-(NSString *)getRawURL;

/**
 * Gets the base string for the parametrized Xml
 * ONLY FOR TESTS PURPOSES
 * @return base string.
 */
-(NSString *)getBaseString;

@end

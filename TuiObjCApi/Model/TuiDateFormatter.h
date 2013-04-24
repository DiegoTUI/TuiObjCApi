//
//  TuiDateFormatter.h
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A class to manage dates
 * @author diego
 */
@interface TuiDateFormatter : NSObject
/**
 * Returns a unique instance of the Date Formatter.
 * @return a singleton.
 */
+(TuiDateFormatter *)sharedInstance;

/**
 * Parse a date into a NSDate.
 * @param date as yyyy-mm-dd.
 * @return a NSDate object set to the date.
 */
-(NSDate *)parseDateFromString:(NSString *)date;

/**
 * Format a NSDate date as a string.
 * @param NSDate object set to the date.
 * @return as yyyy-mm-dd, or null if calendar is null.
 */
-(NSString *)formatStringFromDate:(NSDate *)nsdate;

/**
 * Parse a date into a calendar.
 * @param NSDate as yyyy-mm-dd.
 * @return a calendar object set to the date.
 */
-(NSDate *)parseDateFromISO8601String:(NSString *)date;

/**
 * Format a date as an ISO-8601 string.
 * @param NSDate object set to the date.
 * @return an ISO-8601 date string, or null if calendar is null.
 */
-(NSString *)formatISO8601StringFromDate:(NSDate *)nsdate;

/**
 * Find out if the given NSDate dates convert to the same day.
 * @param first NSDate set to the first date.
 * @param second NSDate set to the second date.
 * @return true if both resolve to the same yyyy-mm-dd date.
 */
-(BOOL)isDate:(NSDate *)date1
      equalTo:(NSDate *)date2;

/**
 * Returns the short date ("April 20, 2011") from a date in format yyyy-MM-dd
 * It doesn't print the year if it is the same as the current year
 * @param date date in format yyyy-MM-dd.
 * @return a short date ("April 20, 2011").
 */
-(NSString *)getShortDateFromString:(NSString *)date;

/**
 * Returns the long date ("Monday, April 20, 2011") from a date in format yyyy-MM-dd
 * It doesn't print the year if it is the same as the current year
 * @param date date in format yyyy-MM-dd.
 * @return a short date ("April 20, 2011").
 */
-(NSString *)getLongDateFromString:(NSString *)date;

/**
 * Get current calendar
 */
-(NSCalendar *)getCalendar;

/**
 * Get current zCalendar
 */
-(NSCalendar *)getZCalendar;

@end

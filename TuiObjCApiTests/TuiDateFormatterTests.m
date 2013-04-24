//
//  TuiDateFormatterTests.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiDateFormatterTests.h"
#import "TuiDateFormatter.h"

@implementation TuiDateFormatterTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/**
 * Test dates
 */
-(void)testDates
{
    //test first from nsdate to string
    NSDateComponents *datecomponents = [[NSDateComponents alloc] init];
    datecomponents.hour = 17;
    datecomponents.day = 5;
    datecomponents.month = 6;
    datecomponents.year = 1992;
    
    NSDate *nsdate = [[[TuiDateFormatter sharedInstance] getZCalendar] dateFromComponents:datecomponents]; //1992-06-05 17:00
    
    NSString *date = [[TuiDateFormatter sharedInstance] formatStringFromDate:nsdate];
    NSString *isodate = [[TuiDateFormatter sharedInstance] formatISO8601StringFromDate:nsdate];
    
    STAssertTrue([date isEqualToString:@"1992-06-05"],@"Regular date calculated is wrong");
    STAssertTrue([isodate rangeOfString:@"1992-06-05T17:00:00"].location != NSNotFound,@"ISO date calculated is wrong");
    STAssertTrue([isodate rangeOfString:@"GMT"].location != NSNotFound,@"ISO date calculated is using wrong timezone (other than GMT)");
    
    NSString *shortdate = [[TuiDateFormatter sharedInstance] getShortDateFromString:date];
    NSString *longdate = [[TuiDateFormatter sharedInstance] getLongDateFromString:date];
    
    STAssertTrue([shortdate isEqualToString:@"June 5, 1992"],@"Short date calculated is wrong");
    STAssertTrue([longdate isEqualToString:@"Friday, June 5, 1992"],@"Long date calculated is wrong");
    
    //now try with current date. The year should not be printed
    NSString *currentdate = [[TuiDateFormatter sharedInstance] formatStringFromDate:[NSDate date]];
    NSString *currentyear = [currentdate substringToIndex:4];
    
    shortdate = [[TuiDateFormatter sharedInstance] getShortDateFromString:currentdate];
    longdate = [[TuiDateFormatter sharedInstance] getLongDateFromString:currentdate];
    
    STAssertTrue([shortdate rangeOfString:currentyear].location == NSNotFound,@"Short date calculated for today is wrong");
    STAssertTrue([longdate rangeOfString:currentyear].location == NSNotFound,@"Long date calculated for today is wrong");
    
    //reverse the process
    nsdate = [[TuiDateFormatter sharedInstance] parseDateFromString:date];
    datecomponents = [[[TuiDateFormatter sharedInstance] getZCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:nsdate];
    STAssertTrue(datecomponents.year == 1992, @"Wrong year in datecomponents");
    STAssertTrue(datecomponents.month == 6, @"Wrong month in datecomponents");
    STAssertTrue(datecomponents.day == 5, @"Wrong day in datecomponents");
    STAssertTrue(datecomponents.hour == 0, @"Wrong hour in datecomponents");
    STAssertTrue(datecomponents.minute == 0, @"Wrong minute in datecomponents");
    STAssertTrue(datecomponents.second == 0, @"Wrong second in datecomponents");
    
    nsdate = [[TuiDateFormatter sharedInstance] parseDateFromISO8601String:isodate];
    datecomponents = [[[TuiDateFormatter sharedInstance] getZCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:nsdate];
    STAssertTrue(datecomponents.year == 1992, @"Wrong year in datecomponents");
    STAssertTrue(datecomponents.month == 6, @"Wrong month in datecomponents");
    STAssertTrue(datecomponents.day == 5, @"Wrong day in datecomponents");
    STAssertTrue(datecomponents.hour == 17, @"Wrong hour in datecomponents");
    STAssertTrue(datecomponents.minute == 0, @"Wrong minute in datecomponents");
    STAssertTrue(datecomponents.second == 0, @"Wrong second in datecomponents");
}

@end

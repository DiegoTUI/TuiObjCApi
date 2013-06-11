//
//  TuiDateFormatter.m
//  TuiObjCApi
//
//  Created by Diego Lafuente on 4/24/13.
//  Copyright (c) 2013 Tui Travel A&D. All rights reserved.
//

#import "TuiDateFormatter.h"

#pragma mark - Private interface
@interface TuiDateFormatter ()

@property (strong,nonatomic) NSDateFormatter *dateFormat;
@property (strong,nonatomic) NSDateFormatter *isoFormat;
@property (strong,nonatomic) NSCalendar *zCalendar;
@property (strong,nonatomic) NSCalendar *calendar;

@end

#pragma mark - Implementation
@implementation TuiDateFormatter
#pragma mark - Public methods
+(TuiDateFormatter *)sharedInstance
{
    static TuiDateFormatter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TuiDateFormatter alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSDate *)parseDateFromString:(NSString *)date
{
    if (date == nil || date.length != 10)
    {
        @throw [NSException exceptionWithName:@"TuiInvalidDateException" reason:@"Invalid date. It should be yyyy-mm-dd" userInfo:nil];
    }
    
    NSDate *nsdate = [self.dateFormat dateFromString:date];
    return nsdate;
}

-(NSString *)formatStringFromDate:(NSDate *)nsdate
{
    if (nsdate == nil)
        return nil;
    
    return [self.dateFormat stringFromDate:nsdate];
}

-(NSDate *)parseDateFromISO8601String:(NSString *)date
{
    if (date == nil)
    {
        @throw [NSException exceptionWithName:@"TuiInvalidDateException" reason:@"Invalid date. It is null" userInfo:nil];
    }
    
    NSDate *nsdate = [self.isoFormat dateFromString:[date stringByReplacingOccurrencesOfString:@"+00:00" withString:@"+0000"]];
    return nsdate;
}

-(NSString *)formatISO8601StringFromDate:(NSDate *)nsdate
{
    if (nsdate == nil)
        return nil;
    
    return [self.isoFormat stringFromDate:nsdate];
}

-(BOOL)isDate:(NSDate *)date1
      equalTo:(NSDate *)date2
{
    return [[self formatStringFromDate:date1] isEqualToString:[self formatStringFromDate:date2]];
}

-(NSString *)getShortDateFromString:(NSString *)date
{
    if (date == nil || date.length != 10)
    {
        @throw [NSException exceptionWithName:@"TuiInvalidDateException" reason:@"Invalid date. It should be yyyy-mm-dd" userInfo:nil];
    }
    
    NSInteger year = [[date substringToIndex:4] intValue];
    NSInteger month = [[date substringWithRange:NSMakeRange(5, 2)] intValue];
    NSInteger day = [[date substringFromIndex:8] intValue];
    
    NSInteger currentyear = [[[self calendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
    
    NSString *shortdate = [NSString stringWithFormat:@"%@ %d", [[[self dateFormat] monthSymbols] objectAtIndex:(month -1)], day];
    
    //add the year if needed
    if (year != currentyear)
        shortdate = [NSString stringWithFormat:@"%@, %d", shortdate, year];
    
    return shortdate;
}

-(NSString *)getLongDateFromString:(NSString *)date
{
    if (date == nil || date.length != 10)
    {
        @throw [NSException exceptionWithName:@"TuiInvalidDateException" reason:@"Invalid date. It should be yyyy-mm-dd" userInfo:nil];
    }
    
    NSInteger year = [[date substringToIndex:4] intValue];
    NSInteger month = [[date substringWithRange:NSMakeRange(5, 2)] intValue];
    NSInteger day = [[date substringFromIndex:8] intValue];
    
    NSInteger currentyear = [[[self calendar] components:NSYearCalendarUnit fromDate:[NSDate date]] year];
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat:@"EEEE"];
    
    NSString *longdate = [NSString stringWithFormat:@"%@, %@ %d",[weekday stringFromDate:[self.dateFormat dateFromString:date]], [[[self dateFormat] monthSymbols] objectAtIndex:(month -1)], day];
    
    //add the year if needed
    if (year != currentyear)
        longdate = [NSString stringWithFormat:@"%@, %d", longdate, year];
    
    return longdate;
}

-(NSCalendar *)getCalendar
{
    return self.calendar;
}

-(NSCalendar *)getZCalendar
{
    return self.zCalendar;
}

#pragma mark - NSObject methods
-(TuiDateFormatter *)init
{
    self = [super init];
    
    if (self)
    {
        _dateFormat = [[NSDateFormatter alloc] init];
        _isoFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy-MM-dd"];
        [_isoFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssV"];
        [_dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [_isoFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        _calendar = [NSCalendar currentCalendar];
        _zCalendar = [NSCalendar currentCalendar];
        [_zCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return self;
}

@end

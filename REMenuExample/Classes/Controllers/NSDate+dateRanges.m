//
//  NSDate+dateRanges.m
//  dateRanges
//
//  Created by John Nye on 27/01/2013.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "NSDate+dateRanges.h"

@implementation NSDate (dateRanges)

#pragma mark current ranges
-(NSDate*)startOfDay
{
    return [self startOfDayWithOffset:0];
}

-(NSDate*)endOfDay
{
    return [self endOfDayWithOffset:0];
}

-(NSDate*)startOfThisWeek
{
    return [self startOfWeekWithOffset:0];
}

-(NSDate*)endOfThisWeek
{
    return [self endOfWeekWithOffset:0];
}

-(NSDate*)startOfThisMonth
{
    return [self startOfMonthWithOffset:0];
}

-(NSDate*)endOfThisMonth
{
    return [self endOfMonthWithOffset:0];
}

-(NSDate*)startOfThisYear
{
    return [self startOfYearWithOffset:0];
}
-(NSDate*)endOfThisYear
{
    return [self endOfYearWithOffset:0];
}



#pragma mark past ranges
-(NSDate*)startOfDayBefore
{
    return [self startOfDayWithOffset:-1];
}

-(NSDate*)endOfDayBefore
{
    return [self endOfDayWithOffset:-1];
}


-(NSDate*)startOfWeekBefore
{
    return [self startOfWeekWithOffset:-1];
}

-(NSDate*)endOfWeekBefore
{
    return [self endOfWeekWithOffset:-1];
}

-(NSDate*)startOfMonthBefore
{
    return [self startOfMonthWithOffset:-1];
}

-(NSDate*)endOfMonthBefore
{
    return [self endOfMonthWithOffset:-1];
}

-(NSDate*)startOfYearBefore
{
    return [self startOfYearWithOffset:-1];
}

-(NSDate*)endOfYearBefore
{
    return [self endOfYearWithOffset:-1];
}


#pragma Mark future ranges
-(NSDate*)startOfNextDay
{
    return [self startOfDayWithOffset:1];
}

-(NSDate*)endOfNextDay
{
    return [self endOfDayWithOffset:1];
}

-(NSDate*)startOfNextWeek
{
    return [self startOfWeekWithOffset:1];
}

-(NSDate*)endOfNextWeek
{
    return [self endOfWeekWithOffset:1];
}

-(NSDate*)startOfNextMonth
{
    return [self startOfMonthWithOffset:1];
}

-(NSDate*)endOfNextMonth
{
    return [self endOfMonthWithOffset:1];
}

-(NSDate*)startOfNextYear
{
    return [self startOfYearWithOffset:1];
}

-(NSDate*)endOfNextYear
{
    return [self endOfYearWithOffset:1];
}

#pragma mark Any Range
-(NSDate*)startOfDayWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSDayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: ([weekdayComponents weekday]+offset)];
    NSDate *startofDayDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: startofDayDate];
    return [gregorian dateFromComponents: components];

}

-(NSDate*)endOfDayWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSDayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay: ([weekdayComponents weekday]+offset)];
    NSDate *endofDayDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: endofDayDate];
    return [[gregorian dateFromComponents: components] dateByAddingTimeInterval:86399.9];
}

-(NSDate*)startOfWeekWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setWeekday:([gregorian firstWeekday])];
    
    NSDate *endOfWeekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: endOfWeekDate];
    
    return [[gregorian dateFromComponents: components] dateByAddingTimeInterval:((604800*offset)-86400)];
}

-(NSDate*)endOfWeekWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setWeekday:(-1+[gregorian firstWeekday])];
    
    NSDate *endOfWeekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: endOfWeekDate];
    
    return [[gregorian dateFromComponents: components] dateByAddingTimeInterval:(604800*(offset+1))-0.1];
}

-(NSDate*)startOfMonthWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    NSDate *startOfMonthDate = nil;
    NSDateComponents *components = nil;
    
    [componentsToSubtract setMonth: offset];
    startOfMonthDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit) fromDate: startOfMonthDate];
    
    return [gregorian dateFromComponents: components];
}

-(NSDate*)endOfMonthWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    NSDateComponents *components = nil;
    NSDate *endOfMonthDate = nil;
    
    [componentsToSubtract setMonth: (offset+1)];
    endOfMonthDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit) fromDate: endOfMonthDate];
    
    return [[gregorian dateFromComponents: components] dateByAddingTimeInterval:-0.1];
}

-(NSDate*)startOfYearWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *yearComponents = [gregorian components:NSYearCalendarUnit fromDate:self];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setYear: ([yearComponents month]+offset)];
    [componentsToSubtract setMonth:0];
    [componentsToSubtract setDay:0];
    NSDate *startOfYearDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit) fromDate: startOfYearDate];
    
    return [gregorian dateFromComponents: components];
}

-(NSDate*)endOfYearWithOffset:(int)offset
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *yearComponents = [gregorian components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setYear: ([yearComponents month]+offset+1)];
    NSDate *endOfYearDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit) fromDate: endOfYearDate];
    
    return [[gregorian dateFromComponents: components] dateByAddingTimeInterval:-0.1];
}

@end
//
//  NSDate+Additions.m
//  AcuCom
//
//  Created by wfs-aculearn on 14-4-2.
//  Copyright (c) 2014年 aculearn. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSString *)stringForRecentDate:(NSDate *)recentDate
{   // 规则：
    // 0当天则只显示时间: NSDateFormatterShortStyle    下午4:52
    // 1昨天
    // 2星期 （只显示最近四天的）
    // 3超过的则显示 NSDateFormatterShortStyle 11-9-17
    
    //[d timeIntervalSinceNow];
    NSString *result = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // NSDateFormatterShortStyle    下午4:52
    // kCFDateFormatterMediumStyle  下午4:53:23
    // kCFDateFormatterLongStyle    格林尼治标准时间+0800下午4时55分03秒
    // kCFDateFormatterFullStyle    中国标准时间下午4时55分43秒
    //[dateFormatter setTimeStyle:kCFDateFormatterFullStyle];
    // NSDateFormatterShortStyle 11-9-17
    // NSDateFormatterMediumStyle 2012-06-17
    // NSDateFormatterLongStyle 2011年9月17日
    // NSDateFormatterFullStyle 2011年9月17日星期六
    //[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    // 注意与语言不是一码事，指的是区域设置
    NSLocale *curLocale = [NSLocale currentLocale];
    [dateFormatter setLocale:curLocale];// 设置为当前区域
    
    NSInteger days = [NSDate daysBetweenDate:recentDate andDate:[NSDate date]];
    if (days >= 0 && days < 31) {
        if (days == 0) {
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *comps  = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:recentDate];
//            NSInteger hour = [comps hour];
//            NSInteger min = [comps minute];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"mm:ss"];
//            NSString *dateTime = [formatter stringFromDate:[NSDate date]];
//            result = [NSString stringWithFormat:@"%02d:%02d",(int)hour,(int)min];
            NSDateFormatter *date=[[NSDateFormatter alloc] init];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSTimeInterval late=[recentDate timeIntervalSince1970]*1;
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval now=[dat timeIntervalSince1970]*1;
            NSString *timeString=@"";
            
            NSTimeInterval cha=now-late;
            
            if (cha/3600<1) {
                timeString = [NSString stringWithFormat:@"%f", cha/60+1];
                timeString = [timeString substringToIndex:timeString.length-7];
                timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
                result = timeString;
            }
            if (cha/3600>1&&cha/86400<1) {
                timeString = [NSString stringWithFormat:@"%f", cha/3600];
                timeString = [timeString substringToIndex:timeString.length-7];
                timeString=[NSString stringWithFormat:@"%@小时前", timeString];
                result = timeString;
            }
        }
        else
        {
            switch (days) {
                case 1:
                    result = NSLocalizedString(@"一天前", nil);
                    break;
                   case 2:
                    result = NSLocalizedString(@"二天前", nil);
                    break;
                case 3:
                    result = NSLocalizedString(@"三天前", nil);
                    break;
                case 4:
                    result = NSLocalizedString(@"四天前", nil);
                    break;
                case 5:
                    result = NSLocalizedString(@"五天前", nil);
                    break;
                case 6:
                    result = NSLocalizedString(@"六天前", nil);
                    break;
                case 7:
                    result = NSLocalizedString(@"七天前", nil);
                    break;
                case 8:
                    result = NSLocalizedString(@"八天前", nil);
                    break;
                case 9:
                    result = NSLocalizedString(@"九天前", nil);
                    break;
                case 10:
                    result = NSLocalizedString(@"十天前", nil);
                    break;
                case 11:
                    result = NSLocalizedString(@"十一天前", nil);
                    break;
                case 12:
                    result = NSLocalizedString(@"十二天前", nil);
                    break;
                case 13:
                    result = NSLocalizedString(@"十三天前", nil);
                    break;
                case 14:
                    result = NSLocalizedString(@"十四天前", nil);
                    break;
                case 15:
                    result = NSLocalizedString(@"十五天前", nil);
                    break;
                case 16:
                    result = NSLocalizedString(@"十六天前", nil);
                    break;
                case 17:
                    result = NSLocalizedString(@"十七天前", nil);
                    break;
                case 18:
                    result = NSLocalizedString(@"十八天前", nil);
                    break;
                case 19:
                    result = NSLocalizedString(@"十九天前", nil);
                    break;
                case 20:
                    result = NSLocalizedString(@"二十天前", nil);
                    break;
                case 21:
                    result = NSLocalizedString(@"二十一天前", nil);
                    break;
                case 22:
                    result = NSLocalizedString(@"二十二天前", nil);
                    break;
                case 23:
                    result = NSLocalizedString(@"二十三天前", nil);
                    break;
                case 24:
                    result = NSLocalizedString(@"二十四天前", nil);
                    break;
                case 25:
                    result = NSLocalizedString(@"二十五天前", nil);
                    break;
                case 26:
                    result = NSLocalizedString(@"二十六天前", nil);
                    break;
                case 27:
                    result = NSLocalizedString(@"二十七天前", nil);
                    break;
                case 28:
                    result = NSLocalizedString(@"二十八天前", nil);
                    break;
                case 29:
                    result = NSLocalizedString(@"二十九天前", nil);
                    break;
                case 30:
                    result = NSLocalizedString(@"三十天前", nil);
                    break;
                default:
                    break;
            }
        
        }
//        else if (days == 1) {
//            result = NSLocalizedString(@"一天前", nil);
//        }
//        else {
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *comps  = [calendar components:NSWeekdayCalendarUnit fromDate:recentDate];
//            NSInteger week = [comps weekday];
//            switch (week)
//            {
//                case 2:
//                {
//                    result = NSLocalizedString(@"mon",nil);
//                }
//                    break;
//                case 3:
//                {
//                    result = NSLocalizedString(@"Tue",nil);
//                }
//                    break;
//                case 4:
//                {
//                    result = NSLocalizedString(@"Wed",nil);
//                }
//                    break;
//                case 5:
//                {
//                    result = NSLocalizedString(@"Thu",nil);
//                }
//                    break;
//                case 6:
//                {
//                    result = NSLocalizedString(@"Fri",nil);
//                }
//                    break;
//                case 7:
//                {
//                    result = NSLocalizedString(@"Sat",nil);
//                }
//                    break;
//                case 1:
//                {
//                    result = NSLocalizedString(@"Sun",nil);
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            [dateFormatter setDateFormat:@"EEEE"];
//            result = [dateFormatter stringFromDate:recentDate];
//        }
  }
        else {
        result = [NSDateFormatter localizedStringFromDate:recentDate dateStyle:kCFDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
    }
    return result;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    if (fromDateTime == nil || toDateTime == nil)
    {
        return 0;
    }
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end

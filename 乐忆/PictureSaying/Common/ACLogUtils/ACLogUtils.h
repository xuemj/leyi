//
//  ACLogUtils.h
//  AcuCom
//
//  Created by wfs-aculearn on 14-3-27.
//  Copyright (c) 2014年 aculearn. All rights reserved.
//

#import <Foundation/Foundation.h>

// 使用：ITLog(@"");
//      是表达式时多对括号比较难看
//      ITLog(([NSString stringWithFormat:@"tel://%@  %d", @"021-10086", 33]));

#if defined(DEBUG)
//    #define ITLog(STRLOG)	 NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
 //   #define ITLog(STRLOG)	NSLog(@"%@ %@: %@ 行号:%d %@", [NSThread currentThread],self, NSStringFromSelector(_cmd), __LINE__, STRLOG)
//#define ITLog(STRLOG)
    //#define ITLog(STRLOG)	if (STRLOG) { NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG); } else { NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));}
#else
    #if TARGET_IPHONE_SIMULATOR
        // 模拟器中仍然显示日志
        //#define ITLog(STRLOG)	NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
        #define ITLog(STRLOG)
    #else
        // release版本目前也增加日志吧,正式发部时再决定是否去掉
        #define ITLog(STRLOG) 
//        #define ITLog(STRLOG)	NSLog(@"%@: %@ %@", self, NSStringFromSelector(_cmd), STRLOG)
//#define ITLog(STRLOG)
    #endif
#endif


#ifdef DEBUG
#define ITLogEX(format, ...) //NSLog(format, ## __VA_ARGS__)
#else
#define ITLogEX(format, ...)
#endif

#define ITAlertView(AlertMessage) [[[UIAlertView alloc] initWithTitle:kAlertTitle message:AlertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]


// 支持线程安全的基础日志类

/** 大概耗时统计使用示例代码：
 unsigned long tagId = [[ITLogUtils shareLog] beginTag:@"contactPersonListLoaded sort"];
 ... Other code ...
 [[ITLogUtils shareLog] endTag:tagId isShowLog:YES];
 由于Objective-C完全基于消息，消息发送的速度不一致所以得到的时间不是很精确的只能做为优化的参考
 */

@interface ACLogUtils : NSObject {
@private
    NSMutableArray *_tagList;
    unsigned long geneId;
    
}

+ (ACLogUtils *)shareLog;

/**
	将stderr输出重定向到文件，即默认日志NSLog输出到文件ITLog.txt和ITLogbak.txt
 */
+ (void)switchStderrToFile;

/**
 检查日志文件大小，保证不会因为日志文件过大浪费用户空间，也避免影响性能问题
 目前单个日志文件<200kb左右
 */
+ (void)checkLogFileSize;

/**
	清除所有tag
 */
- (void)clearTags;
@end



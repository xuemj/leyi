//
//  DataService.m
//  FirstPro
//
//  Created by tutu on 14/11/5.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "DataService.h"
#import "ASIHTTPRequest.h"
#import "NSString+URLEncoding.h"
#import "PSConfigs.h"
#import "AppDelegate.h"

@implementation DataService

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block1:(CompletionLoadHandle)block failLoad:(FailedLoadHandle)block1
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }

    //拼接URL
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    if (params.allKeys.count>0) {
        if ([httpMethod isEqualToString:@"GET"]) {
            //如果说是GET请求，则将参数拼接到URL后面
            [url appendString:@"?"];
            NSArray *allkeys = [params allKeys];
            for (int  i = 0; i < allkeys.count; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                //如果是中文，需要url编码
                //value = [value URLEncodedString];
                
                [url appendFormat:@"%@=%@",key,value];
                if (i < allkeys.count - 1) {
                    [url appendString:@"&"];
                }
            }
        }
    }
    //判断、处理请求方式:GET/POST

    //创建request请求对象
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:15];

    //判断是否是POST请求
    if ([httpMethod isEqualToString:@"POST"]) {
        for (NSString *key in params) {
            id value = [params objectForKey:key];
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            }else
            {
                [request addPostValue:value forKey:key];
            }
        }
    }

    //数据返回的处理
    [request setCompletionBlock:^{
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];

    //请求失败的处理
    [request setFailedBlock:^{
        block1(request.error);
        //do something
       
        
    }];

   //发送异步请求
    [request startAsynchronous];

    return request;
}

+ (ASIHTTPRequest *)rrequestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                            block1:(CompletionLoadHandle)block
                           failLoad:(FailedLoadHandle)block1
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //拼接URL
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    if (params.allKeys.count>0) {
        if ([httpMethod isEqualToString:@"GET"]) {
            //如果说是GET请求，则将参数拼接到URL后面
            [url appendString:@"?"];
            NSArray *allkeys = [params allKeys];
            for (int  i = 0; i < allkeys.count; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                //如果是中文，需要url编码
                //            value = [value URLEncodedString];
                
                [url appendFormat:@"%@=%@",key,value];
                if (i < allkeys.count - 1) {
                    [url appendString:@"&"];
                }
            }
        }
    }
    //判断、处理请求方式:GET/POST
    
    //创建request请求对象
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:15];
    
    //判断是否是POST请求
    if ([httpMethod isEqualToString:@"POST"]) {
        for (NSString *key in params) {
            id value = [params objectForKey:key];
            if ([key rangeOfString:@"path"].location != NSNotFound || [key rangeOfString:@"pic"].location != NSNotFound) {
                [request setFile:value forKey:key];
            }
            else{
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    //数据返回的处理
    [request setCompletionBlock:^{
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    //请求失败的处理
    [request setFailedBlock:^{
        if (block1 != nil) {
            block1(request.error);
        }
        
    }];
    
    //发送异步请求
    [request startAsynchronous];
    
    return request;
}


+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)urlstring
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                                     block:(CompletionLoadHandle)block
                                  failLoad:(FailedLoadHandle)block1
{
    if (params == nil)
    {
        params = [NSMutableDictionary dictionary];
    }
    
    //拼接URL
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];

    
    //创建request请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *operation = nil;
    //GET请求
    if (params.allKeys.count>0) {
        if ([httpMethod isEqualToString:@"GET"]) {
            //如果说是GET请求，则将参数拼接到URL后面
            [url appendString:@"?"];
            NSArray *allkeys = [params allKeys];
            for (int  i = 0; i < allkeys.count; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                //如果是中文，需要url编码
                //            value = [value URLEncodedString];
                
                [url appendFormat:@"%@=%@",key,value];
                if (i < allkeys.count - 1) {
                    [url appendString:@"&"];
                }
            }
        }
    }
    
    //POST请求
    if ([httpMethod isEqualToString:@"POST"]) {
        BOOL isFile = NO;
        for (NSString *key in params) {
            id value = params[key];
            //判断请求参数是否是文件数据
            if ([value isKindOfClass:[NSData class]]) {
                isFile = YES;
                break;
            }
        }
        
        if (!isFile) {
            //参数中没有文件,使用以下方法发送网络请求
            operation = [manager POST:url
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  block(responseObject);
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              }];
        }else
        {
            operation = [manager POST:url
                           parameters:params
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSString *key in params) {
                    id value = params[key];
                    if ([value isKindOfClass:[NSData class]]) {
                        [formData appendPartWithFileData:value
                                                    name:key
                                                fileName:key
                                                mimeType:@"image/jpeg"];
                    }
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                block(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block1(error);
               
             
            }];
        }
    }
    
    //设置返回数据的解析方式
    operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)urlstring
                                    params:(NSMutableDictionary *)params
                                httpMethod:(NSString *)httpMethod
                                     block:(CompletionLoad)block
                                  failLoad:(FailedLoadHandle)block1
                             requestHeader:(NSDictionary *)header
{
    //拼接URL
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@%@",@"http://192.168.1.131:8080",urlstring];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://192.168.1.131:8080",urlstring];
    NSString *url = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    //添加请求头
    for (NSString *key in header.allKeys) {
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    //get请求
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (compResult1 == NSOrderedSame) {
        [request setHTTPMethod:@"GET"];
        
        //添加参数，将参数拼接在url后面
        NSMutableString *paramsString = [NSMutableString string];
        NSArray *allkeys = [params allKeys];
        for (NSString *key in allkeys) {
            NSString *value = [params objectForKey:key];
            
            [paramsString appendFormat:@"&%@=%@", key, value];
        }
        
        if (paramsString.length > 0) {
            [paramsString replaceCharactersInRange:NSMakeRange(0, 1) withString:@"?"];
            //重新设置url
            [request setURL:[NSURL URLWithString:[url stringByAppendingString:paramsString]]];
        }
    }
    
    
    //post请求
    NSComparisonResult compResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compResult2 == NSOrderedSame) {
        [request setHTTPMethod:@"POST"];
        
        //添加参数
        for (NSString *key in params) {
            [request setHTTPBody:params[key]];
        }
    }
    NSError *error = nil;
    //发送请求
    AFHTTPRequestOperation *requstOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //设置返回数据的解析方式
    requstOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requstOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block != nil) {
            block(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        error = error;
        if (block != nil) {
            block(error);
        }
     
        
    }];
    if (error == nil) {
        [requstOperation start];
    }else{
        [requstOperation cancel];
    }
    
    return requstOperation;
}

+ (NSMutableURLRequest *)requestWithURL:(NSString *)urlstring
                                 params:(NSMutableDictionary *)params
                          requestHeader:(NSDictionary *)header
                             httpMethod:(NSString *)httpMethod
                                  block:(CompletionLoad)block
                               failLoad:(FailedLoadHandle)block1

{
    //拼接URL
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    //添加请求头
    for (NSString *key in header.allKeys) {
        NSParameterAssert(header[key]);
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    
    //get请求
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (compResult1 == NSOrderedSame) {
        [request setHTTPMethod:@"GET"];
        
        //添加参数，将参数拼接在url后面
        NSMutableString *paramsString = [NSMutableString string];
        if (params.allKeys.count > 0) {
            NSArray *allkeys = [params allKeys];
            for (NSString *key in allkeys) {
                NSString *value = [params objectForKey:key];
                [paramsString appendFormat:@"&%@=%@", key, value];
            }
            
            if (paramsString.length > 0) {
                [paramsString replaceCharactersInRange:NSMakeRange(0, 1) withString:@"?"];
                //重新设置url
                [request setURL:[NSURL URLWithString:[url stringByAppendingString:paramsString]]];
            }
        }else{
            [request setURL:[NSURL URLWithString:url]];
        }
        }
        
    
    //post请求
    NSComparisonResult compResult2 =[httpMethod caseInsensitiveCompare:@"POST"];
    if (compResult2 == NSOrderedSame) {
        [request setHTTPMethod:@"POST"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:postData];
    }
    
    //发送请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (block1 != nil) {
                block1(connectionError);
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                });
            }
        }else{
            if (block != nil) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
                block(result);
            }
        }
    }];
    
    return request;
}

+ (NSMutableURLRequest *)requestWithURL:(NSString *)urlstring
                                 params:(NSMutableArray *)params
                          requestHeader:(NSDictionary *)header
                             httpMethod:(NSString *)httpMethod
                                  block2:(CompletionLoad)block
                               failLoad:(FailedLoadHandle)block1

{
    if (params == nil) {
        params = [NSMutableArray array];
    }
    //拼接URL
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    //添加请求头
    for (NSString *key in header.allKeys) {
        NSParameterAssert(header[key]);
        [request addValue:header[key] forHTTPHeaderField:key];
    }
    //post请求
    NSComparisonResult compResult2 =[httpMethod caseInsensitiveCompare:@"POST"];
    if (compResult2 == NSOrderedSame) {
        [request setHTTPMethod:@"POST"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:postData];
    }
    
    //发送请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (block1 != nil) {
                block1(connectionError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        }else{
            if (block != nil) {
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];

                block(result);
            }
        }
    }];
    
    return request;
}
@end


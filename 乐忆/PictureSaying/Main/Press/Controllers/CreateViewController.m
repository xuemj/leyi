//
//  CreateViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/8.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  创建事件

#import "CreateViewController.h"
#import "AssetHelper.h"
#import "SelectStoryViewController.h"
#import "StoryViewController.h"
#import "UIImage+Compress.h"
#import "PSConfigs.h"
#import <ShareSDK/ShareSDK.h>
#import "UUDatePicker.h"
/*
 {
 result = 0;
 value =     {
 accountAva = "<null>";
 accountNickName = "<null>";
 accountUsn = 13521191186;
 commentNum = 0;
 exitFav = "<null>";
 favNum = 0;
 format = "<null>";
 id = 54cf14e345ce9776e5147111;
 pics = "<null>";
 sort = 11;
 storyId = 000000004b394db9014b395bae3a000c;
 tag = "<null>";
 time = 1422857429000;
 title = "\U963fKTV";
 txt = "<null>";
 valid = 1;
 writeAble = 0;
 };
 }
 */
#define CONTENT NSLocalizedString(@"我正在使用乐忆分享,很方便,你也试试吧", @"www.wetime.cn")
#import <AVFoundation/AVFoundation.h>

@interface CreateViewController ()<UITextFieldDelegate>
{
    DoImagePickerController *cont;
    BOOL _isVCBasedStatusBarAppearance;
    StoryViewController *storyVC;
    SelectStoryViewController *selectStroy;
    float tagWidth;
    float tagHeight;
    UITextField *distributeStory;
    UILabel *dateLabel;
    UIView *pickerBg;
    NSDate *selectDate;
}
@property(nonatomic, retain)UIDatePicker *dp;
@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //4.11获取用户标签：GET {userUrl}/WeiXiao/api/v1/user/userTag/{id}
    //4.13 添加用户标签：POST {userUrl}/WeiXiao/api/v1/user/userTag/add
    
    // Do any additional setup after loading the view.
    self.pictureDescs = [NSMutableDictionary dictionary];
    allTags = [NSMutableArray array];
    self.title = @"创建事件";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _taps = [NSMutableArray array];
    selectedImages = [NSMutableArray array];
    [self _initViews];
    [self _createNavItems];
 
    selectedTags = [NSMutableArray array];
    addTags = [NSMutableArray array];
   
}


-(void)createTag:(NSArray *)ta{
    for (int i = 0; i<ta.count+1; i++) {
        if (i==0) {
            UIButton *addTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addTagButton.frame = CGRectMake(10, tipTag.bottom, (tagView.width-50)/4, 25);
            [addTagButton setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
            [addTagButton addTarget:self action:@selector(Tianjia:) forControlEvents:UIControlEventTouchUpInside];
            [tagView addSubview:addTagButton];
            tagHeight = addTagButton.top;
            tagWidth = addTagButton.right;
            [allTags addObject:addTagButton];
        }else{
            UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i<4) {
                tagButton.frame = CGRectMake(10+i*((tagView.width-50)/4+10), tipTag.bottom, (tagView.width-50)/4, 25);
            }else{
                tagButton.frame = CGRectMake(10+(i-4)*((tagView.width-50)/4+10), tipTag.bottom+35, (tagView.width-50)/4, 25);
            }
            tagButton.frame = CGRectMake(10+tagWidth, tagHeight, (tagView.width-50)/4, 25);
            tagButton.tag = 1000+i;
//            tagButton.layer.cornerRadius = 4;
//            tagButton.layer.borderWidth = 1;
//            tagButton.layer.borderColor = [rgb(176, 176, 176, 1) CGColor];
            [tagButton setBackgroundImage:[UIImage imageNamed:@"tagGray"] forState:UIControlStateNormal];
            [tagButton setBackgroundImage:[UIImage imageNamed:@"tagYellow"] forState:UIControlStateSelected];
            tagButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [tagButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
            [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            tagButton.selected = YES;
            [tagButton setTitle:[ta[i-1] objectForKey:@"tag"] forState:UIControlStateNormal];
            [tagButton addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
            [tagView addSubview:tagButton];
            
            [allTags addObject:tagButton];
            if (allTags.count%4 == 0) {
                tagHeight = tagButton.top+35;
                tagWidth = 0;
            }else{
                tagHeight = tagButton.top;
                tagWidth = tagButton.right;
            }
        }
    }
}

-(void)selectTag:(UIButton *)btn{
    if (!btn.selected) {
        if (selectedTags.count<3) {
            btn.selected = YES;
            [selectedTags addObject:btn];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能添加3个标签哦~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        btn.selected = NO;
        [selectedTags removeObject:btn];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    if (storyVC.pictureDesc.length>0) {
        ;
        UIImageView *iv = (UIImageView *)[secondView viewWithTag:[storyVC.butTag integerValue]-20];
        UIButton *tempButton = (UIButton *)[iv viewWithTag:[storyVC.butTag integerValue]];
//        if (storyVC.pictureDesc.length>60) {
//            NSString *picDesc = [storyVC.pictureDesc substringWithRange:NSMakeRange(0, 50)];
//            picDesc = [NSString stringWithFormat:@"%@....",picDesc];
//            [tempButton setTitle:picDesc forState:UIControlStateNormal];
//
//        }else{
            [tempButton setTitle:storyVC.pictureDesc forState:UIControlStateNormal];
//        }
//        if ([self.pictureDescs indexOfObject:picDesc] == NSNotFound) {
//            [self.pictureDescs addObject:picDesc];
//        }
        [self.pictureDescs setObject:storyVC.pictureDesc forKey:[storyVC.butTag stringValue]];
    }
    if (selectStroy.storyName.length>0) {
        UIButton *selected = (UIButton *)[firstView viewWithTag:160];
        [selected setTitle:selectStroy.storyName forState:UIControlStateNormal];
        self.storyTitle = selectStroy.storyName;
    }else if (self.storyName.length>0) {
        UIButton *selected = (UIButton *)[firstView viewWithTag:160];
        [selected setTitle:self.storyName forState:UIControlStateNormal];
        self.storyTitle = self.storyName;
    }
}

-(void)_initViews{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    _scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight);
    [self.view addSubview:_scrollView];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:now];
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    dateLabel.text = dateString;
    [_scrollView addSubview:dateLabel];
    
    UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    crossButton.frame = CGRectMake(KScreenWidth-10-50, dateLabel.top, 50, 30);
    crossButton.backgroundColor = CommonBlue;
    crossButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [crossButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [crossButton setTitle:@"穿越" forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:crossButton];
    
    firstView = [[UIView alloc] initWithFrame:CGRectMake(10, crossButton.bottom+10, KScreenWidth-20, 88)];
    firstView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:firstView];
    [self addLineWithWidth:0 withHeight:44 toView:firstView];
    
    UIButton *selectStory = [UIButton buttonWithType:UIButtonTypeCustom];
    selectStory.frame = CGRectMake(15, 0, firstView.width-15, 44);
    selectStory.tag = 160;
    selectStory.backgroundColor = [UIColor whiteColor];
    selectStory.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [selectStory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectStory setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [selectStory setTitle:@"选择故事" forState:UIControlStateNormal];
    [selectStory addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:selectStory];
    if ([self.isAdded isEqualToString:@"storyed"]) {
        selectStory.userInteractionEnabled = NO;
    }else{
        [self addArrowWithHeight:(selectStory.height-15)/2 ToParentView:selectStory];
    }

    
    distributeStory = [[UITextField alloc] initWithFrame:CGRectMake(15, 44.5, firstView.width-15, 43.5)];
//    distributeStory.frame = CGRectMake(15, 44.5, firstView.width-15, 43.5);
    distributeStory.backgroundColor = [UIColor whiteColor];
    distributeStory.clearButtonMode = UITextFieldViewModeWhileEditing;
//    distributeStory.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [distributeStory setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
//    [distributeStory setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [distributeStory setTitle:@"对事件进行描述" forState:UIControlStateNormal];
//    [distributeStory addTarget:self action:@selector(distributeAction:) forControlEvents:UIControlEventTouchUpInside];
    distributeStory.placeholder = @"请填写故事标题(21个字以内)";
    distributeStory.delegate = self;
    distributeStory.font = [UIFont systemFontOfSize:14.0];
    distributeStory.returnKeyType = UIReturnKeyDone;
    [firstView addSubview:distributeStory];
//    [self addArrowWithHeight:(distributeStory.height-15)/2 ToParentView:distributeStory];
    
//    locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    locationButton.frame = CGRectMake(10, firstView.bottom+10, KScreenWidth-20, 44);
//    [locationButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
//    locationButton.backgroundColor = [UIColor whiteColor];
//    [_scrollView addSubview:locationButton];
//    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, locationButton.height)];
//    locationLabel.font = [UIFont systemFontOfSize:15.0];
//    locationLabel.text = @"所在位置";
//    [locationButton addSubview:locationLabel];
//    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-45, (locationButton.height-15)/2, 15, 15)];
//    arrowIV.image = [UIImage imageNamed:@"c1.png"];
//    [locationButton addSubview:arrowIV];
    
    secondView = [[UIView alloc] initWithFrame:CGRectMake(10, firstView.bottom+10, KScreenWidth-20, 0)];
    secondView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:secondView];
    
    thirdView = [[UIView alloc] initWithFrame:CGRectMake(10, secondView.bottom, KScreenWidth-20, 330)];
    thirdView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    thirdView.autoresizesSubviews = NO;
    [_scrollView addSubview:thirdView];
    
    UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
    addImage.frame = CGRectMake(0, 0, thirdView.width, 50);
    [addImage setImage:[UIImage imageNamed:@"c8"] forState:UIControlStateNormal];
    [addImage addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [thirdView addSubview:addImage];
    tagView  = [[UIView alloc]initWithFrame:CGRectMake(0, addImage.height+10, thirdView.width, 120)];
    tagView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [thirdView addSubview:tagView];
    thirdView.frame = CGRectMake(10, secondView.bottom, KScreenWidth-20, tagView.height+addImage.height+20);
    
    NSString *shareNames = @"bsina";
    NSString *shareSelectedNames = @"bsina1";
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(5,addImage.bottom+10, 45, 45);
    [but setImage:[UIImage imageNamed:shareNames] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:shareSelectedNames] forState:UIControlStateSelected];
    but.tag = 200;
    [but addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [thirdView addSubview:but];
   if (self.dp == nil) {
        pickerBg = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 216)];
        pickerBg.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pickerBg];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        NSDate *now = [NSDate date];
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
        datePicker.locale = locale;
        datePicker.backgroundColor = [UIColor whiteColor];
        [datePicker setDate:now animated:YES];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(selectedRow:) forControlEvents:UIControlEventValueChanged];
        [pickerBg addSubview:datePicker];
        self.dp = datePicker;
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(KScreenWidth-50, 0, 50, 30);
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        sureButton.backgroundColor = CommonBlue;
        [sureButton addTarget:self action:@selector(inView) forControlEvents:UIControlEventTouchUpInside];
        [pickerBg addSubview:sureButton];
    }
    selectDate = [NSDate date];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self inView];
    if ([string isEqualToString:@"\n"]) {//检测到“完成”
        [textField resignFirstResponder];//释放键盘
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 21) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:21];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(void)Tianjia:(UIButton *)butt{
    if (addTags.count<3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加标签(4字以内)" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 700;
        [alert show];
    }else{
        UIAlertView *AlitGe = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多只能自定义3个标签哦~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [AlitGe show];
        butt.enabled = NO;
    }
    
    
}

-(void)selectDate:(UIButton *)btn{
    [self popView];
}

-(void)selectedRow:(UIDatePicker *)dp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:dp.date];
    dateLabel.text = dateString;
    selectDate = dp.date;

}

- (void)popView{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    pickerBg.frame = CGRectMake(0, KScreenHeight-216-64, KScreenWidth, 216);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void)inView{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    pickerBg.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 216);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self.dp.date];
    dateLabel.text = dateString;
    selectDate = self.dp.date;

}

-(void)animationFinished{
  
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)hh:(UIButton *)btt{
    
    if (btt.selected) {
        btt.backgroundColor = [UIColor cyanColor];
        _jishu--;
    }else{
        btt.backgroundColor = [UIColor redColor];
        _jishu++;
        if (_jishu > 3 ) {
            btt.selected = !btt.selected;
            btt.backgroundColor = [UIColor cyanColor];
            UIAlertView *attt =[[UIAlertView alloc]initWithTitle:@"提示" message:@"最多三个标签哦，亲" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [attt show];
            return;
        }
        
    }
    btt.selected = !btt.selected;
   
}

-(void)diyiButton{
    
    btnnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [BiaoqianText.text sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(200, 1000)];
    btnnFirst.frame = CGRectMake(width+50, 20, size.width+20, 20);
    btnnFirst.backgroundColor = [UIColor cyanColor];
    [btnnFirst setTitleColor:[UIColor colorWithRed:1.000 green:0.002 blue:0.053 alpha:1.000] forState:UIControlStateNormal];
    btnnFirst.layer.cornerRadius = 2;
    width = width+size.width+30;
    [btnnFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnnFirst.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [btnnFirst setTitle:BiaoqianText.text forState:UIControlStateNormal];
    [btnnFirst addTarget:self action:@selector(hh:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:btnnFirst];
    
}

-(void)_createNavItems{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 48, 44);
//    //        leftBtn.backgroundColor = [UIColor orangeColor];
//    leftBtn.showsTouchWhenHighlighted = YES;
//    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    rightButton.showsTouchWhenHighlighted = YES;
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)rightAction:(UIButton *)btn{
    if (netStatus != 0) {
        eventDesc = distributeStory.text;
        if (selectedImages.count>0&&self.storyTitle.length>0&&eventDesc.length>0) {
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            long long timeInterval = (long long)[selectDate timeIntervalSince1970]*1000;
            NSNumber *time = [NSNumber numberWithLongLong:timeInterval];
            [param setObject:time forKey:@"time"];
            [param setObject:eventDesc forKey:@"title"];
            [param setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
            NSString *urll;
            if (selectStroy.storyDic != nil) {
                urll = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/itemf/",[selectStroy.storyDic objectForKey:@"id"]];
            }else{
                urll = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/itemf/",[self.storyDic objectForKey:@"id"]];
            }
            [self showHud:@"正在发布,请稍等..."];
            [DataService rrequestWithURL:urll params:param httpMethod:@"POST" block1:^(id result) {
                NSDictionary *resultDic = (NSDictionary *)result;
                if ([[resultDic objectForKey:@"result"] isEqual:@0]) {
                    [self postImages:[resultDic objectForKey:@"value"]];
                    UIButton *shareBtn = (UIButton*)[self.view viewWithTag:1000];
                    if (shareBtn.selected) {
                        NSString *savename = [NSString stringWithFormat:@"Documents/eventPic%d.jpg",1];
                        
                        //Create paths to output images
                        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:savename];
                        NSString *url = [NSString stringWithFormat:@"http://share.wetime.cn/index.html?itemId=%@&",[[resultDic objectForKey:@"value"] objectForKey:@"id"]];
                        NSString *content = [NSString stringWithFormat:@"%@%@",eventDesc,url];
                        id<ISSContent> publishContent = [ShareSDK content:content
                                                           defaultContent:@"分享"
                                                                    image:[ShareSDK imageWithPath:jpgPath]
                                                                    title:eventDesc
                                                                      url:@"https://api.weibo.com/oauth2/default.html"
                                                              description:NSLocalizedString(eventDesc,@"乐忆分享")
                                                                mediaType:SSPublishContentMediaTypeNews];
                        
                        [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        }];
                    }
                }else{
                    [self hideHud];
                    [CommonAlert showAlertWithTitle:@"提示" withMessage:@"创建失败,请重试!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
                }
                
            } failLoad:^(id result) {
                [self hideHud];
                [CommonAlert showAlertWithTitle:@"提示" withMessage:@"创建失败,请重试!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
            }];

        }else{
            if (selectedImages.count == 0&&self.storyTitle.length>0&&eventDesc.length>0) {
                UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加照片" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [ALERT show];
            }else if (selectedImages.count > 0&&self.storyTitle.length<=0&&eventDesc.length>0){
                UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择故事" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [ALERT show];
            }else if (selectedImages.count > 0&&self.storyTitle.length>0&&eventDesc.length<=0){
                UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写事件标题" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [ALERT show];
            }else{
                UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不完整~不能发布噢" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [ALERT show];
            }
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络连接,请检查您的网络设置!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    

    
    
}

-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, parentView.width-wid, 0.5)];
    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [parentView addSubview:lineIV];
    
}

-(void)addArrowWithHeight:(CGFloat)hei ToParentView:(UIView *)parentView{
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-60, hei, 15, 15)];
    arrowIV.image = [UIImage imageNamed:@"c1.png"];
    [parentView addSubview:arrowIV];
}

-(void)selectAction:(UIButton *)btn{
    [self inView];
    selectStroy = [[SelectStoryViewController alloc] init];
    [self.navigationController pushViewController:selectStroy animated:YES];
}

-(void)distributeAction:(UIButton *)btn{
//    if (storyVC.pictureDesc.length>0) {
//        NSString *tvText = storyVC.pictureDesc;
//        storyVC = [[StoryViewController alloc] init];
//        storyVC.tvText = tvText;
//        storyVC.butTag = [NSNumber numberWithInteger:btn.tag];
//        [self.navigationController pushViewController:storyVC animated:YES];
//    }else{
//        storyVC = [[StoryViewController alloc] init];
//        storyVC.butTag = [NSNumber numberWithInteger:btn.tag];
//        [self.navigationController pushViewController:storyVC animated:YES];
//    }
    
    NSString *btnTitle = [btn titleForState:UIControlStateNormal];
    if ([btnTitle isEqualToString:@"对这张照片描述一番吧~"]) {
        storyVC = [[StoryViewController alloc] init];
        storyVC.butTag = [NSNumber numberWithInteger:btn.tag];
        [self.navigationController pushViewController:storyVC animated:YES];
    }else{
        storyVC = [[StoryViewController alloc] init];
        storyVC.tvText = btnTitle;
        storyVC.butTag = [NSNumber numberWithInteger:btn.tag];
        [self.navigationController pushViewController:storyVC animated:YES];
    }
}

-(void)locationAction:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"dffg" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)addImageAction:(UIButton *)btn{
    [self inView];
    if (imageCount < 9) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            //无权限
            UIAlertView *photoUnable = [[UIAlertView alloc] initWithTitle:@"无法打开相册" message:@"请为乐忆开放照片权限:设置-隐私-照片-乐忆时光-打开" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [photoUnable show];
            return;
        }
        
        cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.imageCount = imageCount;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 9-imageCount;
        if ([PSConfigs getIphoneType] < IphoneType_6)
        {
            cont.nColumnCount = 3;
        }else{
            cont.nColumnCount = 4;
        }
        [self presentViewController:cont animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最多选择五张图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
   
}

-(void)squareButtonAction:(UIButton *)btn{
    UIButton *button = (UIButton *)[btn viewWithTag:100];
    button.selected = !button.selected;
}

-(void)shareAction:(UIButton *)btn{
    btn.tag = 1000;
        if (!btn.selected) {
//            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"sharesdk_img" ofType:@"jpg"];
//            id<ISSContent> publishContent = [ShareSDK content:CONTENT
//                                               defaultContent:@"分享"
//                                                        image:[ShareSDK imageWithPath:imagePath]
//                                                        title:@"乐忆"
//                                                          url:@"http://www.wetime.cn"
//                                                  description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
//                                                    mediaType:SSPublishContentMediaTypeNews];
//            
//            [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//            }];
//            
    
        }
        btn.selected = !btn.selected;
    
}

-(void)backAction{
   
    if (self.navigationController.viewControllers.count>2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.viewControllers.count == 2){
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        if (imageCount == 0) {
            if (aSelected.count>0) {
                float imageHeight = aSelected.count*80;
                _scrollView.contentSize = CGSizeMake(KScreenWidth, firstView.height+thirdView.height + 20 + imageHeight);
                secondView.frame = CGRectMake(10, firstView.bottom+10, KScreenWidth-20, imageHeight);
                thirdView.frame = CGRectMake(10, secondView.bottom+10, KScreenWidth-20, thirdView.height);
                float allHeight = firstView.height+secondView.height+thirdView.height;
                if (allHeight>KScreenHeight-64) {
                    _scrollView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
                }else{
                    _scrollView.frame = CGRectMake(0, 0, KScreenWidth, allHeight+30);
                }
                _scrollView.contentSize = CGSizeMake(KScreenWidth, thirdView.bottom);
                for (int i = 0; i<aSelected.count; i++) {
                    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 80*i, secondView.width, 75)];
                    imageView.backgroundColor = [UIColor whiteColor];
                    imageView.tag = 600+i;
                    [secondView addSubview:imageView];
                    
                    UIImageView *imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, imageView.height-20, imageView.height-20)];
                    imageButton.userInteractionEnabled = YES;
                    imageButton.multipleTouchEnabled = YES;
                    imageButton.image = aSelected[i];
                    [imageView addSubview:imageButton];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [imageButton addGestureRecognizer:tap];
                    [_taps addObject:tap];
                    [selectedImages addObject:aSelected[i]];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(imageButton.right+10, 8, imageView.width-imageButton.width-25, imageView.height-16);
                    button.tag = imageView.tag+20;
                    button.backgroundColor = [UIColor clearColor];
                    button.titleLabel.numberOfLines = 3;
//                    [button.titleLabel sizeToFit];
                    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [button setTitleColor:rgb(0, 0, 0, 1) forState:UIControlStateNormal];
                    [button setTitle:@"对这张照片描述一番吧~" forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(distributeAction:) forControlEvents:UIControlEventTouchUpInside];
                    [imageView addSubview:button];
                    
//                    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                    delButton.frame = CGRectMake(0, 0, 15, 15);
//                    delButton.center = CGPointMake(imageButton.left, imageButton.top);
//                    [delButton setImage:[UIImage imageNamed:@"c2"] forState:UIControlStateNormal];
//                    [imageView addSubview:delButton];
                }
                imageCount = (int)aSelected.count;
            }
        }else if(imageCount != 0 && imageCount<9){
            float imageHeight = aSelected.count*80;
            CGSize scrollSize = CGSizeMake(KScreenWidth, _scrollView.contentSize.height+imageHeight);
            _scrollView.contentSize = scrollSize;
            float secondViewHeight = secondView.height+imageHeight;
            secondView.frame = CGRectMake(10, firstView.bottom+10, KScreenWidth-20, secondViewHeight);
            thirdView.frame = CGRectMake(10, secondView.bottom+10, KScreenWidth-20, thirdView.height);
            float allHeight = firstView.height+secondView.height+thirdView.height;
            if (allHeight>KScreenHeight-64) {
                _scrollView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
            }else{
                _scrollView.frame = CGRectMake(0, 0, KScreenWidth, allHeight+30);
            }
            for (int i = 0; i<aSelected.count; i++) {
                UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 80*(i+imageCount), secondView.width, 75)];
                imageView.backgroundColor = [UIColor whiteColor];
                imageView.tag = 600+imageCount+i;
                [secondView addSubview:imageView];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, imageView.height-20, imageView.height-20)];
                iv.userInteractionEnabled = YES;
                iv.multipleTouchEnabled = YES;
                iv.image = aSelected[i];
                [imageView addSubview:iv];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [iv addGestureRecognizer:tap];
                [_taps addObject:tap];
                [selectedImages addObject:aSelected[i]];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(iv.right+10, 5, imageView.width-iv.width-35, imageView.height-20);
                button.tag = imageView.tag+20;
                button.backgroundColor = [UIColor clearColor];
                button.titleLabel.numberOfLines = 0;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [button setTitleColor:rgb(137, 137, 137, 1) forState:UIControlStateNormal];
                [button setTitleColor:rgb(0, 0, 0, 1) forState:UIControlStateNormal];
                [button setTitle:@"对这张照片描述一番吧~" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(distributeAction:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
            }
            imageCount = imageCount + aSelected.count;
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {

//        for (int i = 0; i < MIN(4, aSelected.count); i++)
//        {
//            UIImageView *iv = _aIVs[i];
//            iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
//        }
//        
        [ASSETHELPER clearData];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    int index = (int)[_taps indexOfObject:tap];
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight-20)];
    theView.alpha = 1;
    theView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view.window addSubview:theView];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    topLabel.backgroundColor = rgb(247, 247, 247, 1);
    topLabel.font = [UIFont systemFontOfSize:25.0];
    topLabel.textAlignment = 1;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"预览";
    [theView addSubview:topLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 12, 48, 20);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    [backButton addTarget:self action:@selector(removeTheViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:backButton];
    
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    delButton.frame = CGRectMake(KScreenWidth-70, 12, 50, 20);
    [delButton setTitle:@"删除" forState:UIControlStateNormal];
    [delButton setTitleColor:CommonBlue forState:UIControlStateNormal];
//    [delButton setTitle:@"删除" forState:UIControlStateNormal];
    delButton.showsTouchWhenHighlighted = YES;
    [delButton addTarget:self action:@selector(delViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:delButton];
    
    UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topLabel.bottom, KScreenWidth, theView.height-44)];
    theScrollView.contentSize = CGSizeMake(KScreenWidth*selectedImages.count, theScrollView.height);
    theScrollView.tag = 500;
    theScrollView.pagingEnabled = YES;
    theScrollView.delegate = self;
    theScrollView.backgroundColor = [UIColor clearColor];
    theScrollView.showsHorizontalScrollIndicator = NO;
    theScrollView.showsVerticalScrollIndicator = NO;
    [theView addSubview:theScrollView];
    
//    for (UIView *view in theScrollView.subviews) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            view
//        }
//    }
    
    for (int i = 0; i<selectedImages.count; i++) {
        
        UIScrollView *scrollIV = [[UIScrollView alloc] initWithFrame:CGRectMake(KScreenWidth*i, 0, KScreenWidth, theScrollView.height)];
        scrollIV.showsHorizontalScrollIndicator = NO;
        scrollIV.delegate = self;
        scrollIV.maximumZoomScale = 3;
        scrollIV.minimumZoomScale = 1;
        scrollIV.tag = 300+i;
        [theScrollView addSubview:scrollIV];
        
        UIImage *ig = selectedImages[i];
        float ivHeight = ig.size.height*KScreenWidth/ig.size.width;
        UIImageView *imageView = [[UIImageView alloc] init];
        if (ivHeight<scrollIV.height) {
            imageView.frame = CGRectMake(0, (scrollIV.height-ivHeight)/2, KScreenWidth, ivHeight);
        }else{
            imageView.frame = CGRectMake(0, 0, KScreenWidth, scrollIV.height);
        }
        imageView.tag = 400+i;
        imageView.image = ig;
        [scrollIV addSubview:imageView];
    }
    theScrollView.contentOffset = CGPointMake(KScreenWidth*index, 0);
}

-(void)removeTheViewAction:(UIButton *)btn{
    UIView *theView = btn.superview;
    [theView removeFromSuperview];
    theView = nil;
}

-(void)delViewAction:(UIButton *)btn{
    tempTheView = btn.superview;
    tempSV = (UIScrollView *)[tempTheView viewWithTag:500];
//    theScrollView.subviews.count;
    delIndex = tempSV.contentOffset.x/KScreenWidth;
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除这张图片么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.tag = 185;
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 700) {
        if (buttonIndex == 1) {
            UITextField *tagText = [alertView textFieldAtIndex:0];
            if (tagText.text.length > 4) {
                UIAlertView *Tixing = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标签最多四个字哦！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [Tixing show];
            }else{
                UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
                tagButton.frame = CGRectMake(tagWidth+10, tagHeight, (tagView.width-50)/4, 25);
                tagButton.tag = 1006+addTags.count;
                [tagButton setBackgroundImage:[UIImage imageNamed:@"tagGray"] forState:UIControlStateNormal];
                [tagButton setBackgroundImage:[UIImage imageNamed:@"tagYellow"] forState:UIControlStateSelected];
                tagButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [tagButton setTitleColor:rgb(176, 176, 176, 1) forState:UIControlStateNormal];
                [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    //            tagButton.selected = YES;
                [tagButton setTitle:tagText.text forState:UIControlStateNormal];
                [tagButton addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
                [tagView addSubview:tagButton];
                [addTags addObject:tagButton];
                [allTags addObject:tagButton];
                if (allTags.count%4 == 0) {
                    tagWidth = 0;
                    tagHeight = tagButton.top+35;
                }else{
                    tagHeight = tagButton.top;
                    tagWidth = tagButton.right;
                }
                
//                if (addTags.count == 3) {
//                    CGRect rect = tagView.frame;
//                    tagView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+50);
//                }
                if (allTags.count>8) {
                    CGRect rect = tagView.frame;
                    tagView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+60);
                }
            }
    }else{
            
        }
    }else if (alertView.tag == 180){
        if (buttonIndex == 0) {
            
        }else{
            if (selectedImages.count>0&&self.storyTitle.length>0&&eventDesc.length>0) {
                NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                long long timeInterval = (long long)[selectDate timeIntervalSince1970]*1000;
                NSNumber *time = [NSNumber numberWithLongLong:timeInterval];
                [param setObject:time forKey:@"time"];
                [param setObject:eventDesc forKey:@"title"];
                [param setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
                NSString *urll;
                if (selectStroy.storyDic != nil) {
                    urll = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/itemf/",[selectStroy.storyDic objectForKey:@"id"]];
                }else{
                    urll = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/itemf/",[self.storyDic objectForKey:@"id"]];
                }
                [self showHud:@"正在发布,请稍等..."];
                [DataService rrequestWithURL:urll params:param httpMethod:@"POST" block1:^(id result) {
                    NSDictionary *resultDic = (NSDictionary *)result;
                    if ([[resultDic objectForKey:@"result"] isEqual:@0]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"快去看看吧~喵" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag = 222;
                        [alert show];
                        [self postImages:[resultDic objectForKey:@"value"]];
                        UIButton *shareBtn = (UIButton*)[self.view viewWithTag:1000];
                        if (shareBtn.selected) {
                            NSString *savename = [NSString stringWithFormat:@"Documents/eventPic%d.jpg",1];
                            
                            //Create paths to output images
                            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:savename];
                            NSString *url = [NSString stringWithFormat:@"http://share.wetime.cn/index.html?itemId=%@&",[[resultDic objectForKey:@"value"] objectForKey:@"id"]];
                            NSString *content = [NSString stringWithFormat:@"%@%@",eventDesc,url];
                            id<ISSContent> publishContent = [ShareSDK content:content
                                                               defaultContent:@"分享"
                                                                        image:[ShareSDK imageWithPath:jpgPath]
                                                                        title:eventDesc
                                                                          url:@"https://api.weibo.com/oauth2/default.html"
                                                                  description:NSLocalizedString(eventDesc,@"乐忆分享")
                                                                    mediaType:SSPublishContentMediaTypeNews];
                            
                            [ShareSDK shareContent:publishContent type:ShareTypeSinaWeibo authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            }];
                        }
                    }else{
                        [CommonAlert showAlertWithTitle:@"提示" withMessage:@"Don't worry!Be happy~请稍后重试!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
                    }
                    
                } failLoad:^(id result) {
                    [self hideHud];
                     [CommonAlert showAlertWithTitle:@"提示" withMessage:@"Don't worry!Be happy~请稍后重试!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
                }];
                
            }else{
                if (selectedImages.count == 0&&self.storyTitle.length>0&&eventDesc.length>0) {
                    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加照片" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [ALERT show];
                }else if (selectedImages.count > 0&&self.storyTitle.length<=0&&eventDesc.length>0){
                    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择故事" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [ALERT show];
                }else if (selectedImages.count > 0&&self.storyTitle.length>0&&eventDesc.length<=0){
                    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写事件标题" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [ALERT show];
                }else{
                    UIAlertView *ALERT = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息不完整~不能发布噢" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [ALERT show];
                }
            }
        }
    }else if(alertView.tag == 185){
        if (buttonIndex == 0) {
        }else if(buttonIndex==1){
            [[tempSV viewWithTag:300+delIndex] removeFromSuperview];
            [_taps removeObjectAtIndex:delIndex];
            if (selectedImages.count == 1) {
                [tempTheView removeFromSuperview];
                tempTheView = nil;
            }
            float width1 = tempSV.contentSize.width;
            tempSV.contentSize = CGSizeMake(width1-KScreenWidth, tempSV.height);
            if (tempSV.contentOffset.x <= 0) {
                tempSV.contentOffset = CGPointMake(0, 0);
            }else{
                float offsetWidth = tempSV.contentOffset.x-KScreenWidth;
                if (offsetWidth<=0) {
                    tempSV.contentOffset = CGPointMake(0, 0);
                }else{
                    tempSV.contentOffset = CGPointMake(offsetWidth, 0);
                }
            }
            for (int i = 0; i<tempSV.subviews.count; i++) {
                if ([tempSV.subviews[i] isKindOfClass:[UIScrollView class]]) {
                    UIScrollView *smallSV = (UIScrollView *)tempSV.subviews[i];
                    smallSV.frame = CGRectMake(KScreenWidth*i, 0, KScreenWidth, tempSV.height);
                    smallSV.tag = 300+i;
    
                }
            }
            UIView *imageView = [secondView viewWithTag:600+delIndex];
            [imageView removeFromSuperview];
            
            [selectedImages removeObjectAtIndex:delIndex];
            [self.pictureDescs removeObjectForKey:[NSString stringWithFormat:@"%d",620+delIndex]];
            float secondViewHeight = secondView.height-80;
            secondView.frame = CGRectMake(10, firstView.bottom+10, KScreenWidth-20, secondViewHeight);
            secondView.backgroundColor = [UIColor cyanColor];
            if (secondView.subviews.count>0) {
                for (int i = 0;i<secondView.subviews.count;i++) {
                    
                    if ([secondView.subviews[i] isKindOfClass:[UIView class]]) {
                        UIView *view = secondView.subviews[i];
                        view.frame = CGRectMake(0, 80*i, secondView.width, 75);
                        view.tag = 600+i;
                    }
                }
            }
            imageCount = imageCount-1;
            thirdView.frame = CGRectMake(10, secondView.bottom+10, KScreenWidth-20, thirdView.height);
            _scrollView.contentSize = CGSizeMake(KScreenWidth, thirdView.bottom);
        }
    }else if(alertView.tag == 222){
        if (buttonIndex == 0) {
            if ([self.isPopRoot isEqualToString:@"poptoroot"]) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
               
                
            }else{
                if (self.navigationController.viewControllers.count>2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else if(self.navigationController.viewControllers.count == 2){
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"back" object:nil];
                    
                }else{
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            }
        }
    }
}

-(void)postImages:(NSDictionary *)dic{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    int imagecount = 0;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    __block NSDictionary *dd = dic;
    for (int i = 0; i<selectedImages.count; i++) {
        if (dd.count>0) {
            NSString *savename = [NSString stringWithFormat:@"Documents/eventPic%d.jpg",i+1];
            
            //Create paths to output images
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:savename];
            //Write image to jpg
            [UIImageJPEGRepresentation(selectedImages[i], 0.8) writeToFile:jpgPath atomically:YES];
            [param setObject:jpgPath forKey:@"path"];
            NSString *descKey = [NSString stringWithFormat:@"%d",620+i];
            if ([self.pictureDescs.allKeys indexOfObject:descKey]!= NSNotFound && self.pictureDescs != nil) {
                NSString *picDesc = [self.pictureDescs objectForKey:descKey];
                [param setObject:picDesc forKey:@"txt"];
            }
            [param setObject:[NSNumber numberWithInt:i+1] forKey:@"sort"];
            NSString *postImageUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%@/picf/one",[dic objectForKey:@"storyId"],[dic objectForKey:@"id"]];
            
            [DataService rrequestWithURL:postImageUrl params:param httpMethod:@"POST" block1:^(id result) {
                if (![result isKindOfClass:[NSNull class]]) {
                    NSDictionary *resultt = (NSDictionary *)result;
                    if (resultt.count > 0) {
                        if (i == selectedImages.count-1) {
                            [self hideHud];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"快去看看吧~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                alert.tag = 222;
                                [alert show];
                            });
                          
                        }
                    }else{
                        [self hideHud];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败,请重试!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                            [alert show];
                        });
                        [self deleteEvent:dic];
                        dd = nil;
                    }
                }else{
                    [self hideHud];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建失败,请重试!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        [alert show];
                    });
                    [self deleteEvent:dic];
                    dd = nil;
                }
            } failLoad:^(id result) {
                [CommonAlert showAlertWithTitle:@"提示" withMessage:@"创建失败,请重试!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
                [self deleteEvent:dic];
                dd = nil;
                [self hideHud];
        }];
        }else{
            break;
        }
        
    }

}

//显示正在加载的hud
-(void)showHud:(NSString *)title{
    if (_hud == Nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.labelText = title;
    _hud.dimBackground  =YES;
}

-(void)hideHud{
    [_hud hide:YES];
    _hud = nil;
}

-(void)deleteEvent:(NSDictionary *)dic{
    NSString *deleUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%@/del",[dic objectForKey:@"storyId"],[dic objectForKey:@"id"]];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [DataService requestWithURL:deleUrl params:params httpMethod:@"POST" block1:^(id result) {

    } failLoad:^(id result) {

    }];
}


#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:scrollView.tag+100];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 500) {
        int currentPage = scrollView.contentOffset.x / KScreenWidth;

        if (currentPage != indexPage) {
 
            UIScrollView *smallSV = (UIScrollView *)[scrollView viewWithTag:300+currentPage];
            [smallSV setZoomScale:1.0 animated:NO];
        }
        indexPage = currentPage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        _scrollView = nil;
        firstView = nil;
        secondView = nil;
        thirdView = nil;
        tempSV = nil;
        tempTheView = nil;
        BiaoqianText = nil;
        btnn1 = nil;
        btnnFirst = nil;
        ButtJia = nil;
        tagView = nil;
        shujuKuButton = nil;
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

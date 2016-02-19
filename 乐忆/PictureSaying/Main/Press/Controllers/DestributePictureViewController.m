//
//  DestributePictureViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/13.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "DestributePictureViewController.h"

@interface DestributePictureViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *tv;
@property(nonatomic,strong)UILabel *labeltext;

@end

@implementation DestributePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"描述照片";
    if (ios7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green: 240/255.0 blue:240/255.0 alpha:1];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight*0.05, KScreenWidth,KScreenHeight*0.25)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    self.tv = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, KScreenWidth-30,KScreenHeight*0.25+30)];
    self.tv.backgroundColor = [UIColor whiteColor];
    self.tv.textColor = [UIColor blackColor];
    self.tv.font = [UIFont systemFontOfSize:14.0];
    self.tv.delegate = self;
    [v addSubview:self.tv];
    
    self.labeltext = [[UILabel alloc] initWithFrame:CGRectMake(5,8, 150, 20)];
    self.labeltext.font = [UIFont systemFontOfSize:14.0];
    self.labeltext.text = @"对照片进行描述.....";
    self.labeltext.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
    [self.tv addSubview:self.labeltext];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,60, 44);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal ];
    [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}
-(void)click:(UIButton*)sender
{

}

-(void)textViewDidChange:(UITextView *)textView
{
    self.labeltext.hidden = YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (self.tv.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.labeltext.hidden=NO;
        }else{
            self.labeltext.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.tv.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.labeltext.hidden=NO;
            }else{//不是删除
                self.labeltext.hidden=YES;
            }
        }else{//长度不为1时候
            self.labeltext.hidden=YES;
        }
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        self.tv = nil;
        self.labeltext = nil;
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

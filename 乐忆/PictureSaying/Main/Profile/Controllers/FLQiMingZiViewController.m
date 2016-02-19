//
//  FLQiMingZiViewController.m
//  GerenshezhiCenter
//
//  Created by tutu on 14-12-9.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  修改名字

#import "FLQiMingZiViewController.h"

#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface FLQiMingZiViewController ()

@end

@implementation FLQiMingZiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"修改名字";
    self.view.backgroundColor = rgb(240, 240, 240, 1);
    [self tex];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,0,60, 44);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal ];
    [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
       // Do any additional setup after loading the view from its nib.
}

//起名字事件处理
-(void)tex{
    
    ViewText  = [[UIView alloc]init];
    ViewText.backgroundColor = [UIColor whiteColor];
    ViewText.frame = CGRectMake(0, 20, KScreenWidth, 60);
    [self.view addSubview:ViewText];
    
    mingzi = [[UITextField alloc]init];
    mingzi.delegate = self;
    mingzi.frame = CGRectMake(15, 0, KScreenWidth, 60);
    mingzi.font  = [UIFont systemFontOfSize:20];
    if (self.name.length>0) {
        mingzi.text = self.name;
    }else{
        
    }
    mingzi.backgroundColor = [UIColor whiteColor];
    mingzi.placeholder = @"取个昵称吧~";
    [ViewText addSubview:mingzi];
    [self addLineWithWidth:0 withHeight:60 toView:ViewText];
}

//线条功能处理
-(void)addLineWithWidth:(CGFloat)wid withHeight:(CGFloat)hei toView:(UIView *)parentView{
    UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(wid, hei, KScreenWidth, 0.5)];
    lineIV.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [parentView addSubview:lineIV];
    [parentView bringSubviewToFront:lineIV];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {//检测到“完成”
        [textField resignFirstResponder];//释放键盘
        return NO;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([toBeString length] > 7) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:7];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [mingzi resignFirstResponder];

}

//右边按钮处理事件
-(void)click:(UIButton *)bttt{
    if (mingzi.text.length>0) {
        _str = mingzi.text;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能为空哦~" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)
    {
        mingzi = nil;
        ViewText = nil;
        self.view = nil;
    }
}

@end

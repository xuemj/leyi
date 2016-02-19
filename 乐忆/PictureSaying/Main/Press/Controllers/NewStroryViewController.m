//
//  NewStroryViewController.m
//  PictureSaying
//
//  Created by tutu on 14/12/13.
//  Copyright (c) 2014年 tutu. All rights reserved.
//  新建故事

#import "NewStroryViewController.h"

@interface NewStroryViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation NewStroryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tf = [[UITextField alloc]init];
    self.tf.frame = CGRectMake(KScreenWidth*0.3,KScreenHeight*0.1, KScreenWidth*0.4, 30);
    self.tf.backgroundColor = [UIColor lightGrayColor];
    self.tf.delegate = self;
    [self.tf becomeFirstResponder];
    [self.view addSubview:self.tf];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KScreenWidth*0.4,KScreenHeight*0.2,KScreenWidth*0.2, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back:(UIButton*)sender
{
    [self showAlertView];
}

-(void)showAlertView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定添加么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        [self.tf resignFirstResponder];
        self.str = self.tf.text;
//        [self.navigationController popViewControllerAnimated:YES];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.str.length>0) {
            [params setObject:self.str forKey:@"title"];
            [params setObject:@"bbbbb" forKey:@"description"];
            [params setObject:@"nickname" forKey:@"nickname"];
            [params setObject:@0 forKey:@"source"];
            [params setObject:@0 forKey:@"status"];
            [params setObject:@0 forKey:@"support"];
            [params setObject:@0 forKey:@"userId"];
            [params setObject:@"15236985745" forKey:@"usn"];
            [params setObject:@0 forKey:@"visible"];
        }
        [DataService requestWithURL:@"/WeiXiao/api/v1/story/add" params:params requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
            self.storyDic = (NSDictionary *)result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failLoad:^(id result) {
            
        }];
//        [DataService requestWithURL:@"/WeiXiao/api/v1/story/add" params:params requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
//            self.storyDic = (NSDictionary *)result;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }];
        
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length>0&&![textField.text isEqualToString:@" "]) {
        self.str = textField.text;
    }else{
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    {
        _tf = nil;
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

//
//  ImagePickerViewController.m
//  ImageViewPickerTest
//
//  Created by zsy on 15/1/5.
//  Copyright (c) 2015年 zsy. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.cornerRadius = 0;
    self.view.layer.masksToBounds = YES;
//    self.showsCameraControls = NO;
    self.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor redColor];

    UIView *NavigationTransitionView = [self.view.subviews objectAtIndex:0];
    NavigationTransitionView.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    ImagePickerControllerAdjustViewController *adjustViewController = [[ImagePickerControllerAdjustViewController alloc] init];
    adjustViewController.isAva = self.isAva;
    adjustViewController.sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    adjustViewController.delegate = self;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:adjustViewController animated:NO];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错啦！" message:@"图片不能被保存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)imagePickerAdjustDidChooseImage:(ImagePickerControllerAdjustViewController *)imagePickerControllerAdjustViewController withImage:(UIImage *)image {
    if([_delegateDefine respondsToSelector:@selector(imagePickerDidChooseImage:withImage:)]) {
        [_delegateDefine imagePickerDidChooseImage:self withImage:image];
    }
}

@end

//
//  addressBookTableViewCell.m
//  Add
//
//  Created by tutu on 14/12/27.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "addressBookTableViewCell.h"
#import "AddressBookViewController.h"
@implementation addressBookTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self _initViews];
    }
    return self;
}
-(void)_initViews
{
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.label];
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgView];
}

-(void)setMyDic:(NSDictionary *)myDic{
    if (_myDic != myDic) {
        _myDic = myDic;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews
{
    [super awakeFromNib];
    NSNumber *s = [self.myDic objectForKey:@"status1"];
    if ([s isEqual:@1]) {
        
        
        self.button.frame = CGRectMake(KScreenWidth-100, 0, 100,self.frame.size.height);
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button setTitle:@"已添加" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        self.button.frame = CGRectMake(KScreenWidth-100, 0,100 ,self.frame.size.height);
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button setTitle:@"添加" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithRed:253/255.0 green:180/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
    }
    self.label.frame = CGRectMake(10,5, KScreenWidth*0.4, self.frame.size.height);
    self.label.text = [self.myDic objectForKey:@"name1"];
    self.imgView.frame = CGRectMake(KScreenWidth-20,self.frame.size.height*0.33, 15, self.frame.size.height*0.25);
    self.imgView.image = [UIImage imageNamed:@"c1"];

}
-(void)click:(UIButton *)btn{
    
   
    NSString *s1 = [self.myDic objectForKey:@"phone1"];
    NSString *s2 = [self.myDic objectForKey:@"name1"];
    if ([self.viewController.delegate respondsToSelector:@selector(sendToFirstView1:)]) {
        [self.viewController.delegate sendToFirstView1:s1];
    }
    if ([self.viewController.delegate respondsToSelector:@selector(sendToFirstView2:)]) {
        [self.viewController.delegate sendToFirstView2:s2];
    }
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
    
}
-(AddressBookViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[AddressBookViewController class]]) {
            return (AddressBookViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

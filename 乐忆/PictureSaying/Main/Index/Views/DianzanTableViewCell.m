//
//  DianzanTableViewCell.m
//  PictureSaying
//
//  Created by shixy on 15/1/26.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "DianzanTableViewCell.h"
#import "DianzanViewController.h"
@implementation DianzanTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _iniViews];
    }
    return self;
}
-(void)_iniViews
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.label];
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgView];
    self.imgView.layer.cornerRadius = 20;
    [self.imgView.layer setBorderWidth:0.5];
    [self.imgView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    self.imgView.layer.masksToBounds = YES;
}
-(void)setMyDic:(NSDictionary *)myDic{
    if (_myDic != myDic) {
        _myDic = myDic;
        [self setNeedsLayout];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSNumber *s = [self.myDic objectForKey:@"guanzhuStatus"];
    if ([s isEqual:@1]) {
        self.button.frame = CGRectMake(KScreenWidth-60,15, 50,30);
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button.layer setBorderWidth:1.0];
        [self.button.layer setBorderColor:[rgb(202, 202, 202, 1) CGColor]];
        [self.button setTitle:@"已关注" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        self.button.frame = CGRectMake(KScreenWidth-60,15, 50,30);
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.button.layer setBorderWidth:1.0];
        [self.button.layer setBorderColor:[CommonBlue CGColor]];
        [self.button setTitle:@"关注" forState:UIControlStateNormal];
        [self.button setTitleColor:CommonBlue forState:UIControlStateNormal];
    }
    self.imgView.frame = CGRectMake(10,10, 40,40);
    NSString *sImage = [self.myDic objectForKey:@"image"];
    if (sImage.length<10) {
        self.imgView.image = [UIImage imageNamed:@"defaultAva"];
    }
    else
    {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:sImage]];
    }
    self.label.frame = CGRectMake(self.imgView.right+15,20, KScreenWidth*0.5, 20);
    self.label.text = [self.myDic objectForKey:@"nickname"];
    
}
-(void)click:(UIButton *)btn{
     NSNumber *s = [self.myDic objectForKey:@"guanzhuStatus"];
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSMutableDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
  if ([s isEqual:@0])
    {
    [self.button.layer setBorderWidth:1.0];
    [self.button.layer setBorderColor:[rgb(202, 202, 202, 1) CGColor]];
    [self.button setTitle:@"已关注" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSString *url = @"/WeiXiao/api/v1/user/userSubscriber/add";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[tempDic objectForKey:@"id"] forKey:@"userId"];
    [dic setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
    [dic setObject:[tempDic objectForKey:@"source"] forKey:@"source"];
    [dic setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
    [dic setObject:[tempDic objectForKey:@"status"] forKey:@"status"];
    [dic setObject:@"0" forKey:@"groupName"];
    [dic setObject:[self.myDic objectForKey:@"id"] forKey:@"subscriberId"];
    [dic setObject:[self.myDic objectForKey:@"usn"] forKey:@"subscriberUsn"];
    [dic setObject:[self.myDic objectForKey:@"nickname"] forKey:@"subscriberRemark"];
    [dic setObject:[self.myDic objectForKey:@"source"] forKey:@"subscriberSource"];
     NSDictionary *headerDic1 = [NSDictionary dictionaryWithObject:@"text/json" forKey:@"Content-Type"];
   [DataService requestWithURL:url params:dic requestHeader:headerDic1 httpMethod:@"POST" block:^(NSObject *result) {
       
   } failLoad:^(id result) {
       
   }];
  
 }
   else
   {
       NSString *usrId = [tempDic objectForKey:@"id"];
       NSString *deleteId = [self.myDic objectForKey:@"id"];
       [self.button.layer setBorderWidth:1.0];
       [self.button.layer setBorderColor:[CommonBlue CGColor]];
       [self.button setTitle:@"关注" forState:UIControlStateNormal];
       [self.button setTitleColor:CommonBlue forState:UIControlStateNormal];
       NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/userSubscriber/delete/%@/%@",usrId,deleteId];
       [DataService requestWithURL:url params:nil httpMethod:@"GET" block1:^(id result) {
       } failLoad:^(id result) {
           
       }];
       
       
   
   }
    
}
-(DianzanViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[DianzanViewController class]]) {
            return (DianzanViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

@end


//
//  EventCell.m
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "EventCell.h"
#import "StroyListTableView.h"
#import "CommentViewController.h"
#import "UIView+Additions.h"
#import "PSConfigs.h"
@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
    [self _initViews];
}

-(void)_initViews{
    _dateLabel.textColor = CommonBlue;
    _lineIV.backgroundColor = rgb(221, 221, 221, 1);
    [self.contentView insertSubview:_lineIV belowSubview:_radisIV];
    _eventTitleLabel.numberOfLines = 0;
    _eventTitleLabel.font = [UIFont systemFontOfSize:15.0];
    _eventTitleLabel.textColor = rgb(77, 77, 77, 1);
//    _eventTitleLabel.textColor = [UIColor blackColor];
    imageViews = [[ImageViews alloc] initWithFrame:CGRectZero];
    imageViews.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imageViews];
    oneLine.alpha = 0.6;
    twoLine.alpha = 0.6;
    _bottomLine.alpha = 0.6;
    [_zanButton setImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_zanButton setImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
}

-(void)setModel:(EventModel *)model{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    imageViews.allPics = self.allPics;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.time floatValue]/1000];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd日MM月yyyy年"];
    NSString *regStr = [df stringFromDate:date];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:regStr];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3,7)];
    _dateLabel.frame = CGRectMake(30, 10, KScreenWidth/2, 30);
    _dateLabel.attributedText = str;
    _radisIV.frame = CGRectMake(_dateLabel.left-20, _dateLabel.center.y-5, 10, 10);
    _radisIV.image = [UIImage imageNamed:@"smallRadis.png"];
    _lineIV.frame = CGRectMake(_radisIV.center.x, 0, 1, self.height);
    CGSize size = [self.model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(KScreenWidth-55, 1000)];
    _eventTitleLabel.frame = CGRectMake(_dateLabel.left+10, _dateLabel.bottom, KScreenWidth-40-15, size.height+10);
    _eventTitleLabel.text = self.model.title;
    if ([self.writable isEqualToString:@"yes"]) {
        _deleteButton.frame = CGRectMake(KScreenWidth-35, _eventTitleLabel.top, 20, 20);
        _writeButton.frame = CGRectMake(_deleteButton.left-30, _deleteButton.top, 20, 20);
        
    }else{
        _deleteButton.frame = CGRectZero;
        _writeButton.frame = CGRectZero;
    }
    _deleteButton.hidden = YES;
    _writeButton.hidden = YES;
    
//    if (self.model.pics.count>3) {
//        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, ((KScreenWidth-_eventTitleLabel.left-15-20)/3)*2+10);
//    }else{
//        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, (KScreenWidth-_eventTitleLabel.left-15-20)/3);
//    }
    
    if (self.model.pics.count == 1) {
       NSInteger imageHeight = [self imageUrl:[self.model.pics[0] objectForKey:@"path"] withCount:1];
        if (imageHeight == 338) {
            imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, 9*(KScreenWidth-_eventTitleLabel.left-15)/16);
        }else{
            imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, 3*(KScreenWidth-_eventTitleLabel.left-15)/4);
        }
    }else if (self.model.pics.count == 2){
        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, 3*((KScreenWidth-_eventTitleLabel.left-15-10)/2)/4);
    }else if (self.model.pics.count == 3){
        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, (KScreenWidth-_eventTitleLabel.left-15-20)/3);
    }else if(self.model.pics.count == 4){
        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, 3*((KScreenWidth-_eventTitleLabel.left-15-10)/2)/2+10);
    }else{
        imageViews.frame = CGRectMake(_eventTitleLabel.left, _eventTitleLabel.bottom+5, KScreenWidth-_eventTitleLabel.left-15, ((KScreenWidth-_eventTitleLabel.left-15-20)/3)*2+10);
    }
//    if (self.model.pics.count>0) {
        imageViews.pics = self.model.pics;
//    }
    imageViews.mmodel = self.indexModel;
    imageViews.model = self.model;
    _shareBuuton.frame = CGRectMake(_eventTitleLabel.left, imageViews.bottom+10, (KScreenWidth-_eventTitleLabel.left-11)/3, 30);
    oneLine.frame = CGRectMake(_shareBuuton.right, _shareBuuton.top, 0.5, 27);
    _commentButton.frame = CGRectMake(oneLine.right, imageViews.bottom+10, (KScreenWidth-_eventTitleLabel.left-11)/3, 30);
    [_commentButton setCenter_y:_shareBuuton.center.y];
    twoLine.frame = CGRectMake(_commentButton.right, _shareBuuton.top, 0.5, 27);
    _zanButton.frame = CGRectMake(twoLine.right, imageViews.bottom+10, (KScreenWidth-_eventTitleLabel.left-11)/3, 30);
    if ([_model.isZan isEqualToString:@"0"]) {
        _zanButton.selected = YES;
    }else{
        _zanButton.selected = NO;
    }
    if ([self.model.favNum isEqualToString:@"0"]) {
        [_zanButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [_zanButton setTitle:[NSString stringWithFormat:@" %@",self.model.favNum] forState:UIControlStateNormal];
    }
    
    if ([self.model.commentNum isEqualToString:@"0"]) {
        [_commentButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [_commentButton setTitle:[NSString stringWithFormat:@" %@",self.model.commentNum] forState:UIControlStateNormal];
    }
    _bottomLine.frame = CGRectMake(_eventTitleLabel.left, _shareBuuton.bottom, KScreenWidth-_eventTitleLabel.left-11, 0.5);
}

-(NSInteger)imageUrl:(NSString *)path withCount:(NSInteger)count{
    //[_pics[4] objectForKey:@"path"]
    NSMutableString *imageUrl;
    NSInteger imageHeight;
    if ([path rangeOfString:@"http:"].location != NSNotFound) {
        imageUrl = [[NSMutableString alloc] initWithString:path];
        imageUrl = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:imageUrl]];
        NSArray *separatedUrl = [imageUrl componentsSeparatedByString:@"_"];
        NSInteger imageWidth = [separatedUrl[1] integerValue];
        NSInteger imageHeight1 = [separatedUrl[2] integerValue];
        if (count == 1) {
            if (imageWidth<imageHeight1) {
                imageHeight = 338;
            }else{
                imageHeight = 422;
            }
        }else if (count == 2){
            imageHeight = 207;
        }else if (count == 3){
            imageHeight = 108;
        }else if (count == 4){
            imageHeight = 207;
        }else{
            imageHeight = 108;
        }
    }else{
        imageHeight = 108;
    }
    return imageHeight;
}

- (IBAction)writeAction:(id)sender {
    
}

- (IBAction)deleteEventAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除这个事件么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        [self.tableView.data removeObjectAtIndex:[self.row integerValue]];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.row integerValue] inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
        //移除tableView中的数据
        [self.tableView reloadData];
        if(self.model.eventId.length>0){
            NSString *deleUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/%@/del",self.storyId,self.model.eventId];
            NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
            [DataService requestWithURL:deleUrl params:params httpMethod:@"POST" block1:^(id result) {

            } failLoad:^(id result) {
            
            }];
        }

    }
}

- (StroyListTableView *)tableView
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[StroyListTableView class]]) {
            return (StroyListTableView *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (IBAction)clickZanAction:(id)sender {
//    CALayer *viewLayer=[sender layer];
//    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.duration=0.05;
//    animation.repeatCount = 5;
//    animation.autoreverses=YES;
//    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
//    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"UserInfo ---------- %@",tempDic);
    [[PSConfigs shareConfigs] likeActionWithType:likeType_Event withZanButton:_zanButton withIndexModel:nil withEventModel:_model];
//    if ([self.model.isZan isEqualToString:@"0"]) {
//        NSInteger zanCount = [_zanCountLabel.text integerValue];
//        _zanCountLabel.text = [NSString stringWithFormat:@"%d",zanCount-1];
//        self.model.favNum = [NSString stringWithFormat:@"%d",zanCount-1];
//        _zanButton.selected = NO;
//        self.model.isZan = @"-1";
//        NSString *storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/%@/del",self.storyId,self.model.eventId,[tempDic objectForKey:@"usn"]];
////        [DataService requestWithURL:storyUrl params:nil httpMethod:@"POST" block:^(id result) {
////            NSLog(@"呜呜~他不爱我%@",result);
////        }];
//        [DataService requestWithURL:storyUrl params:nil httpMethod:@"POST" block1:^(id result) {
//            NSLog(@"呜呜~他不爱我%@",result);
//
//        } failLoad:^(id result) {
//        
//        }];
//    }else{
//        NSInteger zanCount = [_zanCountLabel.text integerValue];
//        _zanCountLabel.text = [NSString stringWithFormat:@"%d",zanCount+1];
//        self.model.favNum = [NSString stringWithFormat:@"%d",zanCount+1];
//        _zanButton.selected = YES;
//        self.model.isZan = @"0";
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
//        NSString *storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav",self.storyId,self.model.eventId];
////        [DataService requestWithURL:storyUrl params:params httpMethod:@"POST" block:^(id result) {
////            NSLog(@"有人点赞啦%@",result);
////        }];
//        [DataService requestWithURL:storyUrl params:params httpMethod:@"POST" block1:^(id result) {
//            NSLog(@"有人点赞啦%@",result);
//
//        } failLoad:^(id result) {
//
//        }];
//    }
//    animation.fromValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.3, 0.0, 0.0, 0.3)];
//    animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.3, 0.0, 0.0, 0.3)];
//    [viewLayer addAnimation:animation forKey:@"wiggle"];
    
}

- (IBAction)commentAction:(id)sender {
    self.model.accountNickName = self.indexModel.accountNickName;
    self.model.accountAva = self.indexModel.accountAva;
    CommentViewController *myEventComment = [[CommentViewController alloc] init];
    if ([self.writable isEqualToString:@"yes"]) {
        myEventComment.isMine = @"yes";
    }else{
        myEventComment.isMine = @"no";
    }
    myEventComment.storyId = self.storyId;
    myEventComment.eventId = self.model.eventId;
    myEventComment.emodel = self.model;
    [self.viewController.navigationController pushViewController:myEventComment animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

- (IBAction)shareEventAction:(id)sender {
    [PSConfigs shareConfigs].sid = self.model.eventId;
    [PSConfigs shareConfigs].image = [self.model.pics[0] objectForKey:@"path"];
    [PSConfigs shareConfigs].title = self.model.title;
    [[PSConfigs shareConfigs] shareActionWithFromViewController:self.viewController];
   
}

-(UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


//
//  EventDetailTableView.m
//  PictureSaying
//
//  Created by tutu on 15/2/5.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "EventDetailTableView.h"
#import "EventDetailCell.h"
#import "PSConfigs.h"
#import "EventDetailController.h"

@implementation EventDetailTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        [self _initHeaderView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    [self _initHeaderView];
}

-(void)_initHeaderView{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    userAva = [[UIImageView alloc] initWithFrame:CGRectZero];
    userAva.layer.cornerRadius = 25;
    userAva.layer.masksToBounds = YES;
    userAva.contentMode = UIViewContentModeScaleAspectFill;
    userAva.clipsToBounds = YES;
    userAva.image = [UIImage imageNamed:@"test.jpg"];
    [tableHeaderView addSubview:userAva];
    
    userName = [[UILabel alloc] initWithFrame:CGRectZero];
    userName.font = [UIFont systemFontOfSize:15.0];
    userName.textColor = rgb(87, 87, 87, 1);
    [tableHeaderView addSubview:userName];
    
    attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    attentionButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [attentionButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateNormal];
    [attentionButton setImage:[UIImage imageNamed:@"attentioned.png"] forState:UIControlStateDisabled];
    [tableHeaderView addSubview:attentionButton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.numberOfLines = 0;
    [tableHeaderView addSubview:titleLabel];
    
    line = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = CommonGray;
    [tableHeaderView addSubview:line];
}

-(void)setModel:(EventModel *)model{
    if (_model != model) {
        _model = model;
        CGSize size = [model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
        tableHeaderView.height = size.height+KScreenWidth*0.55+110;
        userAva.frame = CGRectMake(10, 10, 50, 50);
        userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
        userName.frame = CGRectMake(userAva.right + 10, userAva.top, self.width-70-70, 30);
        userName.text = @"hhhhhhhhhh";
        attentionButton.frame = CGRectMake(self.width-60, userName.top, 50, 25);
        
        line.frame = CGRectMake(userName.left, userName.bottom, self.width-70, 0.5);
        titleLabel.frame = CGRectMake(userName.left, line.bottom, line.width-10, size.height+10);
        //        contentLabel.backgroundColor = [UIColor brownColor];
        titleLabel.text = model.title;
        tableHeaderView.height = userName.height+titleLabel.height+10+0.5+10;
        self.tableHeaderView = tableHeaderView;
    }
}

-(void)setMmodel:(MainModel *)mmodel{
    if (_mmodel != mmodel) {
        _mmodel = mmodel;
        
        CGSize size = [mmodel.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
        tableHeaderView.height = size.height+KScreenWidth*0.55+110;
        userAva.frame = CGRectMake(10, 10, 50, 50);
        userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
        userName.frame = CGRectMake(userAva.right + 10, userAva.top, self.width-70-70, 30);
        userName.text = @"hhhhhhhhhh";
        attentionButton.frame = CGRectMake(self.width-60, userName.top, 50, 25);
        if ([mmodel.isSub isEqualToString:@"yes"]) {
            attentionButton.enabled = NO;
        }else{
            attentionButton.enabled = YES;
        }
        if ([self.eviewController.isMine isEqualToString:@"yes"]) {
            attentionButton.enabled = NO;

        }else{
            attentionButton.enabled = YES;

        }
        line.frame = CGRectMake(userName.left, userName.bottom, self.width-70, 0.5);
        titleLabel.frame = CGRectMake(userName.left, line.bottom, line.width-10, size.height+10);
        //        contentLabel.backgroundColor = [UIColor brownColor];
        titleLabel.text = mmodel.title;
        tableHeaderView.height = userName.height+titleLabel.height+10+0.5+10;
        self.tableHeaderView = tableHeaderView;
    }
}

- (EventDetailController *)eviewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[EventDetailController class]]) {
            return (EventDetailController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _refreshHeaderView.hidden = YES;
    _refreshHeaderView = nil;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"EventDetailCell";
    EventDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EventDetailCell" owner:self options:nil] lastObject];
        cell.backgroundColor = rgb(241, 241, 241, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.picDic = self.data[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *picDic = self.data[indexPath.row];
    float textHeight = 0.0;
    if (![[picDic objectForKey:@"txt"] isKindOfClass:[NSNull class]]) {
        CGSize size = [[picDic objectForKey:@"txt"] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(KScreenWidth-30, 1000)];
        textHeight = size.height+10;
    }else{
        textHeight = 10;
    }
    float imageHeight = 0.0;
    NSArray *imageInfo = [self imageUrl:[picDic objectForKey:@"path"]];
    if ([imageInfo[0] isEqual:@338]) {
        imageHeight = 9*KScreenWidth/16;
    }else{
        imageHeight = 3*KScreenWidth/4;
    }
    float cellHeight = textHeight+imageHeight+10;
    return cellHeight;
}

-(NSArray *)imageUrl:(NSString *)path{
    //[_pics[4] objectForKey:@"path"]
    NSMutableString *imageUrl;
    NSInteger imageHeight;
    if ([path rangeOfString:@"http:"].location != NSNotFound) {
        imageUrl = [[NSMutableString alloc] initWithString:path];
        imageUrl = [NSMutableString stringWithString:[PSConfigs getImageUrlPrefixWithSourcePath:imageUrl]];
        NSArray *separatedUrl = [imageUrl componentsSeparatedByString:@"_"];
        NSInteger imageWidth = [separatedUrl[1] integerValue];
        NSInteger imageHeight1 = [separatedUrl[2] integerValue];
        if (imageWidth<imageHeight1) {
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage338]];
            imageHeight = 338;
        }else{
            imageUrl = [NSMutableString stringWithString:[imageUrl stringByAppendingString:kImage422]];
            imageHeight = 422;
        }
    }else{
        imageUrl = [[NSMutableString alloc] initWithString:@""];
    }
    NSArray *imageInfo = @[[NSNumber numberWithInteger:imageHeight],[NSURL URLWithString:imageUrl]];
    return imageInfo;
}

//#pragma mark - ButtonAction
//-(void)zanStoryAction:(UIButton *)btn{
//    NSLog(@"点击了赞按钮");
//    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
//    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"UserInfo ---------- %@",tempDic);
//    
//    [[PSConfigs shareConfigs] likeActionWithType:likeType_Story withZanButton:zanBuuton withZanLabel:zanCount withIndexModel:_model withEventModel:nil];
//    //    if ([self.model.isZan isEqualToString:@"0"]) {
//    //        NSInteger zanCou = [zanCount.text integerValue];
//    //        zanCount.text = [NSString stringWithFormat:@"%d",zanCou-1];
//    //        self.model.zanCount = [NSString stringWithFormat:@"%d",zanCou-1];
//    //        zanBuuton.selected = NO;
//    //        self.model.isZan = @"-1";
//    //        NSString *storyUrl;
//    //        if (self.model.sid.length>0) {
//    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@/del",self.model.sid,[tempDic objectForKey:@"usn"]];
//    //        }else{
//    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@/del",self.model.storyId,[tempDic objectForKey:@"usn"]];
//    //        }
//    ////        [DataService requestWithURL:storyUrl params:nil httpMethod:@"POST" block1:^(id result) {
//    ////            NSLog(@"呜呜~他不爱我%@",result);
//    ////        }];
//    //        [DataService requestWithURL:storyUrl params:nil httpMethod:@"POST" block:^(id result) {
//    //            NSLog(@"呜呜~他不爱我%@",result);
//    //        }];
//    //    }else{
//    //        NSInteger zanCou = [zanCount.text integerValue];
//    //        zanCount.text = [NSString stringWithFormat:@"%d",zanCou+1];
//    //        self.model.zanCount = [NSString stringWithFormat:@"%d",zanCou+1];
//    //        zanBuuton.selected = YES;
//    //        self.model.isZan = @"0";
//    //        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //        [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
//    //        NSString *storyUrl;
//    //        if (self.model.storyId.length>0) {
//    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav",self.model.storyId];
//    //        }else{
//    //            storyUrl = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav",self.model.sid];
//    //        }
//    //        NSLog(@"stroly %@",storyUrl);
//    ////        [DataService requestWithURL:storyUrl params:params httpMethod:@"POST" block1:^(id result) {
//    ////            NSLog(@"有人给你点赞啦%@",result);
//    ////        }];
//    //        [DataService requestWithURL:storyUrl params:params httpMethod:@"POST" block:^(id result) {
//    //            NSLog(@"有人给你点赞啦%@",result);
//    //        }];
//    //    }
//    //    NSLog(@"%@",self.nextResponder.nextResponder);
//    //    //    [(UITableView *)self.nextResponder.nextResponder reloadData];
//    //    //    [btn setImage:[UIImage imageNamed:(i%2==0?@"red.png":@"gray.png")] forState:UIControlStateNormal];
//    //    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    //    k.values = @[@(0.1),@(1.0),@(2.0),@(3.0),@(4.0)];
//    //    k.keyTimes = @[@(0.0),@(0.5),@(1.0),@(1.5),@(2.0)];
//    //    k.calculationMode = kCAAnimationLinear;
//    //    [btn.layer addAnimation:k forKey:@"SHOW"];
//}
//
//-(void)commentStoryAction:(UIButton *)btn{
//    NSLog(@"点击了评论按钮");
//    CommentViewController *myEventComment = [[CommentViewController alloc] init];
//    myEventComment.isStory = @"story";
//    myEventComment.delegate = self.viewController;
//    if (self.model.sid.length>0) {
//        myEventComment.storyId = self.model.sid;
//    }else{
//        myEventComment.storyId = self.model.storyId;
//    }
//    myEventComment.imodel = self.model;
//    [self.viewController.navigationController pushViewController:myEventComment animated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
//}
//
//-(void)shareStoryAction:(UIButton *)btn{
//    NSLog(@"点击了分享按钮");
//    [[PSConfigs shareConfigs] shareActionWithFromViewController:self.viewController withObject:self.model];
//}

@end

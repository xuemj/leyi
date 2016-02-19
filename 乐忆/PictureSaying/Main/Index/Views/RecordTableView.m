//
//  RecordTableView.m
//  PictureSaying
//
//  Created by tutu on 15/1/28.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "RecordTableView.h"
#import "RecordCell.h"
#import "CreateViewController.h"
#import "StoryDetailViewController.h"
//#import "DebugViewController.h"
//#import "DebugBigViewController.h"
#import "CreateStoryViewController.h"
#import "EventDetailController.h"
#import "MobClick.h"
#import "CommentViewController.h"
@implementation RecordTableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = self;
        self.delegate = self;
        statusArray = [NSMutableArray array];
        statusDic = [NSMutableDictionary dictionary];
        //        UIImageView *bgView= [[UIImageView alloc] initWithFrame:self.bounds];
        //        bgView.image = [UIImage imageNamed:@"bgimage3.jpg"];
        //        self.backgroundView = bgView;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    statusArray = [NSMutableArray array];
    statusDic = [NSMutableDictionary dictionary];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    if (self.tag == 100||self.tag == 101) {
//        _refreshHeaderView.hidden = YES;
//        _refreshHeaderView = nil;
//    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.indexData.count+1;
    }else{
        return self.indexData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.indexData.count) {
        static NSString *identifier = @"recordCell";
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RecordCell" owner:self options:nil] lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (tableView.tag == 100) {
            cell.isMine = 1;
            cell.row = [NSNumber numberWithInteger:indexPath.row];
            cell.storyDic = self.storys[indexPath.row];
            cell.isStory = @"yes";
        }
        if (tableView.tag == 153){
            cell.isStory = @"yes";
        }
        cell.model = self.indexData[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, KScreenWidth-20, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        UIButton *createStroy = [UIButton buttonWithType:UIButtonTypeCustom];
        createStroy.frame = CGRectMake(0, 0, bgView.width, bgView.height);
        createStroy.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [createStroy setTitleColor:CommonBlue forState:UIControlStateNormal];
        [createStroy setTitle:@"创建故事" forState:UIControlStateNormal];
        [createStroy addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:createStroy];
        cell.backgroundColor = rgb(218, 218, 218, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.row == self.indexData.count) {
            return;
        }
    }
    if (tableView.tag == 100 || tableView.tag == 153) {
        StoryDetailViewController *storyDetailVC = [[StoryDetailViewController alloc] init];
        storyDetailVC.model = self.indexData[indexPath.row];
        if (tableView.tag == 100) {
            storyDetailVC.writable = @"yes";

        }else{
            storyDetailVC.writable = @"no";

        }
        [self.viewController.navigationController pushViewController:storyDetailVC animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
    }else{
        MainModel *model = self.indexData[indexPath.row];
//        if ([model.templateId isEqualToString:@"2"]) {
//            DebugBigViewController *debugBigVC = [[DebugBigViewController alloc] init];
//            debugBigVC.model = self.indexData[indexPath.row];
//            [self.viewController.navigationController pushViewController:debugBigVC animated:YES];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
//        }else{
//            DebugViewController *debugVC = [[DebugViewController alloc] init];
//            [self.viewController.navigationController pushViewController:debugVC animated:YES];
//            debugVC.model = self.indexData[indexPath.row];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
//        }
//        EventDetailController *eventDetail = [[EventDetailController alloc] init];
//        eventDetail.isMine = @"no";
//        [self.viewController.navigationController pushViewController:eventDetail animated:YES];
//        eventDetail.mmodel = self.indexData[indexPath.row];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
//        CommentViewController *myEventComment = [[CommentViewController alloc] init];
//        myEventComment.fromEvent = @"yes";
//        myEventComment.storyId = model.storyId;
//        myEventComment.eventId = model.itemId;
//        myEventComment.imodel = model;
//        [self.viewController.navigationController pushViewController:myEventComment animated:YES];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
        
        CommentViewController *storyComment = [[CommentViewController alloc] init];
        storyComment.fromEvent = @"yes";

        if (model.itemId.length>0) {
            storyComment.storyId = model.storyId;
            storyComment.eventId = model.itemId;
            storyComment.chuanzhi = model.pics;
            storyComment.num = model.commentCount;
        }else{
            storyComment.isStory = @"story";
            if (model.sid.length>0) {
                storyComment.storyId = model.sid;
            }else{
                storyComment.storyId = model.storyId;
            }
        }
        storyComment.imodel = model;
        [self.viewController.navigationController pushViewController:storyComment animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.indexData.count) {
        MainModel *model = self.indexData[indexPath.row];
        CGFloat contentHeight;
        if (![model.title isKindOfClass:[NSNull class]]) {
            if (model.title != nil) {
                
                CGSize contentSize = [model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
                contentHeight = contentSize.height+20;
            }else{
                contentHeight = 40;
            }
        }else{
            contentHeight = 20;
        }
        CGFloat imageHeight = 9*(KScreenWidth-20)/16;
        
        return contentHeight+imageHeight+40+50;
    }else{
        return 50;
    }
    
}

-(void)createAction:(UIButton *)btn{
    CreateStoryViewController *cvc = [[CreateStoryViewController alloc]init];
    [self.viewController.navigationController pushViewController:cvc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
    [MobClick event:@"gishifabu"];
}

@end

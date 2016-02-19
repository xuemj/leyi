//
//  StroyListTableView.m
//  PictureSaying
//
//  Created by tutu on 14/12/17.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "StroyListTableView.h"
#import "CommentViewController.h"
#import "PSConfigs.h"
#import "EventDetailController.h"
#import "StoryDetailViewController.h"

@implementation StroyListTableView
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
    titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width-20, self.width*0.55)];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    titleImageView.clipsToBounds = YES;
    [tableHeaderView addSubview:titleImageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [tableHeaderView addSubview:titleLabel];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.font = [UIFont systemFontOfSize:14.0];
    dateLabel.textColor = CommonBlue;
    [tableHeaderView addSubview:dateLabel];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.numberOfLines = 0;
    [tableHeaderView addSubview:contentLabel];
    
    line = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = CommonGray;
    [tableHeaderView addSubview:line];
}

-(void)setModel:(MainModel *)model{
    if (_model != model) {
        _model = model;
        CGSize size = [model.descrip sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(KScreenWidth-20, 1000)];
        tableHeaderView.height = size.height+KScreenWidth*0.55+10+10+25+5+23+10;
        titleImageView.frame = CGRectMake(10, 10, self.width-20, self.width*0.55);
        if (model.image.length>0) {
            [titleImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        }else{
            titleImageView.image = [UIImage imageNamed:@"noCover.png"];
        }
        titleLabel.frame = CGRectMake(10, titleImageView.bottom+5, titleImageView.width, 25);
        titleLabel.text = model.title;
        dateLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom+3, 100, 20);
//        dateLabel.backgroundColor = [UIColor whiteColor];
        dateLabel.text = model.time;
        contentLabel.frame = CGRectMake(titleLabel.left, dateLabel.bottom, titleImageView.width, size.height+10);
//        contentLabel.backgroundColor = [UIColor brownColor];
        contentLabel.text = model.descrip;
//        tableHeaderView.height = contentLabel.bottom+50;
        self.tableHeaderView = tableHeaderView;
//        line.frame = CGRectMake(0, tableHeaderView.height-1, KScreenWidth, 0.5);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.tag == 100) {
        _refreshHeaderView.hidden = YES;
        _refreshHeaderView = nil;
    }
}

- (StoryDetailViewController *)sviewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[StoryDetailViewController class]]) {
            return (StoryDetailViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"EventCell";
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"EventCell" owner:self options:nil] lastObject];
        //        cell = [[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = rgb(241, 241, 241, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.writable = self.writable;
    cell.row = [NSNumber numberWithInteger:indexPath.row];
    cell.allPics = self.data;
    cell.model = self.data[indexPath.row];
    cell.viewController = self.viewController;
    cell.indexModel = _model;
    if (self.model.sid.length>0) {
        cell.storyId = self.model.sid;
    }else{
        cell.storyId = self.model.storyId;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventModel *model = self.data[indexPath.row];
    model.accountAva = self.model.accountAva;
    model.accountNickName = self.model.accountNickName;
//    EventDetailController *eventDetail = [[EventDetailController alloc] init];
//    if ([self.sviewController.writable isEqualToString:@"yes"]) {
//        eventDetail.isMine = @"yes";
//    }else{
//        eventDetail.isMine = @"no";
//    }
//    eventDetail.model = model;
//    [self.viewController.navigationController pushViewController:eventDetail animated:YES];
    
    CommentViewController *myEventComment = [[CommentViewController alloc] init];
    
    if ([self.sviewController.writable isEqualToString:@"yes"]) {
        myEventComment.isMine = @"yes";
    }else{
        myEventComment.isMine = @"no";
    }
    myEventComment.fromEvent = @"yes";
    myEventComment.storyId = model.storyId;
    myEventComment.eventId = model.eventId;
    myEventComment.emodel = model;
    [self.viewController.navigationController pushViewController:myEventComment animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventModel *model = self.data[indexPath.row];
//    if (model.pics.count>3) {
//        NSLog(@"hhhhh%f",((KScreenWidth-65)/3)*2+100);
//        return ((KScreenWidth-65)/3)*2+120;
//    }else{
//        NSLog(@"hhhhh%f",(KScreenWidth-65)/3+100);
//        return (KScreenWidth-65)/3+120;
//    }
    CGFloat imageViewHeight;
    if (model.pics.count == 1) {
        NSInteger imageHeight = [self imageUrl:[model.pics[0] objectForKey:@"path"] withCount:1];
        if (imageHeight == 338) {
            imageViewHeight = 9*(KScreenWidth-40-15)/16;
        }else{
            imageViewHeight = 3*(KScreenWidth-40-15)/4;
        }
    }else if (model.pics.count == 2){
        imageViewHeight = 3*((KScreenWidth-40-15-10)/2)/4;
    }else if (model.pics.count == 3){
        imageViewHeight = (KScreenWidth-40-15-20)/3;
    }else if(model.pics.count == 4){
        imageViewHeight = 3*((KScreenWidth-40-15-10)/2)/2+10;
    }else {
        imageViewHeight = (KScreenWidth-40-15-20)/3*2+10;
    }
    
    CGSize size = [model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(KScreenWidth-55, 1000)];
    return imageViewHeight+85.5+size.height+10;
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
        }else if (count > 4){
            imageHeight = 108;
        }
    }else{
        imageHeight = 108;
    }
    return imageHeight;
}

#pragma mark - UITableView Delegate
/*------------------------删除cell的代理方法---------------------------*/
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if (tableView.tag == 100) {
        if ([tableView isEqual:self]) {
            result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
        }
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    //设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    if (self.tag == 100) {
        [self setEditing:editing animated:animated];
    }
    //切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tag == 100) {
        //请求数据源提交的插入或删除指定行接收者。
        if (editingStyle ==UITableViewCellEditingStyleDelete) {
            //如果编辑样式为删除样式
            if (indexPath.row<[self.data count]) {
                //移除数据源的数据
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                //移除tableView中的数据
            }
        }
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

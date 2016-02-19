//
//  HeaderViewCell.m
//  Comment
//
//  Created by tutu on 14/12/11.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "HeaderViewCell.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "PSConfigs.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation HeaderViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initViews];
}

-(void)_initViews{
    self.MView.layer.borderColor = [[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]CGColor];
    self.MView.layer.borderWidth = .5;
    self._imageview.contentMode = UIViewContentModeScaleAspectFill;
    self._imageview.clipsToBounds = YES;
    
    
//    UIView *lineView = [PSConfigs lineViewWithWidth:320 withY:202];
//    [self.contentView addSubview:lineView];
}

-(void)setInfo:(Info *)info{
    if (_info != info) {
        _info = info;
        
        if ([_info.image isEqualToString:@"nourl"])
        {
            self._imageview.image = [UIImage imageNamed:@"test.jpg"];
        }
        else
        {
            [self._imageview sd_setImageWithURL:[NSURL URLWithString:_info.image]];
        }
    }
}



-(void)share:(UIButton*)sender
{
   [self.viewController.tf becomeFirstResponder];

}

//-(IBAction)likeButtonTouchUp:(UIButton *)sender
//{
//    enum likeType type = likeType_Story;
//    if (_eventModel != nil)
//    {
 //       type = likeType_Event;
 //   }
   // [[PSConfigs shareConfigs] likeActionWithType:type withZanButton:_xinBtn withZanLabel:_xinCount withIndexModel:_indexModel withEventModel:_eventModel];
//}

-(CommentViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[CommentViewController class]]) {
            return (CommentViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

  
}

//-(IBAction)showShareView:(UIButton *)sender
//{
//    [[PSConfigs shareConfigs] shareActionWithFromViewController:self.viewController withObject:self.indexModel];
//}

@end

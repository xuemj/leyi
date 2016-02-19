//
//  StoryCell.m
//  SelectStory
//
//  Created by tutu on 14/12/10.
//  Copyright (c) 2014年 tutu. All rights reserved.
//

#import "StoryCell.h"
#import "AppDelegate.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation StoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      

    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
//    self.MyView.frame = CGRectMake(10, 10, kScreenWidth-20, self.frame.size.height-20) ;
    self.MyView.backgroundColor = [UIColor whiteColor];
//    self.label.frame = CGRectMake(10, 5, kScreenWidth-40, self.MyView.frame.size.height-20);
    self.label.font  = [UIFont fontWithName:@"" size:kScreenHeight*0.1*0.2];
}

-(void)setText:(NSString *)text{
    if (_text != text) {
        _text = text;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    self.MyView.frame = CGRectMake(10, 5, kScreenWidth-20, self.frame.size.height-10) ;
    self.label.frame = CGRectMake(10, 10, kScreenWidth-40, self.MyView.frame.size.height-20);
    self.label.text = _text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

@end

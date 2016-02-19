//
//  RecordCell.m
//  PictureSaying
//
//  Created by tutu on 15/1/27.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "RecordCell.h"
#import "PSConfigs.h"
#import "RecordTableView.h"
#import "RecordViewController.h"

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
    [self _initViews];
}

-(void)_initViews{
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.userAva.layer.cornerRadius = 25;
    self.userAva.layer.masksToBounds = YES;
    self.userAva.layer.borderColor = [rgb(221, 221, 221, 1) CGColor];
    self.userAva.layer.borderWidth = 0.8;
    self.userAva.clipsToBounds = YES;
    self.mainImage.contentMode = UIViewContentModeScaleAspectFill;
    self.mainImage.clipsToBounds = YES;
    [self.like setImage:[UIImage imageNamed:@"gray.png"] forState:UIControlStateNormal];
    [self.like setImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    self.picCount.layer.cornerRadius = 5;
    self.picCount.layer.masksToBounds = YES;
    self.picCount.backgroundColor = [UIColor blackColor];
    self.picCount.alpha = 0.6;
    self.picCount.textColor = [UIColor whiteColor];
    self.picCount.textAlignment = 1;
    self.line.backgroundColor = CommonGray;
    self.line.alpha = 0.6;
    self.oneLine.backgroundColor = CommonGray;
    self.oneLine.alpha = 0.6;
    self.twoLine.backgroundColor = CommonGray;
    self.twoLine.alpha = 0.6;
    self.attention.layer.cornerRadius = 3;
    self.attention.layer.masksToBounds= YES;
    self.attention.layer.borderWidth = 0.5;
    self.attention.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.attention.layer.borderColor = CommonBlue.CGColor;
    [self.attention setTitleColor:CommonBlue forState:UIControlStateNormal];
    [self.attention setTitle:@"关注" forState:UIControlStateNormal];
    [self.attention setTitleColor:CommonGray forState:UIControlStateSelected];
    [self.attention setTitle:@"已关注" forState:UIControlStateSelected];
}

-(void)setModel:(MainModel *)model{
    if (_model != model) {
        _model = model;
        [self requestZanAndComment1];
        [self requestAvaAndNickname];
        [self _loadNewData];
        [self setNeedsLayout];
    }
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(5, 5, self.width-10, self.height-10);
    
    self.userAva.frame = CGRectMake(10, 12, 50, 50);
    if (![self.model.accountAva isKindOfClass:[NSNull class]]) {
        if (self.model.accountAva.length>0) {
            [self.userAva sd_setImageWithURL:[NSURL URLWithString:self.model.accountAva]];
        }else{

        }
    }else{

    }
    self.userName.frame = CGRectMake(self.userAva.right+10, self.userAva.top, self.bgView.width-140, 20);
    if (self.isMine == 1) {
        self.deleteButton.hidden = NO;
        self.deleteButton.frame = CGRectMake(self.bgView.width-45, self.userName.top-5, 30, 30);
        self.attention.hidden = YES;
    }else{
        
        self.attention.hidden = NO;
        self.attention.frame = CGRectMake(self.bgView.width-50, self.userName.top-2, 40, 25);

        self.deleteButton.hidden = YES;
    }

    self.line.frame = CGRectMake(self.userName.left, self.userName.bottom+5, self.bgView.width-70, 0.5);
    if (![self.model.title isKindOfClass:[NSNull class]]) {
        if (self.model.title != nil) {
            CGSize contentSize = [self.model.title sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(200, 1000)];
            self.content.frame = CGRectMake(self.userName.left, self.line.bottom, self.bgView.width-80, contentSize.height+20);
            self.content.text = self.model.title;
        }else{
            self.content.frame = CGRectMake(self.userName.left, self.line.bottom, self.bgView.width-80, 40);
            self.content.text = @"这个故事竟没有简介。。。";
        }
    }else{
        self.content.frame = CGRectMake(self.userName.left, self.line.bottom, self.bgView.width-80, 40);
        self.content.text = @"这个故事竟没有简介";
    }
    self.mainImage.frame = CGRectMake(0, self.content.bottom, self.bgView.width, 9*self.bgView.width/16);
    if (![self.model.image isKindOfClass:[NSNull class]]&&self.model.image.length>0) {
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:self.model.image]];
    }else{
        self.mainImage.image = [UIImage imageNamed:@"noCover.png"];
    }
    if (self.isMine == 1) {
        self.changeCover.hidden = NO;
        self.changeCover.frame = CGRectMake(self.bgView.width-50, self.bgView.height-90, 45, 45);
        self.picCount.frame = CGRectMake(self.bgView.width-75, self.bgView.height-80, 60, 0.1);
        self.picCount.hidden = YES;
    }else{
        self.picCount.hidden = NO;
        self.picCount.frame = CGRectMake(self.bgView.width-55, self.bgView.height-80, 40, 25);
        if (self.model.pics.count>=2) {
            NSString *picCount = [NSString stringWithFormat:@"%d图",self.model.pics.count];
            self.picCount.text = picCount;
        }else{
            self.picCount.hidden = YES;
        }
        self.changeCover.frame = CGRectMake(self.bgView.width-60, self.bgView.height-100, 45, 0.1);
        self.changeCover.hidden = YES;
    }
    self.share.frame = CGRectMake(0, self.mainImage.bottom, (self.bgView.width-2)/3, 40);
    self.oneLine.frame = CGRectMake(self.share.right, self.share.top+8, 0.5, 24);
    self.comment.frame = CGRectMake(self.oneLine.right, self.mainImage.bottom, (self.bgView.width-2)/3, 40);
    self.twoLine.frame = CGRectMake(self.comment.right, self.share.top+8, 0.5, 24);

    self.like.frame = CGRectMake(self.twoLine.right, self.mainImage.bottom, (self.bgView.width-2)/3, 40);

}

- (IBAction)shareAction:(id)sender {
       if (!self.model.itemId) {
           if (self.model.sid.length>0) {
               [PSConfigs shareConfigs].sid = self.model.sid;
           }
           else
           {
               [PSConfigs shareConfigs].sid = self.model.storyId;
           }
           if (self.model.image.length>0) {
               [PSConfigs shareConfigs].image = self.model.image;
           }
           else
           {
              [PSConfigs shareConfigs].image = @"http://wetime.oss-cn-beijing.aliyuncs.com/54f6c32245ce44b0b5c59dfe_640_640.jpeg";
           }
           [PSConfigs shareConfigs].title = self.model.title;

        [[PSConfigs shareConfigs] shareActionWithFromViewController:self.viewController withObject:self.model];

    }
    else
    {
        [PSConfigs shareConfigs].sid = self.model.itemId;
        [PSConfigs shareConfigs].title = self.model.title;
        [PSConfigs shareConfigs].image = [self.model.pics[0] objectForKey:@"path"];
        [[PSConfigs shareConfigs] shareActionWithFromViewController:self.viewController ];

    
    }
        
}

- (IBAction)commentAction:(id)sender {

    
    CommentViewController *storyComment = [[CommentViewController alloc] init];
    if (self.model.itemId.length>0) {
        storyComment.storyId = self.model.storyId;
        storyComment.eventId = self.model.itemId;
        storyComment.chuanzhi = self.model.pics;
        storyComment.num = self.model.commentCount;
    }else{
        storyComment.isStory = @"story";
        if (self.model.sid.length>0) {
            storyComment.storyId = self.model.sid;
        }else{
            storyComment.storyId = self.model.storyId;
        }
    }
    
    storyComment.imodel = self.model;
    [self.viewController.navigationController pushViewController:storyComment animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
}

- (IBAction)clickAction:(id)sender {

    if (self.model.itemId.length>0) {
        [[PSConfigs shareConfigs] likeActionWithType:likeType_Event withZanButton:self.like withIndexModel:self.model withEventModel:nil];
    }else{
        [[PSConfigs shareConfigs] likeActionWithType:likeType_Story withZanButton:self.like withIndexModel:self.model withEventModel:nil];
    }
    
}

-(void)requestZanAndComment1{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    if (self.model.itemId.length>0) {
        NSString *urlstring1;
   
        urlstring1 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/%@",self.model.storyId,self.model.itemId,[tempDic objectForKey:@"usn"]];
        [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
    
            self.model.isZan = [[result objectForKey:@"value"] stringValue];
      
            if ([self.model.isZan isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.like.selected = YES;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.like.selected = NO;
                });            }
        } failLoad:^(id result) {
            
        }];
        
        NSString *urlstring2 = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@/item/%@/comment",self.model.storyId,self.model.itemId];
        [DataService requestWithURL:urlstring2 params:nil httpMethod:@"GET" block1:^(id result) {
          
            self.model.commentCount = [[result objectForKey:@"value"] stringValue];
           
            if (![self.model.commentCount isEqualToString:@"0"]) {
                NSString *commentCount = [NSString stringWithFormat:@" %@",self.model.commentCount];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.comment setTitle:commentCount forState:UIControlStateNormal];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.comment setTitle:@"" forState:UIControlStateNormal];
                });
            }
        } failLoad:^(id result) {
            
        }];
        NSString *urlstring3 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/item/%@/fav/",self.model.storyId,self.model.itemId];
        [DataService requestWithURL:urlstring3 params:nil httpMethod:@"GET" block1:^(id result) {
           
            if (![[result objectForKey:@"value"] isKindOfClass:[NSNull class]]) {
                self.model.zanCount = [[result objectForKey:@"value"] stringValue];
                if (![self.model.zanCount isEqualToString:@"0"]) {
                    NSString *zanCount = [NSString stringWithFormat:@" %@",self.model.zanCount];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.like setTitle:zanCount forState:UIControlStateNormal];
                    });
                }else{
                    [self.like setTitle:@"" forState:UIControlStateNormal];
                }
            }
        } failLoad:^(id result) {
            
        }];
    }else{
    NSString *urlstring1;
    if (self.model.sid.length>0) {
        urlstring1 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@",self.model.sid,[tempDic objectForKey:@"usn"]];
    }else{
        urlstring1 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/%@",self.model.storyId,[tempDic objectForKey:@"usn"]];
    }
    [DataService requestWithURL:urlstring1 params:nil httpMethod:@"GET" block1:^(id result) {
       
        self.model.isZan = [[result objectForKey:@"value"] stringValue];
        
        if ([self.model.isZan isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.like.selected = YES;
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.like.selected = NO;
            });
        }
    } failLoad:^(id result) {
        
    }];
    
    NSString *urlstring2;
    if (self.model.sid.length>0) {
        urlstring2 = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@/comment",self.model.sid];
    }else{
        urlstring2 = [NSString stringWithFormat:@"/WeiXiaoComment/api/v1/story/%@/comment",self.model.storyId];
    }
    [DataService requestWithURL:urlstring2 params:nil httpMethod:@"GET" block1:^(id result) {

        self.model.commentCount = [[result objectForKey:@"value"] stringValue];
     
        if (![self.model.commentCount isEqualToString:@"0"]) {
            NSString *commentCount = [NSString stringWithFormat:@" %@",self.model.commentCount];
            [self.comment setTitle:commentCount forState:UIControlStateNormal];
        }else{
            [self.comment setTitle:@"" forState:UIControlStateNormal];
        }
    } failLoad:^(id result) {
        
    }];
    NSString *urlstring3;
    if (self.model.sid.length>0) {
        urlstring3 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/",self.model.sid];
    }else{
        urlstring3 = [NSString stringWithFormat:@"/WeiXiaoFavOrHat/api/v1/story/%@/fav/",self.model.storyId];
    }
    [DataService requestWithURL:urlstring3 params:nil httpMethod:@"GET" block1:^(id result) {
    
        if (![[result objectForKey:@"value"] isKindOfClass:[NSNull class]]) {
            self.model.zanCount = [[result objectForKey:@"value"] stringValue];
            if (![self.model.zanCount isEqualToString:@"0"]) {
                NSString *zanCount = [NSString stringWithFormat:@" %@",self.model.zanCount];
                [self.like setTitle:zanCount forState:UIControlStateNormal];
            }else{
                [self.like setTitle:@"" forState:UIControlStateNormal];
            }
        }
    } failLoad:^(id result) {
        
    }];
}
   
}

-(void)requestAvaAndNickname{
    if (self.model.usn.length>0) {
        NSString *urlstring1 =[NSString stringWithFormat:@"/WeiXiao/api/v1/user/public/getUserByNumber/%@",self.model.usn];
        [DataService requestWithURL:urlstring1 params: nil httpMethod:@"GET" block1:^(id result) {
            NSDictionary *userInfo = (NSDictionary *)result;
            self.model.accountAva = [userInfo objectForKey:@"image"];
            self.model.accountNickName = [userInfo objectForKey:@"nickname"];
            if (![self.model.accountAva isKindOfClass:[NSNull class]]) {
                if (self.model.accountAva.length>0) {
                    [self.userAva sd_setImageWithURL:[NSURL URLWithString:self.model.accountAva]];

                }else{
                    self.userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
                }
            }else{
                self.userAva.image = [UIImage imageNamed:@"gerenzhxintouxing.png"];
            }
            
            if (![self.model.accountNickName isKindOfClass:[NSNull class]]) {
                if (self.model.accountNickName.length>0) {
                    self.userName.text = self.model.accountNickName;

                    
                }else{
                    self.userName.text = @"该用户太懒,没有昵称~";
                    
                }
            }else{
                self.userName.text = @"该用户太懒,没有昵称~";
                
            }
            self.userId = [userInfo objectForKey:@"id"];
            self.model.userId = [userInfo objectForKey:@"id"];
            if (!self.isMine == 1) {
                [self requestIfSub:[userInfo objectForKey:@"id"]];
            }
        } failLoad:^(id result) {
            
        }];
    }
}

-(void)requestIfSub:(NSString *)userid{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *url1 = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/userSubscriber/%@/%@",[tempDic objectForKey:@"id"],userid];
    [DataService requestWithURL:url1 params:nil httpMethod:@"GET" block1:^(id result) {
        if ([[result allKeys] count] == 0) {
            self.model.isSub = @"no";

            dispatch_async(dispatch_get_main_queue(), ^{
                self.attention.layer.borderColor = CommonBlue.CGColor;
                self.attention.selected = NO;
            });
        }else{
            self.model.isSub = @"yes";

            dispatch_async(dispatch_get_main_queue(), ^{
                self.attention.layer.borderColor = CommonGray.CGColor;
                self.attention.selected = YES;
            });
        }
    } failLoad:^(id result) {
        
    }];
}

- (IBAction)changeCover:(id)sender {
    ImagePickerViewController *picker = [[ImagePickerViewController alloc]init];
    picker.isAva = @"noava";
    picker.delegateDefine = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerDidChooseImage:(ImagePickerViewController *)imagePickerViewController withImage:(UIImage *)image{
    [self.viewController showHud:@"正在上传,请稍等~"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveImage:image WithName:@"storyCover.jpg"];
        [self postCover:self.storyDic];
    });
    self.mainImage.image = image;
}

- (IBAction)attentionAction:(id)sender {
    UIButton *BT = (UIButton *)sender;
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    if (BT.selected != YES) {
        if (self.userId.length>0) {
           
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@0 forKey:@"groupName"];
            [params setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
            [params setObject:@0 forKey:@"source"];
            [params setObject:@0 forKey:@"status"];
            [params setObject:[tempDic objectForKey:@"id"] forKey:@"userId"];
            [params setObject:[tempDic objectForKey:@"usn"] forKey:@"usn"];
            [params setObject:self.model.accountNickName forKey:@"subscriberRemark"];
            [params setObject:self.userId forKey:@"subscriberId"];
            [params setObject:@0 forKey:@"subscriberSource"];
            [params setObject:self.model.usn forKey:@"subscriberUsn"];

            [DataService requestWithURL:@"/WeiXiao/api/v1/user/userSubscriber/add" params:params requestHeader:nil httpMethod:REQ_POST block:^(NSObject *result) {
                NSDictionary *subResult = (NSDictionary *)result;
                if (subResult.count>0) {
                    self.model.isSub = @"yes";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.attention.layer.borderColor = CommonGray.CGColor;
                        self.attention.selected = YES;
                    });
                }else{
    
                }
            } failLoad:^(id result) {
                
            }];
        }
    }else{

        if (self.userId>0) {
            NSString *url = [NSString stringWithFormat:@"/WeiXiao/api/v1/user/userSubscriber/delete/%@/%@",[tempDic objectForKey:@"id"],self.userId];
            [DataService requestWithURL:url params:nil httpMethod:@"GET" block1:^(id result) {
                NSDictionary *subResult = (NSDictionary *)result;
                NSString *s = [subResult objectForKey:@"result"];
                if ([s isEqual:@0]) {
                    self.model.isSub = @"no";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.attention.layer.borderColor = CommonBlue.CGColor;
                        self.attention.selected = NO;
                    });
                }else{
        
                }
            } failLoad:^(id result) {
                
            }];
        }
        
    }
}

-(void)_loadNewData{
    
    NSString *strUrl;
    if (self.model.sid.length>0) {
        strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/15",self.model.sid];
    }else{
        strUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/story/%@/item/0/15",self.model.storyId];
    }
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [DataService requestWithURL:strUrl params:params httpMethod:@"GET" block1:^(id result) {
        NSArray *tempArray = (NSArray *)result;
        if (tempArray.count>0) {
            self.haveEvent = @"yes";
        }else{
            self.haveEvent = @"no";
        }
    } failLoad:^(id result) {

    }];
}

- (IBAction)deleteAction:(id)sender {
    NSLog(@"");
    if ([self.haveEvent isEqualToString:@"yes"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该故事里有事件,不能删除!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除这个故事吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 500;
        [alert show];
    }
}

- (BaseViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[BaseViewController class]]) {
            return (BaseViewController *)next;
        }
        
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.viewController showHud:@"正在上传,请稍等~"];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *theImage = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        //判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
      
            
        } else {
            //照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
    }
    [self saveImage:theImage WithName:@"storyCover.jpg"];
    [self postCover:self.storyDic];

}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)postCover:(NSDictionary *)dic{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSString *sid = [dic objectForKey:@"id"];
    NSString *postCoverUrl = [NSString stringWithFormat:@"/WeiXiaoStory/api/v1/upload/story/%@/cover",sid];
    NSString *sanbox = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [sanbox stringByAppendingPathComponent:@"storyCover.jpg"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    [params setObject:filePath forKey:@"pic"];
    [DataService rrequestWithURL:postCoverUrl params:params httpMethod:@"POST" block1:^(id result) {
        NSDictionary *resultDic= (NSDictionary *)result;
        if ([[resultDic objectForKey:@"result"] isEqual:@0]) {
            NSString *storyCoverUrl = [resultDic objectForKey:@"value"];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [newDic setObject:storyCoverUrl forKey:@"image"];
            [self editStoryRequest:newDic];
        }else{
            [self.viewController hideHud];
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败,请重新上传" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [failAlert show];
        }
    } failLoad:^(id result) {
        NSString *errorTip = (NSString *)result;
        if ([errorTip rangeOfString:@"Connection refused"].location != NSNotFound) {
            //do something
            [PSConfigs showProgressWithError:result withView:self.viewController.view operationResponseString:nil delayShow:NO isImage:NO];
            
        }else if ([errorTip rangeOfString:@"请求超时"].location != NSNotFound || [errorTip rangeOfString:@"The request timed out"].location != NSNotFound) {

            //do something
            [PSConfigs showProgressWithError:result withView:self.viewController.view operationResponseString:nil delayShow:NO isImage:NO];
            
        }
    }];
}

-(void)editStoryRequest:(NSMutableDictionary *)dic{
    [DataService requestWithURL:@"/WeiXiao/api/v1/story/edit" params:dic requestHeader:nil httpMethod:@"POST" block:^(NSObject *result) {
        NSDictionary *resultDic = (NSDictionary *)result;
        if ([[resultDic objectForKey:@"result"] isEqual:@0]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewController hideHud];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.viewController hideHud];
            });
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败,请重新上传" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [failAlert show];
        }
    } failLoad:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.viewController hideHud];
        });
        [CommonAlert showAlertWithTitle:@"提示" withMessage:@"请求失败,请检查网络设置!" withDelegate:NO withCancelButton:@"知道了" withSure:nil withOwner:nil];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {
        if (buttonIndex == 0) {
            
        }else{
            //移除数据源的数据
            [self.tableView.indexData removeObjectAtIndex:[self.row integerValue]];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.row integerValue] inSection:0];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
            //移除tableView中的数据
            [self.tableView reloadData];
            if(self.model.sid.length>0){
                NSString *deleUrl = [NSString stringWithFormat:@"/WeiXiao/api/v1/story/delete/%@",self.model.sid];
                [DataService requestWithURL:deleUrl params:nil httpMethod:@"GET" block1:^(id result) {
                    
                } failLoad:^(id result) {
                    
                }];
            }
        }
    }
}

- (RecordTableView *)tableView{
        UIResponder *next = self.nextResponder;
        do {
            if ([next isKindOfClass:[RecordTableView class]]) {
                return (RecordTableView *)next;
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

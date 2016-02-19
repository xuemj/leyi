//
//  PSMorePhotoController.m
//  PictureSaying
//
//  Created by tutu on 15/1/7.
//  Copyright (c) 2015年 tutu. All rights reserved.
//

#import "PSMorePhotoController.h"
#import "PSMorePhotoInfo.h"
#import "PSPhotoCell.h"
#import "NSArray+Additions.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NSString+Additions.h"
#import "UIScrollView+MJRefresh.h"
#import "UIView+Additions.h"
#import "PSConfigs.h"

#define kMorePhotoDataLimit 20

@interface PSMorePhotoController ()

@end

@implementation PSMorePhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =@"朋友的相册";
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTableView.backgroundColor = [UIColor whiteColor];
    
    [_mainTableView showLoadingWithLabelText:@"正在加载中"];
    
    [self getDataMorePhotoFromNetwork:NO];
    
    __weak PSMorePhotoController *viewC = self;
    [_mainTableView addHeaderWithCallback:^{
        if (netStatus != 0) {
            [viewC getDataMorePhotoFromNetwork:NO];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [_mainTableView headerEndRefreshing];
            [_mainTableView hideLoading];

        }
    }];
    [_mainTableView addFooterWithCallback:^{
        if (netStatus != 0) {
            [viewC getDataMorePhotoFromNetwork:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络无连接,请检查您的网络设置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [_mainTableView footerEndRefreshing];
            [_mainTableView hideLoading];
        }
    }];
    
    _leftBottomImageView = [[UIImageView alloc] init];
    _middleBottomImageView = [[UIImageView alloc] init];
    _rightBottomImageView = [[UIImageView alloc] init];
    
    _leftTopImageView = [[UIImageView alloc] init];
    _middleTopImageView = [[UIImageView alloc] init];
    _rightTopImageView = [[UIImageView alloc] init];
}

#pragma mark -getNetwork
-(void)getDataMorePhotoFromNetwork:(BOOL)isLoadMore
{
    NSData *tempUserData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUserInfo"];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:tempUserData options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[tempDic objectForKey:@"usn"] forKey:@"accountUsn"];
    NSString *urlstring = [NSString stringWithFormat:@"/WeiXiaoAlbum/api/v1/album/%@/photo/day/%d/%d",_photoId,0,kMorePhotoDataLimit];
    if (isLoadMore)
    {
        PSMorePhotoInfo *info = [_morePhotoInfoArray lastObject];
        PSPhotoItem *item = [info.photos lastObject];
        urlstring = [urlstring stringByAppendingFormat:@"?startId=%@",item.itemId];
    }
 
    [DataService requestWithURL:urlstring params:nil httpMethod:@"GET" block1:^(id result) {
      // ITLog([result JSONString]);
       
        NSArray *arrrA = result;
        
        [_mainTableView headerEndRefreshing];
        [_mainTableView footerEndRefreshing];
        [_mainTableView hideLoading];
        
        NSInteger count = 0;
        if (isLoadMore)
        {
            //            NSMutableArray *array = [PSPhotoInfo photoInfosWithPhotoDicArray:arrrA];
            //            for (int i = 0; i < array.count; i++)
            //            {
            //                BOOL isHaveDuplicate = NO;
            //                PSMorePhotoInfo *photoInfo1 = array[i];
            //                for (int j = 0; j < _morePhotoInfoArray.count; j++)
            //                {
            //                    PSMorePhotoInfo *photoInfo2 = _morePhotoInfoArray[j];
            //                }
            //                if (!isHaveDuplicate)
            //                {
            //                    [_morePhotoInfoArray addObject:photoInfo1];
            //                }
            //            }
            
            NSMutableArray *newArray = [PSMorePhotoInfo morePhotosWithMorePhotoDicArray:arrrA];
            for (PSMorePhotoInfo *morePhotoInfo in newArray)
            {
                count += morePhotoInfo.photos.count;
            }
            if (newArray.count > 0)
            {
                PSMorePhotoInfo *morePhotoInfo1 = [newArray firstObject];
                PSMorePhotoInfo *morePhotoInfoNew = [_morePhotoInfoArray lastObject];
                if ([morePhotoInfo1.time isEqualToString:morePhotoInfoNew.time])
                {
                    [morePhotoInfoNew.photos addObjectsFromArray:morePhotoInfo1.photos];
                }
                else
                {
                    [_morePhotoInfoArray addObject:morePhotoInfo1];
                }
                [newArray removeObjectAtIndex:0];
                [self.morePhotoInfoArray addObjectsFromArray:newArray];
            }
        }
        else
        {
            self.morePhotoInfoArray = [PSMorePhotoInfo morePhotosWithMorePhotoDicArray:arrrA];
            for (PSMorePhotoInfo *morePhotoInfo in _morePhotoInfoArray)
            {
                count += morePhotoInfo.photos.count;
            }
        }
        
        if (count < kMorePhotoDataLimit)
        {
            [_mainTableView removeFooter];
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __weak PSMorePhotoController *viewC = self;
                [_mainTableView addFooterWithCallback:^{
                    [viewC getDataMorePhotoFromNetwork:YES];
                }];
            });
        }
        
        [_mainTableView reloadData];
    } failLoad:^(id result) {
        
    }];
}

-(void)photoBrowserShowWithMorePhotoInfo:(PSMorePhotoInfo *)morePhotoInfo withCurrentIndex:(NSInteger)currentIndex withSrcImageView:(UIImageView *)srcImageView
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *mjphotos = [NSMutableArray arrayWithCapacity:morePhotoInfo.photos.count];
    NSArray *srcArray = [self getPhotoInfoSrcListWithMorePhotoInfo:morePhotoInfo];
    for (int i = 0; i < morePhotoInfo.photos.count; i++)
    {
        PSPhotoItem *item = morePhotoInfo.photos[i];
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        NSString *path = [PSConfigs getImageUrlPrefixWithSourcePath:item.path];
        NSArray *pathArray = [path componentsSeparatedByString:@"_"];
        NSString *coppression = [NSString stringWithFormat:@"_compression_%@_%@.jpeg",pathArray[1],pathArray[2]];
        path = [path stringByAppendingString:coppression];
        mjphoto.url = [NSURL URLWithString:path];
//        if (i == currentIndex)
//        {
//            mjphoto.srcImageView = srcImageView;
//        }
        UIImageView *srcImageView = [srcArray PSobjectAtIndex:i];
        if ([srcImageView isKindOfClass:[UIImageView class]])
        {
            mjphoto.srcImageView = srcImageView;
        }
        else
        {
            
            mjphoto.srcImageView = nil;
        }
        
        [mjphotos addObject:mjphoto];
    }
    browser.photos = mjphotos;
    browser.currentPhotoIndex = currentIndex;
    [browser show];
}

-(NSArray *)getPhotoInfoSrcListWithMorePhotoInfo:(PSMorePhotoInfo *)morePhotoInfo
{
    NSMutableArray *srcImageViews = [NSMutableArray arrayWithCapacity:morePhotoInfo.photos.count];
    if (morePhotoInfo.photos.count > 0)
    {
        for (int i = 0; i < morePhotoInfo.photos.count; i += 3)
        {
            PSPhotoCell *cell = (PSPhotoCell *)[_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i/3 inSection:[_morePhotoInfoArray indexOfObject:morePhotoInfo]]];
            NSArray *imageViews = [cell getImageViews];
            if (imageViews.count != 3)
            {
                imageViews = [NSArray arrayWithObjects:@"",@"",@"", nil];
            }
            [srcImageViews addObjectsFromArray:imageViews];
        }
    }
    int startIndex = -1;
    int stopIndex = -1;
    for (int i = 0; i < srcImageViews.count; i++)
    {
        UIImageView *srcImageView = srcImageViews[i];
        if (startIndex == -1)
        {
            if (![srcImageView isKindOfClass:[UIImageView class]])
            {
                startIndex = i;
            }
        }
        else
        {
            if ([srcImageView isKindOfClass:[UIImageView class]])
            {
                stopIndex = i-1;
                break;
            }
        }
    }
    
    //上边的不为imageView
    if (startIndex == 0)
    {
        for (int i = startIndex; i <= stopIndex; i++)
        {
            UIImageView *imageView =  srcImageViews[(i%3)+stopIndex+1];
            UIImageView *srcImageView = _leftTopImageView;
            switch (i%3)
            {
                case 0:
                {
                    srcImageView = _leftTopImageView;
                }
                    break;
                case 1:
                {
                    srcImageView = _middleTopImageView;
                }
                    break;
                case 2:
                {
                    srcImageView = _rightTopImageView;
                }
                    break;
                default:
                    break;
            }
            srcImageView.frame = imageView.frame;
            [srcImageView removeFromSuperview];
            [imageView.superview addSubview:srcImageView];
            
            [srcImageView setFrame_y:imageView.frame.origin.y-8-imageView.height];
            [srcImageViews replaceObjectAtIndex:i withObject:srcImageView];
        }
    }
    
    startIndex = -1;
    stopIndex = -1;
    for (int i = (int)srcImageViews.count-1; i >= 0; i--)
    {
        UIImageView *srcImageView = srcImageViews[i];
        if (stopIndex == -1)
        {
            if (![srcImageView isKindOfClass:[UIImageView class]])
            {
                stopIndex = i;
            }
        }
        else
        {
            if ([srcImageView isKindOfClass:[UIImageView class]])
            {
                startIndex = i+1;
                break;
            }
        }
    }
    
    if (startIndex > 0 && stopIndex > 0)
        //下边的不为imageView
    {
        for (int i = startIndex; i <= stopIndex; i++)
        {
            UIImageView *imageView =  srcImageViews[(startIndex-3)+(i%3)];
            UIImageView *srcImageView = _leftBottomImageView;
            switch (i%3)
            {
                case 0:
                {
                    srcImageView = _leftBottomImageView;
                }
                    break;
                case 1:
                {
                    srcImageView = _middleBottomImageView;
                }
                    break;
                case 2:
                {
                    srcImageView = _rightBottomImageView;
                }
                    break;
                default:
                    break;
            }
            srcImageView.frame = imageView.frame;
            [srcImageView removeFromSuperview];
            [imageView.superview addSubview:srcImageView];
            
            [srcImageView setFrame_y:imageView.height+8];
            [srcImageViews replaceObjectAtIndex:i withObject:srcImageView];
        }
    }
    return srcImageViews;
}

#pragma mark -UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const identifier = @"PSPhotoCell";
    PSPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PSPhotoCell" owner:nil options:nil];
        cell = [nib firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PSMorePhotoInfo *info = _morePhotoInfoArray[indexPath.section];

    PSPhotoItem *leftItem = [info.photos PSobjectAtIndex:indexPath.row*3];
    PSPhotoItem *middleItem = [info.photos PSobjectAtIndex:indexPath.row*3+1];
    PSPhotoItem *rightItem = [info.photos PSobjectAtIndex:indexPath.row*3+2];
    [cell setLeftItem:leftItem withMiddleItem:middleItem withRightItem:rightItem isSectionTwo:NO superVC:self belongtoPhotoInfo:info];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PSMorePhotoInfo *morePhotoInfo = _morePhotoInfoArray[section];
    return (morePhotoInfo.photos.count-1)/3+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _morePhotoInfoArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
    
    UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if(!myHeader) {
        myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UIView *view = [[UIView alloc] initWithFrame:myHeader.bounds];
        view.backgroundColor = [UIColor whiteColor];
        myHeader.backgroundView = view;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 16, 300, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.tag = kHeaderTag;
        [myHeader addSubview:label];
        myHeader.backgroundColor = [UIColor whiteColor];
    }
    
    UILabel *label = (UILabel *)[myHeader viewWithTag:kHeaderTag];
    
    PSMorePhotoInfo *info = _morePhotoInfoArray[section];
    label.text = info.time;
    
    return myHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PSPhotoCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

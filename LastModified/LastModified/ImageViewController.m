//
//  ImageViewController.m
//  LastModified
//
//  Created by caifeng on 2017/6/12.
//  Copyright © 2017年 facaishu. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://ff.facaishu.com/dyupfiles/images/2017-05/25/1_admin_upload_1495702928102.jpg"];
    
    [_imgV sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        NSLog(@"%ld-%ld", receivedSize, expectedSize);
    
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
        //0 none 1 disk 2 memory
        NSLog(@"%ld", cacheType);
    }];
}


@end

//
//  ViewController.m
//  LLAVPlayer
//
//  Created by liushaohua on 16/12/11.
//  Copyright © 2016年 liushaohua. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *snipImgV;

@property (nonatomic, strong)AVPlayer *avplayer;

@property (nonatomic, strong)AVPlayerViewController *avplayerVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 播放视频
- (IBAction)clickStartPlayBtn:(id)sender {
    AVPlayerViewController *avplayerVc = [AVPlayerViewController new];
    avplayerVc.player = self.avplayer;
    // 进行 modal 展示(全屏)  如果自定义大小的话  不需要modal  只需要这是 AVplayer的 layer 即可
    
    // 主动播放
    [avplayerVc.player play];
    self.avplayerVc = avplayerVc;
    
}
#pragma mark - 截图
- (IBAction)clickSnipBtn:(id)sender {
    // 设置播放路径
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"minion_01.mp4" ofType:nil]];
    
    // 创建媒体资源对象 获取媒体文件信息
    AVAsset *asset = [AVAsset assetWithURL:url];
    // 创建媒体截图器
    AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    // 获取当前播放时间
    CMTime time = self.avplayerVc.player.currentTime;
    NSValue *timeValue = [NSValue valueWithCMTime:time];
    
    // 尽心截图
    [imgGenerator generateCGImagesAsynchronouslyForTimes:@[timeValue] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        // 同步回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.snipImgV.image = [UIImage imageWithCGImage:image];
        });
    }];
    
}

- (AVPlayer *)avplayer{
    if (_avplayer == nil) {
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"minion_01.mp4" ofType:nil]];
        
        // 创建媒体资源对象 媒体文件信息
        AVAsset *asset = [AVAsset assetWithURL:url];
        // 设置播放项目  设置播放状态
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithAsset:asset];
        
        _avplayer = [[AVPlayer alloc]initWithPlayerItem:item];
        
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avplayer];
        
        [self.view.layer addSublayer:layer];
        
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, 400);
        
    }
    return _avplayer;



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end

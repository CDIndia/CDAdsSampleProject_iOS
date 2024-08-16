//
//  ViewController.m
//  CDAdsSample
//
//  Created by Arun Gupta on 07/01/18.
//  Copyright © 2018 Arun Gupta. All rights reserved.
//

#import "ViewController.h"
#import <CDAds/CDAds.h>



@interface ViewController ()<CDAdViewDelegate>{
    CGRect frame;
    CDAdSize cdAdSize;
}
@property (weak, nonatomic) IBOutlet UIButton *load320_50Button;
@property (weak, nonatomic) IBOutlet UIButton *load300_250Banner;
@property (weak, nonatomic) IBOutlet UIButton *loadInterstitial;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *loadInterstitialVideo;
@property (strong, nonatomic) CDAdView *adView;        //keep Strong reference 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadingView.hidden = YES;
    _loadingView.layer.borderWidth = 1.0;
    _loadingView.layer.borderColor = [UIColor grayColor].CGColor;
    _loadingView.layer.cornerRadius = 4.0;
    _loadingView.layer.masksToBounds = YES;
    _load320_50Button.layer.cornerRadius = 4.0;
    _load320_50Button.layer.masksToBounds = YES;
    _load300_250Banner.layer.cornerRadius = 4.0;
    _load300_250Banner.layer.masksToBounds = YES;
    _loadInterstitial.layer.cornerRadius = 4.0;
    _loadInterstitial.layer.masksToBounds = YES;
    _loadInterstitialVideo.layer.cornerRadius = 4.0;
    _loadInterstitialVideo.layer.masksToBounds = YES;
    _load320_50Button.titleLabel.numberOfLines = 0;
    _load300_250Banner.titleLabel.numberOfLines = 0;
    _loadInterstitial.titleLabel.numberOfLines = 0;
    _loadInterstitialVideo.titleLabel.numberOfLines = 0;
    _load320_50Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _load300_250Banner.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loadInterstitial.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loadInterstitialVideo.titleLabel.textAlignment = NSTextAlignmentCenter;


    _adView = [CDAdView createAdViewWithDelegate:self];    //Create CDAdView
    [self.view addSubview:_adView];     //Add CDAdView to top view of your view controller

}

- (IBAction)load320_50Banner:(id)sender {
    _loadingView.hidden = NO;
    cdAdSize = kCDAdSizeBanner320x50;
    frame = CGRectMake((CGRectGetWidth(self.view.frame)-320)/2, (CGRectGetHeight(self.view.frame)-50)/2, 320, 50);
    [_adView getAdWithNotification];
}

- (IBAction)load300_250Banner:(id)sender {
    _loadingView.hidden = NO;
    cdAdSize = kCDAdSizeBanner300x250;
    frame = CGRectMake((CGRectGetWidth(self.view.frame)-300)/2, (CGRectGetHeight(self.view.frame)-250)/2, 300, 250);
    [_adView getAdWithNotification];
}

- (IBAction)loadInterstitial:(id)sender {
    _loadingView.hidden = NO;
    [_adView getInterstitialAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGRect)cdAdViewFrame:(CDAdView *)cdAdView {
    return frame;
}

- (CDAdSize) cdAdViewSize:(CDAdView*)cdAdView{
    return cdAdSize;
}

- (void)getAdFailed:(CDAdView *)cdAdView {
    if (frame.size.height == 50) {
        [self showErrorMessage:@"No Ads Available" withTitle:@"320x50"];
    }else{
        [self showErrorMessage:@"No Ads Available" withTitle:@"300x250"];
    }
    _loadingView.hidden = YES;
}

- (void)getAdSucceeded:(CDAdView *)cdAdView {
    _loadingView.hidden = YES;
}

- (void)getInterstitialAdFailed:(CDAdView *)cdAdView {
    [self showErrorMessage:@"No Ads Available" withTitle:@"Interstitial"];
    _loadingView.hidden = YES;
}

- (void)getInterstitialAdSucceeded:(CDAdView *)cdAdView {
    NSLog(@"getInterstitialAdSucceeded");
    [_adView displayInterstitial];
    _loadingView.hidden = YES;
}

- (void)interstitialActivated:(CDAdView *)cdAdView {

}

- (void)interstitialClosed:(CDAdView *)cdAdView {

}

- (UIViewController *)applicationUIViewController:(CDAdView *)cdAdView {
    return self;
}

- (NSString *)partnerId:(CDAdView *)cdAdView {
    return nil;
}

- (NSString *)siteId:(CDAdView *)cdAdView {
    return nil;
}

-(BOOL)locationServicesEnabled:(CDAdView *)cdAdView{
    return YES;
}

-(BOOL)useInAppBrowser:(CDAdView *)cdAdView{
    return YES;
}

- (NSString *)placementId:(CDAdView *)cdAdView {
    return @"0";
}


-(void)showErrorMessage:(NSString*)message withTitle:(NSString*)title{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* OkButton = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    [alert addAction:OkButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}

- (IBAction)loadInterstitialVideo:(id)sender {
    _loadingView.hidden = NO;
    [_adView getInterstitialVideoAd];
}

@end

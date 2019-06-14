//
//  ViewController.m
//  CDAdsExample
//
//  Created by Arun Gupta on 07/01/18.
//  Copyright © 2018 Arun Gupta. All rights reserved.
//

#import "ViewController.h"
#import <CDAds/CDAds.h>
#import <UserNotifications/UserNotifications.h>



@interface ViewController ()<CDAdViewDelegate, UNUserNotificationCenterDelegate, CDAdsDelegate>{
    CGRect frame;
}
@property (weak, nonatomic) IBOutlet UIButton *load320_50Button;
@property (weak, nonatomic) IBOutlet UIButton *load300_250Banner;
@property (weak, nonatomic) IBOutlet UIButton *loadInterstitial;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *loadInterstitialVideo;
@property (weak, nonatomic) IBOutlet UIButton *loadNativeVideo;
@property (strong, nonatomic) CDAdView *adView;        //keep Strong reference 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            [[NSUserDefaults standardUserDefaults] setBool:granted forKey:@"LocalNotificationPermission"];
        }];
    } else {
        // Fallback on earlier versions
    }
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
    _loadNativeVideo.layer.cornerRadius = 4.0;
    _loadNativeVideo.layer.masksToBounds = YES;
    _load320_50Button.titleLabel.numberOfLines = 0;
    _load300_250Banner.titleLabel.numberOfLines = 0;
    _loadInterstitial.titleLabel.numberOfLines = 0;
    _loadNativeVideo.titleLabel.numberOfLines = 0;
    _loadInterstitialVideo.titleLabel.numberOfLines = 0;
    _load320_50Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _load300_250Banner.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loadInterstitial.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loadInterstitialVideo.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loadNativeVideo.titleLabel.textAlignment = NSTextAlignmentCenter;


    _adView = [CDAdView createAdViewWithDelegate:self];    //Create CDAdView
    [self.view addSubview:_adView];     //Add CDAdView to top view of your view controller

}

- (IBAction)load320_50Banner:(id)sender {
    _loadingView.hidden = NO;
    frame = CGRectMake((CGRectGetWidth(self.view.frame)-320)/2, (CGRectGetHeight(self.view.frame)-50)/2, 320, 50);
    [_adView getAdWithNotification];
}

- (IBAction)load300_250Banner:(id)sender {
    _loadingView.hidden = NO;
    frame = CGRectMake((CGRectGetWidth(self.view.frame)-300)/2, (CGRectGetHeight(self.view.frame)-250)/2, 300, 250);
    [_adView getAdWithNotification];
}

- (IBAction)loadInterstitial:(id)sender {
    if (_loadingView) {
        _loadingView.hidden = NO;
    }
    [_adView getInterstitialAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGRect)cdAdViewFrame:(CDAdView *)cdAdView {
    return frame;
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
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Offer Avialable" message:@"Please open to see details." preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Called when user taps outside
            [alertController removeFromParentViewController];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Open" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self->_adView displayInterstitial];
                                                              [alertController removeFromParentViewController];
                                                          }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if (@available(iOS 10.0, *)) {
            UNMutableNotificationContent *notContent = [[UNMutableNotificationContent alloc] init];
            notContent.title = @"Offer Available";
            notContent.subtitle = @"Please open to see offer details";
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"logo" URL:[[NSBundle mainBundle] URLForResource:@"logo" withExtension:@"png"] options:nil error:nil];
            notContent.attachments = @[attachment];
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"popup" content:notContent trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
            
        }
        
    }
    if (_loadingView) {
        _loadingView.hidden = YES;
    }
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
    return NO;
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

- (IBAction)loadMrecVideo:(id)sender {
    _loadingView.hidden = NO;
    frame = CGRectMake((CGRectGetWidth(self.view.frame)-300)/2, (CGRectGetHeight(self.view.frame)-250)/2, 300, 250);
    [_adView getMRECVideoAd];
}

-(void)getMrecAdSucceeded:(CDAdView *)cdAdView{
    [_adView displayMrec];
}

-(void)getMrecAdFailed:(CDAdView *)cdAdView{
    _loadingView.hidden = YES;
    [self showErrorMessage:@"No Ads Available" withTitle:@"Mrec"];
}

- (void)mrecActivated:(CDAdView *)cdAdView {
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    [_adView displayInterstitial];
}


-(void)beaconDetected{
    [self loadInterstitial:nil];
}

-(CDAdSize)cdAdViewSize:(CDAdView *)cdAdView{
    return kCDAdSizeBanner320x50;
}

@end

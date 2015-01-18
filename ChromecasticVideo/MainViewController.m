//
//  MainViewController.m
//  ChromecasticVideo
//
//  Created by Ross Tang Him on 1/18/15.
//  Copyright (c) 2015 Ross Tang Him. All rights reserved.
//

#import "MainViewController.h"
#import "CastManager.h"
#import <SVSegmentedControl/SVSegmentedControl.h>

@interface MainViewController () <CastManagerDelegate>
@property (strong, nonatomic) UIBarButtonItem *castBarButtonItem;
@property (strong, nonatomic) UIImageView *castButtonImageView;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initalize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initalize 
-(void) initalize {
    [self initalizeSettingsButton];
    
    //Create cast button
    [self initalizeCastButton];
    
    [self initalizeTitle];
    
    self.tabBar.hidden = YES;
    

    
    [CastManager sharedInstance].delegate = self;
    
    //Set enabled/disabled on start if already scanned
    if ([CastManager deviceScanner].devices.count > 0) {
        self.castBarButtonItem.enabled = YES;
    } else {
        self.castBarButtonItem.enabled = NO;
    }
}

-(void) initalizeSettingsButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(settingsButtonPressed:)];
    
}
-(void) initalizeCastButton {
    NSArray *images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"cast_on0"],
                       [UIImage imageNamed:@"cast_on1"],
                       [UIImage imageNamed:@"cast_on2"],
                       nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:
                              [UIImage  imageNamed:@"cast_off"]];
    imageView.animationImages = images;
    imageView.animationDuration = 2.0;
    self.castButtonImageView = imageView;
    
    UIButton *castButton = [UIButton buttonWithType:UIButtonTypeCustom];
    castButton.bounds = imageView.bounds;
    [castButton addSubview:imageView];
    [castButton addTarget:self
               action:@selector(castButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    self.castBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: castButton];
    
    self.navigationItem.rightBarButtonItem = self.castBarButtonItem;
}

-(void) initalizeTitle {
    SVSegmentedControl *segmentedControl = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"Web", @"My Videos"]];
    __weak typeof(self) weakSelf = self;

    [segmentedControl setChangeHandler:^(NSUInteger newIndex){
        [weakSelf setSelectedIndex:newIndex];
    }];
    self.navigationItem.titleView = segmentedControl;
    
}



#pragma mark - castManagerDelegate
-(void) castDidFindDevices {
    self.castBarButtonItem.enabled = YES;
}
-(void) castDevicesDidDisappear {
    self.castBarButtonItem.enabled = NO;
}

-(void) castDidConnectWithDeviceManager:(GCKDeviceManager *)deviceManager {
    [self.castButtonImageView stopAnimating];
    [self.castButtonImageView setImage:[UIImage imageNamed:@"cast_on"]];
}

-(void) castDidDisconnectWithDeviceManager:(GCKDeviceManager *)deviceManager error: (NSError *) error {
    [UIView animateWithDuration:0.2 animations:^{
        self.castButtonImageView.alpha = 0.0;
    } completion:^(BOOL completed){
        [self.castButtonImageView setImage:[UIImage imageNamed:@"cast_off"]];
        [UIView animateWithDuration:0.2 animations:^{
            self.castButtonImageView.alpha = 1.0;
        }completion:nil];
    }];
}

#pragma mark - button press
- (void)castButtonPressed:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Connect to available Chromecasts" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    GCKDevice *connectedDevice = [CastManager connectedDevice];
    
    //Button for each device
    GCKDeviceScanner *deviceScanner = [CastManager deviceScanner];
    for (GCKDevice* device in deviceScanner.devices){
        if ([CastManager isConnected] && connectedDevice && [connectedDevice isEqual:device]) {
            continue;
        }
        [actionSheet addAction:
         [UIAlertAction
          actionWithTitle:device.friendlyName
          style:UIAlertActionStyleDefault
          handler:^(UIAlertAction *alertAction) {
              [self connectToDevice:device];
          }]];
    }
    
    if ([CastManager isConnected] && connectedDevice) {
        //Disconnect Button
        [actionSheet addAction:
         [UIAlertAction
          actionWithTitle:[NSString stringWithFormat:@"Disconnect %@",connectedDevice.friendlyName]
          style:UIAlertActionStyleDestructive
          handler:^(UIAlertAction *alertAction) {
              
              [self disconnect];
          }]];
    }

    
    //Cancel Button
    [actionSheet addAction:
     [UIAlertAction
      actionWithTitle:@"Cancel"
      style:UIAlertActionStyleCancel
      handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:^{
        
    }];
}

- (void)settingsButtonPressed:(id)sender {
    //Show settings
}
#pragma mark - castconnecting
-(void) connectToDevice:(GCKDevice *) device {
    [self.castButtonImageView startAnimating];
    [CastManager connectToDevice:device];
}

-(void) disconnect {
    [CastManager disconnect];
}

#pragma mark - web view 

    
@end

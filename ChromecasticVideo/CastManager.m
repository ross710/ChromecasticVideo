//
//  CastManager.m
//  ChromecasticVideo
//
//  Created by Ross Tang Him on 1/18/15.
//  Copyright (c) 2015 Ross Tang Him. All rights reserved.
//

#import "CastManager.h"

@interface CastManager() <GCKDeviceScannerListener, GCKDeviceManagerDelegate>
@property (nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property (nonatomic, strong) GCKDeviceManager *deviceManager;

@end

@implementation CastManager

#pragma mark - init
-(void) initalize {
    self.deviceScanner = [[GCKDeviceScanner alloc] init];
    
    GCKFilterCriteria *filterCriteria = [[GCKFilterCriteria alloc] init];
    //    filterCriteria = [GCKFilterCriteria criteriaForAvailableApplicationWithID:@"YOUR_APP_ID_HERE"];
    
    self.deviceScanner.filterCriteria = filterCriteria;
    
    [self.deviceScanner addListener:self];
    [self.deviceScanner startScan];
}

#pragma mark - sharedInstance
+ (CastManager*)sharedInstance {
    static CastManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!sharedInstance) {
            sharedInstance = [CastManager new];
            [sharedInstance initalize];
        }
    });
    return sharedInstance;
}
+ (GCKDeviceScanner *) deviceScanner {
    return [CastManager sharedInstance].deviceScanner;
}


#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {    
    if (self.delegate) {
        //Need to check if delegate can perform
        [self.delegate castDidFindDevices];
    }
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    if (self.deviceScanner.devices.count <= 0 && self.delegate) {
        //Need to check if delegate can perform
        [self.delegate castDevicesDidDisappear];
    }
}

#pragma mark - GCKDeviceManagerDelegate
- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    if (self.delegate) {
        [self.delegate castDidConnectWithDeviceManager:deviceManager];
    }
}
-(void) deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(NSError *)error {
    if (self.delegate) {
        [self.delegate castDidDisconnectWithDeviceManager:deviceManager error:error];
    }
}

#pragma mark - functions
-(void) connectToDevice: (GCKDevice *) device {
    self.deviceManager = [[GCKDeviceManager alloc] initWithDevice:device clientPackageName:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]];
    self.deviceManager.delegate = self;
    [self.deviceManager connect];
}
+(void) connectToDevice: (GCKDevice *) device {
    [[CastManager sharedInstance] connectToDevice:device];
}

+(BOOL) isConnected {
    return [[CastManager sharedInstance].deviceManager isConnected];
}
+(GCKDevice *) connectedDevice {
    return [CastManager sharedInstance].deviceManager.device;
}
+(void) disconnect {
    [[CastManager sharedInstance].deviceManager disconnect];
}
@end

//
//  CastManager.h
//  ChromecasticVideo
//
//  Created by Ross Tang Him on 1/18/15.
//  Copyright (c) 2015 Ross Tang Him. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleCast/GoogleCast.h>

@protocol CastManagerDelegate
@required
-(void) castDidFindDevices;
-(void) castDevicesDidDisappear;
-(void) castDidConnectWithDeviceManager:(GCKDeviceManager *)deviceManager;
-(void) castDidDisconnectWithDeviceManager:(GCKDeviceManager *)deviceManager error: (NSError *) error;

@end

@interface CastManager : NSObject
@property(strong,nonatomic)id<CastManagerDelegate> delegate;

+ (CastManager*)sharedInstance;
+ (GCKDeviceScanner *) deviceScanner;

+(void) connectToDevice: (GCKDevice *) device;
+(BOOL) isConnected;
+(GCKDevice *) connectedDevice;
+(void) disconnect;
@end

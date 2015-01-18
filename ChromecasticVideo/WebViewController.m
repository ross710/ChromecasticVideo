//
//  WebViewController.m
//  ChromecasticVideo
//
//  Created by Ross Tang Him on 1/18/15.
//  Copyright (c) 2015 Ross Tang Him. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self goHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goHome {
    
    [self.webView loadRequest:[NSURLRequest
                               requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
    
}
@end

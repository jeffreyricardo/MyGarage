//
//  ViewController.m
//  MyGarage
//
//  Created by Jeffrey Ricardo on 6/15/15.
//  Copyright (c) 2015 Jeffrey Ricardo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://jeffreyricardo.dyndns.org:1234"];
    [_camWebView loadHTMLString:@"<img src=\"%@\"/>" baseURL:url];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_camWebView reload];
}
@end

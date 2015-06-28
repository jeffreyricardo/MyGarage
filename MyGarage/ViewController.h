//
//  ViewController.h
//  MyGarage
//
//  Created by Jeffrey Ricardo on 6/15/15.
//  Copyright (c) 2015 Jeffrey Ricardo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *camWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIButton *btnOpenClose;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@end


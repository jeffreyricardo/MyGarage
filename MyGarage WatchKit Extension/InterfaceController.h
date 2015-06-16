//
//  InterfaceController.h
//  MyGarage WatchKit Extension
//
//  Created by Jeffrey Ricardo on 6/15/15.
//  Copyright (c) 2015 Jeffrey Ricardo. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblStatus;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *btnOpenClose;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *btnReset;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *btnRefresh;

@end

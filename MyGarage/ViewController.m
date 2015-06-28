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

NSString *username = @"";
NSString *password = @"";
NSString *serverAddress = @"";
NSString *camPort = @"8081";
NSString *webiopiPort = @"8000";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:90.0/255 green:200.0/255 blue:250.0/255 alpha:1];
    [_btnOpenClose setBackgroundColor:[UIColor colorWithRed:0 green:122.0/255 blue:1 alpha:1]];
    [_btnRefresh setBackgroundColor:[UIColor colorWithRed:88.0/255 green:86.0/255 blue:214.0/255 alpha:1]];
    [_btnReset setBackgroundColor:[UIColor colorWithRed:250.0/0 green:140.0/255 blue:90.0/255 alpha:1]];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@", serverAddress, camPort];
    NSURL *url = [NSURL URLWithString:urlString];
    [_camWebView loadHTMLString:@"<img src=\"%@\"/>" baseURL:url];
    
    NSString *html = [_camWebView stringByEvaluatingJavaScriptFromString:@"document.images"];
    NSLog(@"HTML is: %@", html);
    
    [self checkSensorValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[_camWebView reload];
    //[self checkSensorValue];
}

- (IBAction)openClose:(id)sender
{
    NSLog(@"OpenClose Pressed");
    [self sendHighToPi];
    [self checkSensorValue];
}

- (IBAction)refresh:(id)sender
{
    [self checkSensorValue];
}

- (IBAction)reset:(id)sender
{
    NSLog(@"Reset Pressed");
    [self sendLowToPi];
    [self checkSensorValue];
}

- (void)checkSensorValue
{
    NSLog(@"Inside checkSensorValue");
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", serverAddress, webiopiPort, @"/GPIO/22/value"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [req setHTTPMethod:@"GET"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error == nil)
        {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response is: %@", responseStr);
            
            if ([responseStr intValue] == 0)
            {
                NSLog(@"Garage is CLOSED");
                [_lblStatus setText:@"Garage is: CLOSED"];
                [_btnOpenClose setBackgroundColor:[UIColor colorWithRed:76.0/255 green:217.0/255 blue:100.0/255 alpha:1.0]];
                [_btnOpenClose setTitle:@"Open" forState:UIControlStateNormal];
            }
            if ([responseStr intValue] == 1)
            {
                NSLog(@"Garage is OPEN");
                [_lblStatus setText:@"Garage is: OPEN"];
                [_btnOpenClose setBackgroundColor:[UIColor colorWithRed:255.0/255 green:45.0/255 blue:85.0/255 alpha:1]];
                [_btnOpenClose setTitle:@"Close" forState:UIControlStateNormal];
            }
        }
        else
        {
            NSLog(@"ERROR %@", [error description]);
        }
    }];
    
    [dataTask resume];
}

- (void)sendLowToPi
{
    NSLog(@"Sending LOW to Pi");
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", serverAddress, webiopiPort, @"/GPIO/23/value/0"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [req setHTTPMethod:@"POST"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil)
        {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response is: %@", responseStr);
            
            if ([responseStr intValue] == 0)
            {
                NSLog(@"Garage is CLOSED");
                
            }
            if ([responseStr intValue] == 1)
            {
                NSLog(@"Garage is OPEN");
                
            }
        }
        else
        {
            NSLog(@"ERROR %@", [error description]);
        }
    }];
    
    [dataTask resume];
}

- (void)sendHighToPi
{
    NSLog(@"Sending HIGH to Pi");
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", serverAddress, webiopiPort, @"/GPIO/23/value/1"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [req setHTTPMethod:@"POST"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil)
        {
            NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response is: %@", responseStr);
            
            if ([responseStr intValue] == 0)
            {
                NSLog(@"Garage is CLOSED");
                
            }
            if ([responseStr intValue] == 1)
            {
                NSLog(@"Garage is OPEN");
                
            }
        }
        else
        {
            NSLog(@"ERROR %@", [error description]);
        }
    }];
    
    [dataTask resume];
}

@end

//
//  InterfaceController.m
//  MyGarage WatchKit Extension
//
//  Created by Jeffrey Ricardo on 6/12/15.
//  Copyright (c) 2015 Jeffrey Ricardo. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end

NSURLSession *session = nil;
NSMutableData *receivedData = nil;
NSString *responseStr = nil;
NSString *username = @"";
NSString *password = @"";
NSString *serverAddress = @"";
NSString *camPort = @"8081";
NSString *webiopiPort = @"8000";

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    session = [NSURLSession sharedSession];
    
    [_btnReset setTitle:@"Reset"];
    [_btnRefresh setTitle:@"Refresh"];
    [self checkSensorValue];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)checkSensorValue
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", serverAddress, webiopiPort, @"/GPIO/22/value"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [req setHTTPMethod:@"GET"];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [req setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response is: %@", responseStr);
        
        if ([responseStr isEqualToString:@"0"])
        {
            NSLog(@"Garage is CLOSED");
            [_lblStatus setText:@"Garage is: CLOSED"];
            [_btnOpenClose setBackgroundColor:[UIColor greenColor]];
            [_btnOpenClose setTitle:@"OPEN GARAGE"];
        }
        if ([responseStr isEqualToString:@"1"])
        {
            NSLog(@"Garage is OPEN");
            [_lblStatus setText:@"Garage is: OPEN"];
            [_btnOpenClose setBackgroundColor:[UIColor redColor]];
            [_btnOpenClose setTitle:@"CLOSE GARAGE"];
        }
        
    }];
    
    [dataTask resume];
}

- (IBAction)openClose:(id)sender
{
    NSLog(@"Button Pressed");
    
    [self sendHighToPi];
    
    [self checkSensorValue];
}

- (IBAction)resetGpio
{
    NSLog(@"Resetting GPIO");
    
    [self sendLowToPi];
    
    [self checkSensorValue];
}

- (IBAction)refreshUI
{
    NSLog(@"Refreshing Screen");
    
    [self checkSensorValue];
}

- (void)sendHighToPi
{
    NSLog(@"Sending HIGH to Pi");
    
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

- (void)sendLowToPi
{
    NSLog(@"Sending LOW to Pi");
    
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



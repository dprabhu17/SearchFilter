//
//  Utility.m
//  API
//
//  Created by Boobalan on 12/11/15.
//  Copyright © 2015 train. All rights reserved.
//

#import "Utility.h"

@implementation Utility

-(void)showLoader:(UIView *)view{
    
    activityView = [[UIActivityIndicatorView alloc]
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = view.center;
    [activityView startAnimating];
    activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:activityView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}

//set leftpadding for textfield
-(void) setPadding :(UITextField *) textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}


- (void) hideLoader {
    
    [activityView removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

- (void) sendHTTPRequest:(NSString *) urlString forView:(UIView *) view withCallback:(completionBlock)callback{
    
    [self showLoader:view];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[[NSOperationQueue alloc] init]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
    
         NSMutableArray *json = nil;
         if ([data length] >0 && error == nil)
         {
             json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error = %@", error);
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             [self hideLoader];
             callback(json);
         });
         
     }];
    
}

- (BOOL) isInternetConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}


-(void) setEmptyMessageForTable :(NSString *) message forTable:(UITableView *) tableView
{
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Futura" size:14];
    
    [messageLabel sizeToFit];
    //set the message to specified table
    tableView.tableFooterView = messageLabel;
    
}
- (void) removeEmptyMessageForTable :(UITableView *) tableView
{
    tableView.tableFooterView = nil;
}


@end

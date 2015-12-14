//
//  Utility.h
//  API
//
//  Created by Boobalan on 12/11/15.
//  Copyright © 2015 train. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

//API's
#define API_URL @"https://api.myjson.com/bins/2ggcs";


@interface Utility : NSObject{
   UIActivityIndicatorView *activityView;
}

typedef void(^completionBlock)(NSMutableArray *);

- (void) showLoader:(UIView *)view;
- (void) hideLoader;
- (void) sendHTTPRequest:(NSString *) urlString forView:(UIView *) view withCallback:(completionBlock)callback;
- (void) setPadding :(UITextField *) textField;
- (BOOL) isInternetConnected;
- (void) setEmptyMessageForTable :(NSString *) message forTable:(UITableView *) tableView;
- (void) removeEmptyMessageForTable :(UITableView *) tableView;

@end

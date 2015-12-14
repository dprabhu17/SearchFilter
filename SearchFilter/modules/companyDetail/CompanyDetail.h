//
//  CompanyDetail.h
//  SearchFilter
//
//  Created by vis-1041 on 12/14/15.
//  Copyright © 2015 vis-1041. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyDetail : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UITextView *depatments;
@property (strong, nonatomic) NSDictionary *selectedCompany;

//buttons
@property (strong, nonatomic) IBOutlet UIButton *backToHome;
- (IBAction)backToHome:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *contentSize;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

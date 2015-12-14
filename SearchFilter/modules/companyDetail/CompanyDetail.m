//
//  CompanyDetail.m
//  SearchFilter
//
//  Created by vis-1041 on 12/14/15.
//  Copyright © 2015 vis-1041. All rights reserved.
//

#import "CompanyDetail.h"

@interface CompanyDetail (){
}

@end

@implementation CompanyDetail

//fields
@synthesize companyName,ownerName,startDate,description,depatments,selectedCompany,scrollView,contentSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Selected Company : %@",selectedCompany);
    [self loadData];

    //set scrollView
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


//load the data
-(void) loadData
{
    if(selectedCompany != nil){
        [self.companyName setText:[selectedCompany objectForKey:@"comapnyName"]];
        [self.ownerName setText:[selectedCompany objectForKey:@"companyOwner"]];
        [self.startDate setText:[selectedCompany objectForKey:@"companyStartDate"]];
        [self.description setText:[selectedCompany objectForKey:@"companyDescription"]];
        [self.depatments setText:[selectedCompany objectForKey:@"companyDepartments"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

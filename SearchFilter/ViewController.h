//
//  ViewController.h
//  SearchFilter
//
//  Created by vis-1041 on 12/14/15.
//  Copyright © 2015 vis-1041. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDataSource,UITextFieldDelegate>{
    
    NSMutableArray *companiesList, *dataToShow, *filterList;
    NSMutableOrderedSet *departmentsList, *selectedFilterList;
    Utility *util;
    bool isFilterEnabled, isSearchEnabled;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
- (IBAction)filterAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *filterPopup;
@property (strong, nonatomic) IBOutlet UITableView *filterTable;
@property (strong, nonatomic) IBOutlet UIButton *clearFilterButton;
- (IBAction)clearFilterAction:(id)sender;

@end

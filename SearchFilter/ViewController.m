//
//  ViewController.m
//  SearchFilter
//
//  Created by vis-1041 on 12/14/15.
//  Copyright © 2015 vis-1041. All rights reserved.
//

#import "ViewController.h"
#import "CompanyDetail.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize searchField, filterButton,filterPopup,filterTable,clearFilterButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    util = [[Utility alloc] init];
    companiesList = [[NSMutableArray alloc] init];
    dataToShow = [[NSMutableArray alloc] init];
    filterList = [[NSMutableArray alloc] init];
    departmentsList = [[NSMutableOrderedSet alloc] init];
    selectedFilterList = [[NSMutableOrderedSet alloc] init];
    isFilterEnabled = isSearchEnabled = false;
    
    [self designTheView];
}

//design the UI and load required Data
- (void) designTheView {
  
    //Hide empty rows
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.filterTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getDataFromServer];
    
    [searchField addTarget:self action:@selector(filterBySearchWord:) forControlEvents:UIControlEventEditingChanged];
    
    //set padding for textfield
    [util setPadding:self.searchField];
    //filter button design
    filterButton.layer.cornerRadius = 10;
    filterButton.layer.masksToBounds = YES;
    //filter button design
    clearFilterButton.layer.cornerRadius = 10;
    clearFilterButton.layer.masksToBounds = YES;

    //hide show filters
    [self hideFilters:TRUE];
    
    self.searchField.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//Load the initial data
-(void) getDataFromServer{
    
    if([util isInternetConnected]){
        [util sendHTTPRequest:@"https://api.myjson.com/bins/2ggcs" forView:self.view withCallback:^(NSMutableArray *response) {
            
            if(response != nil && [response count] > 0)
                companiesList = dataToShow = response;
            
            NSLog(@"response Data count: %d",[companiesList count]);
            [self getCategories];
            [self reloadTableData];
        }];
    }
    else{
        [self reloadTableData];
    }
}

//hide/Show filter buttons
- (void) hideFilters :(BOOL) state{

    [self.clearFilterButton setHidden:([selectedFilterList count] == 0)];
    [self.filterButton setHidden:state];
    
}

//Filter the table by searched Text
- (void) filterBySearchWord:(UITextField *)searchText{
    
    //Check filter is enabled
    if(isFilterEnabled){
        //Search in filterList
        //Check search word is empty
        NSString *string = [[searchField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([string length] > 0 ){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"comapnyName CONTAINS[c] %@", string];
            dataToShow = [[filterList filteredArrayUsingPredicate:predicate] mutableCopy];
            NSLog(@"%@",dataToShow);
        }
    }
    else{
        //Search in companylist
        //Check search word is empty
        NSString *string = [[searchField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([string length] > 0 ){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"comapnyName CONTAINS[c] %@", string];
            dataToShow = [[companiesList filteredArrayUsingPredicate:predicate] mutableCopy];
            NSLog(@"%@",dataToShow);
        }
        else{
            dataToShow = companiesList;
        }
        
    }
    [self reloadTableData];
}

//load required categories
- (void) getCategories {
    
    for (id companyInfo in companiesList) {
        
        NSDictionary *company = (NSDictionary *) companyInfo;
        NSString *departmentString = [[company objectForKey:@"companyDepartments"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([departmentString length] > 0){
            NSArray *departments= [departmentString componentsSeparatedByString:@", "];
            NSLog(@"DepartMens %@",departments);
            
            [departmentsList addObjectsFromArray:departments];
        }
        
    }
    NSLog(@"DepartMent list : %@",departmentsList);
    
}

//perform action for the filter button
- (IBAction)filterAction:(id)sender {
    
    if(filterButton.tag == 0){ //need to show filter
        [filterPopup setHidden:NO];
        [filterTable reloadData];
        filterButton.tag = 1; //For close the filter
        [filterButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    }
    else if(filterButton.tag == 1){
        [filterPopup setHidden:YES];
        filterButton.tag = 0; //For open the filter
        dataToShow = companiesList;
        [self reloadTableData];
        [filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    }
    else if(filterButton.tag == 2){
        [self reloadTableData];
        filterButton.tag = 0; //For open the filter
        [filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
        
        //Filter the result from the companylist
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings) {
            NSDictionary *company = (NSDictionary *)evaluatedObject;
            NSArray *departments= [[company valueForKey:@"companyDepartments"] componentsSeparatedByString:@", "];
            
            NSMutableSet *matched = [NSMutableSet setWithArray:departments];
            [matched intersectSet:[NSSet setWithArray:[selectedFilterList array]]];
            
            return [matched count] > 0 ? TRUE : FALSE;
        }];
        
        filterList = [[companiesList filteredArrayUsingPredicate:predicate] mutableCopy];
        dataToShow = filterList;
        NSLog(@"Filter %@",dataToShow);
        [self reloadTableData];
    
        //Hide the filter
        [filterPopup setHidden:YES];
        
    }
    
}



//Table view delegate methods
//Return number of rows in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.tableView) ? [dataToShow count] : [departmentsList count];
}

//return how table view cell would be
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    if(tableView == self.tableView){
        
        NSString *cellIdentifier = @"companyCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSDictionary *comapnyInfo = [dataToShow objectAtIndex:indexPath.row];
        
        //init tableview cell info
        UILabel *companyName = (UILabel *) [cell viewWithTag:10];
        UILabel *companyOwner = (UILabel *) [cell viewWithTag:11];
        
        
        [companyName setText:[comapnyInfo objectForKey:@"comapnyName"]];
        [companyOwner setText:[comapnyInfo objectForKey:@"companyOwner"]];
        
    }
    else{
        
        NSString *cellIdentifier = @"filterCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //init tableview cell info
        UILabel *departmentName = (UILabel *) [cell viewWithTag:10];
        UIImageView *image = (UIImageView *) [cell viewWithTag:11];
        
        if([selectedFilterList containsObject:[departmentsList objectAtIndex:indexPath.row]])
            [image setImage:[UIImage imageNamed:@"tick.png"]];
        else
            [image setImage:[UIImage imageNamed:@"untick.png"]];
        
        [departmentName setText:[departmentsList objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
    
}

//reload the table view
-(void) reloadTableData{
    
    NSString *message = ([util isInternetConnected])? @"No data found" : @"Internet not found";
    if([dataToShow count] == 0){
        [util setEmptyMessageForTable:message forTable:self.tableView];
        [self hideFilters:TRUE];
    }
    else{
        [util removeEmptyMessageForTable:self.tableView];
        [self hideFilters:FALSE];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    [self.tableView reloadData];

}

//Add click event to table row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView){

        //display company detail in a seperate view
        CompanyDetail *detailPage = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyDetail"];
        detailPage.selectedCompany = [dataToShow objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailPage animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    else{
        
        //check already the deparment present in the list
        NSString *department = [departmentsList objectAtIndex:indexPath.row];
        if([selectedFilterList containsObject:department]){
            [selectedFilterList removeObjectAtIndex:[selectedFilterList indexOfObject:department]];
        }
        else{
            [selectedFilterList addObject:department];
        }
        if([selectedFilterList count] > 0 ){
            isFilterEnabled = TRUE;
            filterButton.tag = 2;
            [filterButton setImage:[UIImage imageNamed:@"apply.png"] forState:UIControlStateNormal];
        }
        else{
            isFilterEnabled = FALSE;
            filterButton.tag = 1;
            [filterButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        }
        
        //Reload the clicked row
        [filterTable  beginUpdates];
        [filterTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [filterTable endUpdates];
        
        //hide/show the filter button
        [self.clearFilterButton setHidden:([selectedFilterList count] == 0)];

    }
    
}

//done buttonaction
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [searchField resignFirstResponder];
    return YES;
}

//clear the filters and show all company details
- (IBAction)clearFilterAction:(id)sender {

    [selectedFilterList removeAllObjects];
    [self.clearFilterButton setHidden:([selectedFilterList count] == 0)];
    
    //reload all data
    dataToShow = companiesList;
    isFilterEnabled = FALSE;
    
    //reload the table views
    [self reloadTableData];
    [filterTable reloadData];

    if(filterButton.tag == 2){
        filterButton.tag = 1;
        [filterButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    }
    else{
        filterButton.tag = 0;
        [filterButton setImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    }
    

}
@end

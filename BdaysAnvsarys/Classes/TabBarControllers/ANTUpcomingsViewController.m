//
//  ANTFirstViewController.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 10/17/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTUpcomingsViewController.h"

@interface ANTUpcomingsViewController ()

@end

@implementation ANTUpcomingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.buddiesArray = [ANTDataManager fetchMyBuddiesForDay:eBirthDay isUpcomingOnly:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kBuddyNotificationIdentifier object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kUpcomingEventRefreshIdentifier object:nil];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, kSearchBarHeight)];
    [self.searchBar setDelegate:self];

    self.tableView.contentInset = UIEdgeInsetsMake(-kSearchBarHeight, 0, 0, 0);
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+kSearchBarHeight);

    [self filterBuddiesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(IBAction)valueChanged:(id)sender{
    if([self.segment selectedSegmentIndex]==eBirthDay){
        self.buddiesArray = [ANTDataManager fetchMyBuddiesForDay:eBirthDay isUpcomingOnly:YES];
    }else{      // if([self.segment selectedSegmentIndex]==eAnniversary)
        self.buddiesArray = [ANTDataManager fetchMyBuddiesForDay:eAnniversary isUpcomingOnly:YES];
    }
    [self filterBuddiesArray];
    [self.tableView reloadData];
}

#pragma mark - Selector

-(void)refreshData:(id)sender{
    self.buddiesArray = [ANTDataManager fetchMyBuddiesForDay:self.segment.selectedSegmentIndex isUpcomingOnly:YES];
    [self filterBuddiesArray];
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.buddiesFilteredArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ANTCustomCell *cell = (ANTCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"All" forIndexPath:indexPath];
    if(cell!=nil){
        ANTMyBuddy *buddy = [self.buddiesFilteredArray objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *date = [buddy date];

        cell.titleText.text = [NSString stringWithFormat:@"%@ %@",[buddy firstName],[buddy lastName]];
        cell.detailText.text = [ANTDataManager howOldMyBuddyIs:buddy.date];

        [formatter setDateFormat:@"dd"];
        cell.dayText.text = [formatter stringFromDate:date];

        [formatter setDateFormat:@"MMM"];
        cell.monthText.text = [formatter stringFromDate:date];

        [formatter setDateFormat:@"yyyy"];
        cell.yearText.text = [formatter stringFromDate:date];
    }

    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.searchBar isFirstResponder])
        [self.searchBar resignFirstResponder];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [ANTDataManager deleteBuddy:[self.buddiesArray objectAtIndex:indexPath.row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAllEventRefreshIdentifier object:self];
        [self.buddiesFilteredArray removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

#pragma mark - Scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if([self.searchBar isFirstResponder])
        [self.searchBar resignFirstResponder];

    if(scrollView.contentOffset.y>=0)
        self.tableView.contentInset = UIEdgeInsetsMake(-MIN(kSearchBarHeight, scrollView.contentOffset.y), 0, 0, 0);
    //    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height+30);
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filterBuddiesArray];
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Private

-(void)filterBuddiesArray{
    if([self.searchBar.text isEqualToString:@""]){
        self.buddiesFilteredArray = self.buddiesArray;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@",self.searchBar.text,self.searchBar.text];
        self.buddiesFilteredArray = [NSMutableArray arrayWithArray:[self.buddiesArray filteredArrayUsingPredicate:predicate]];
    }
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:kEditBuddySegue]){
        ANTAddViewController *addViewController = (ANTAddViewController*)[segue destinationViewController];
        NSInteger rowNumber = [[self.tableView indexPathForSelectedRow] row];
        [addViewController setBuddy:[self.buddiesFilteredArray objectAtIndex:rowNumber]];
        [addViewController addUpdateButton];
    }
}

@end

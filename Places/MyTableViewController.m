//
//  MyTableViewController.m
//  Places
//
//  Created by Daniil Novoselov on 24.12.15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "MyTableViewController.h"
#import "CustomTableViewCell.h"
#import "PLCGoogleMapService.h"
#import "PLCPlace.h"
#import <AFNetworking.h>

@interface MyTableViewController ()
@property (strong, nonatomic) NSArray *placesArray;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *placesTableView;
@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refresh = [UIRefreshControl new];
    [_placesTableView addSubview:self.refresh];
    
    _placesArray = [NSArray new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWithKeyword:(NSString *)keyword {
    [_placesTableView setUserInteractionEnabled:NO];
    [_placesTableView setContentOffset:CGPointMake(0, -_refresh.frame.size.height) animated:YES];
    [_refresh beginRefreshing];
    
    [[PLCGoogleMapService new] getNearbyPlacesForKeyword:keyword success:^(id results) {
        _placesArray = [results copy];
        [_placesTableView reloadData];
        [_refresh endRefreshing];
        [_placesTableView setUserInteractionEnabled:YES];
    } failure:^(NSError *error) {
        [self showAlertWithError:error];
        
        [_placesTableView reloadData];
        [_refresh endRefreshing];
        [_placesTableView setUserInteractionEnabled:YES];
    }];
    
}

- (void)showAlertWithError:(NSError *)error {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:error.localizedDescription
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _placesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomTableCell";
    CustomTableViewCell *cell = (CustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PLCPlace *place = [_placesArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = place.name;
    cell.addressLabel.text = place.address;
//    [cell.imageView setImageWithURL:[NSURL URLWithString:place.imageURL] placeholderImage:[UIImage imageNamed:@"no_photo.jpg"]];
    
    if (place.imageURL) {
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:place.imageURL]]];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIImage *img = responseObject;
            [cell.imageView setImage:img];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"no_photo.jpg"]];
    }
    
    return cell;
}

#pragma mark - Search bar methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [_placesTableView setBackgroundColor:[UIColor darkGrayColor]];
    [self loadWithKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}


@end

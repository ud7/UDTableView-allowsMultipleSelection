//
//  ViewController.m
//  UDTableViewDemo
//
//  Created by Yasuhiro Inami on 12/03/13.
//  Copyright (c) 2012 Yasuhiro Inami. All rights reserved.
//

#import "YIViewController.h"
#import "UDTableView.h"


@implementation YIViewController


#pragma mark - 
#pragma mark UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem: self.editButtonItem];
    
    UDTableView *tableView = [[UDTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
    [tableView setAllowsMultipleSelection: YES];
    [tableView setAllowsMultipleSelectionDuringEditing: NO];

    [self setTableView: tableView];
    [tableView release];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    [cell.textLabel setText: [NSString stringWithFormat:@"Row #%i", indexPath.row]];
    
    return cell;
}


@end

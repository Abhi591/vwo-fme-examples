/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "LogsViewController.h"

@interface LogsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *clearButton;
@property (nonatomic, strong) UIBarButtonItem *exportButton;

@end

@implementation LogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logs = [[NSMutableArray alloc] init];
    [self setupTableView];
    // Setup navigation
    [self setupNavigation];
    
    // Initialize logs array
    self.logs = [[NSMutableArray alloc] init];
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get logs from delegate if available
    if (self.delegate && [self.delegate respondsToSelector:@selector(getLogsForLogsViewController)]) {
        NSArray *delegateLogs = [self.delegate getLogsForLogsViewController];
        if (delegateLogs && delegateLogs.count > 0) {
            [self.logs removeAllObjects];
            [self.logs addObjectsFromArray:delegateLogs];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setup Methods

- (void)setupNavigation {
    self.title = @"VWO FME Logs";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Clear button
    self.clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" 
                                                        style:UIBarButtonItemStylePlain 
                                                       target:self 
                                                       action:@selector(clearLogs)];
    
    // Export button
    self.exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" 
                                                         style:UIBarButtonItemStylePlain 
                                                        target:self 
                                                        action:@selector(exportLogs)];
    
    self.navigationItem.rightBarButtonItems = @[self.clearButton, self.exportButton];
}

- (void)setupTableView {
    // Create table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Register cell class
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LogCell"];
    
    // Add to view
    [self.view addSubview:self.tableView];
    
    // Setup table view appearance
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
}



#pragma mark - Public Methods



// MARK: - External Log Setting



#pragma mark - Action Methods

- (void)clearLogs {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear Logs" 
                                                                   message:@"Are you sure you want to clear all logs?" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"Clear" 
                                                           style:UIAlertActionStyleDestructive 
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self.logs removeAllObjects];
        [self.tableView reloadData];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:clearAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exportLogs {
    if (self.logs.count == 0) {
        [self showAlertWithTitle:@"No Logs" message:@"There are no logs to export."];
        return;
    }
    
    // Create log text
    NSMutableString *logText = [[NSMutableString alloc] init];
    [logText appendString:@"VWO FME Logs Export\n"];
    [logText appendString:@"==================\n\n"];
    
    for (NSString *log in self.logs) {
        [logText appendFormat:@"%@\n", log];
    }
    
    // Share logs
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[logText] applicationActivities:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.barButtonItem = self.exportButton;
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell" forIndexPath:indexPath];
    
    NSString *logMessage = self.logs[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = logMessage;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor labelColor];
    
    // Configure cell style
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor systemBackgroundColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *logMessage = self.logs[indexPath.row];
    
    // Show log details
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Details" 
                                                                   message:logMessage 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy" 
                                                         style:UIAlertActionStyleDefault 
                                                       handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = logMessage;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    
    [alert addAction:copyAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.logs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

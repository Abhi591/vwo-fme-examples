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

#import "ViewController.h"
#import <VWO_FME/VWO_FME.h>
#import "FmeExample-Swift.h"
#import "LogsViewController.h"

/**
 * Private interface extension for ViewController
 * Contains all UI element outlets and private properties
 */
@interface ViewController ()

// MARK: - UI Element Outlets
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;      // Input field for user ID entry
@property (weak, nonatomic) IBOutlet UITextField *searchQueryTF;        // Input field for feature flag key
@property (weak, nonatomic) IBOutlet UITextView *DescriptionTV;        // Text view for feature description (hidden by default)
@property (weak, nonatomic) IBOutlet UILabel *flagStatusLabel;          // Label displaying feature flag status
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;              // Label displaying current user ID
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decriptionHeightConstraint; // Height constraint for description text view

@end

@implementation ViewController

// MARK: - Global Variables
VWOUserContext *user;        // Stores the current VWO user context for feature flag evaluation
GetFlag *getFlag;            // Stores the retrieved feature flag result for further processing

/**
 * Called when the view controller's view is loaded into memory
 * Performs initial setup of VWO FME SDK and UI elements
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize VWO FME SDK with configuration
    [self initializeVWO];
    
    // Setup UI elements with default values and configuration
    [self SetupView];
}
/**
 * Configures the initial state of UI elements
 * Sets default text values and initial visibility states
 */
- (void)SetupView {
    // Set default search query from constants
    self.searchQueryTF.text = [VWOConstants searchQuery];
    
    // Set default bot response text for description
    self.DescriptionTV.text = [VWOConstants DefaultBotResponse];
    
    // Initially hide the description text view (will be shown after feature flag check)
    self.DescriptionTV.hidden = true;
}

/**
 * Action method triggered when user assigns or generates a user ID
 * Creates VWO user context for feature flag evaluation and personalization
 * 
 * @param sender The button that triggered this action
 */
- (IBAction)AssignUserIdAction:(id)sender {
    // Get user ID from text field input
    NSString *userID = self.userIDTextField.text;
    
    if (userID.length > 0) {
        // User provided a custom ID - create context with custom variables
        NSDictionary *dict = @{
            @"name" : @"Prince",    // User's name for personalization
            @"age"  : @27,          // User's age for targeting
            @"isDev": @YES          // Developer flag for feature access
        };
        
        // Create VWO user context with custom variables for targeted feature flags
        user = [[VWOFMEManager shared] vwoUserContextWithId:userID customVariables:dict];
        
        // Update UI to show current user ID
        self.userIDLabel.text = [NSString stringWithFormat:@"User ID: %@", userID];
        
        // Log the user context creation for debugging
        [[VWOFMEManager shared] addLogFromObjectiveC:[NSString stringWithFormat:@"User context created for ID: %@", userID]];
        
    } else {
        // No user ID provided - generate a random one for testing
        self.userIDTextField.text = [self generateRandomUserId];
        NSString *inputText = self.userIDTextField.text ?: @"";
        
        // Update UI to show generated user ID
        self.userIDLabel.text = [NSString stringWithFormat:@"User ID: %@", inputText];
        
        // Log the random user ID generation for debugging
        [[VWOFMEManager shared] addLogFromObjectiveC:[NSString stringWithFormat:@"Random user ID generated: %@", inputText]];
    }
}

/**
 * Action method triggered when user clicks the send button
 * Tests feature flags using VWO FME SDK and shows results
 * 
 * @param sender The button that triggered this action
 */
- (IBAction)sendAction:(id)sender {
    // Get the search query (feature flag key) from text field
    NSString *searchQuery = self.searchQueryTF.text;
    
    if (searchQuery.length > 0) {
        // User provided a custom feature flag key - test with custom context
        VWOUserContext *context = [[VWOFMEManager shared] vwoUserContextWithId:@"user123" customVariables:@{}];
        NSString *featureKey = searchQuery;
        
        // Request feature flag status from VWO FME SDK
        [[VWOFMEManager shared] getFlagWithFeatureKey:featureKey context:context completion:^(GetFlag *flag) {
            // Update UI with feature flag status
            self.flagStatusLabel.text = @"Feature Flag Status: Enabled";
            
            // Store flag result for further processing
            getFlag = flag;
            
            // Show the description text view after feature flag check
            self.DescriptionTV.hidden = false;
        }];
        
    } else {
        // No search query provided - use default flag key from constants
        VWOUserContext *context = [[VWOFMEManager shared] vwoUserContextWithId:@"123" customVariables:@{}];
        NSString *featureKey = [VWOConstants flagKey];
        
        // Request default feature flag status from VWO FME SDK
        [[VWOFMEManager shared] getFlagWithFeatureKey:featureKey context:context completion:^(GetFlag *flag) {
            // Update UI with feature flag status
            self.flagStatusLabel.text = @"Feature Flag Status: Enabled";
            
            // Store flag result for further processing
            getFlag = flag;
            
            // Show the description text view after feature flag check
            self.DescriptionTV.hidden = false;
        }];
    }
}

/**
 * Initializes the VWO FME SDK with configuration
 * Called during app startup to prepare the SDK for feature flag operations
 */
- (void)initializeVWO {
    // Initialize VWO FME SDK with account configuration
    [[VWOFMEManager shared] VWOFMEinitialize];
    
    // Log the initialization for debugging purposes
    [[VWOFMEManager shared] addLogFromObjectiveC:@"VWO FME SDK initialization started"];
}

/**
 * Generates a random user ID for testing purposes
 * Creates a 12-character alphanumeric string for VWO user context
 * 
 * @return A randomly generated user ID string
 */
- (NSString *)generateRandomUserId {
    // Define the character set for random ID generation
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    // Create a mutable string with capacity for 12 characters
    NSMutableString *randomString = [NSMutableString stringWithCapacity:12];
    
    // Generate 12 random characters
    for (int i = 0; i < 12; i++) {
        // Generate random index within the letters string bounds
        u_int32_t index = arc4random_uniform((u_int32_t)[letters length]);
        
        // Get the character at the random index
        unichar c = [letters characterAtIndex:index];
        
        // Append the random character to our string
        [randomString appendFormat:@"%C", c];
    }
    
    return randomString;
}

// MARK: - Segue Methods

/**
 * Prepares the destination view controller before navigation
 * Sets up delegate relationships for data passing between view controllers
 * 
 * @param segue The segue object containing information about the view controllers involved
 * @param sender The object that initiated the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Check if this is the segue to show logs
    if ([segue.identifier isEqualToString:@"ShowLogsSegue"]) {
        // Get reference to the destination logs view controller
        LogsViewController *logsVC = segue.destinationViewController;
        
        // Set this view controller as the delegate for log data
        logsVC.delegate = self;
    }
}


// MARK: - Log Collection

/**
 * Collects logs from VWOFMEManager and current app state
 * Prepares log data for display in LogsViewController
 * Combines SDK logs with current application state information
 */
- (void)collectLogsFromVWOFMEManager {
    // Retrieve all logs from VWO FME SDK manager
    NSArray *vwoLogs = [[VWOFMEManager shared] getLogs];
    
    // Create a mutable array to store all log entries
    NSMutableArray *logEntries = [[NSMutableArray alloc] init];
    
    // Add all VWO SDK logs to our collection
    for (NSString *logMessage in vwoLogs) {
        [logEntries addObject:logMessage];
    }
    
    // Create a log entry for current app state (user ID and flag status)
    NSString *currentStateLog = [NSString stringWithFormat:@"App State - User ID: %@, Flag Status: %@", 
                                 self.userIDLabel.text ?: @"Not set", 
                                 self.flagStatusLabel.text ?: @"Unknown"];
    
    // Add the current state log to our collection
    [logEntries addObject:currentStateLog];
    
    // Store the collected logs for later use
    self.logs = [logEntries copy];
}

#pragma mark - LogsViewControllerDelegate

/**
 * Delegate method called by LogsViewController to retrieve log data
 * Ensures fresh log data is collected before returning to the logs view
 * 
 * @return An array of log messages for display in LogsViewController
 */
- (NSArray<NSString *> *)getLogsForLogsViewController {
    // Collect fresh logs from VWO FME SDK and current app state
    [self collectLogsFromVWOFMEManager];
    
    // Return a copy of the logs array to prevent external modification
    return [self.logs copy];
}

@end

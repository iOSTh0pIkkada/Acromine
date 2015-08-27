//
//  ViewController.h
//  Coding
//
//  Created by Official on 8/26/15.
//  Copyright (c) 2015 Practicing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) MBProgressHUD *HUD;

- (IBAction)textFieldEndEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *dataArray;
@end


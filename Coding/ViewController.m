//
//  ViewController.m
//  Coding
//
//  Created by Official on 8/26/15.
//  Copyright (c) 2015 Practicing. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "CustomCell.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textField.text = @"Please Enter Acronym/ Initialism here";
    
    self.textField.textColor = [UIColor colorWithWhite:20 alpha:0.8];
    
    self.textField.backgroundColor =[UIColor colorWithRed:90/255.0 green:187/255.0 blue:181/255.0 alpha:1.0];
    [self.textField setFont:[UIFont fontWithName:@"Ciutadella-Bold" size:20]];
    
    
    
    self.textField.adjustsFontSizeToFitWidth = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldEndEdit:(id)sender {
    
    if([self.textField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Invalid Input" message:@"Please Enter The Acronym" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry ", nil];
        [alertView show];
    }
    
    else {
        [self getJSONData];
    }

    
    
    
}

- (IBAction)textFieldBeginEdit:(id)sender {
    
    
     self.textField.backgroundColor = [UIColor whiteColor];
    
    self.textField.textColor = [UIColor blackColor];
    
}

-(void)getJSONData {
    
    
    
    
    [self.dataArray removeAllObjects];
    
    
    
    self.HUD = [[MBProgressHUD alloc]initWithView:self.view];
    
    [self.view addSubview:self.HUD];
    [self.HUD show: YES];
    [self.HUD setLabelText:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    
    NSString *textFieldText = self.textField.text;
    
    NSString *jsonURL  =[NSString stringWithFormat:@"%@%@",@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=", textFieldText];
    
    NSString *encoded = [jsonURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
    [manager GET:encoded parameters:nil success:^ (AFHTTPRequestOperation *operation,id responseObject) {
        
        // NSArray *responseArray = (NSArray *)responseObject;
        
        for(NSDictionary *responseDictionary in responseObject)
        {
            
            NSArray *lfsArray = [responseDictionary objectForKey:@"lfs"];
            
            for(NSDictionary *lfsADictionary in lfsArray)
            {
                
                NSString *acronymString = [lfsADictionary objectForKey:@"lf"];
                [self.dataArray addObject:acronymString];
                
            }
        }
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.HUD hide:YES];
            
        });
        
        if(![self.dataArray count])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
               UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Invalid Initialism/ Acronym" message:@"Check For a Trailing Space In Acronym/Initialism" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                        [alertView show];
                
            });
        }
            
        
        
        
        
        
        [self.tableView reloadData];
        

    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Matching Acronyms" message:@"Please Enter a Different Abbreviation" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Retry", nil];
                    [alertView show];
        


        
        
        NSLog(@"%@",error) ;
    }];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        if(buttonIndex == 1)
        {
            
            
           
            
            self.textField.text = @"";
        }
    
    
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.customCellLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell; 
    
    
    
    
}










@end

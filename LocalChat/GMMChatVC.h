//
//  GMMSecondViewController.h
//  LocalChat
//
//  Created by Xtreme Dev on 2014-03-03.
//  Copyright (c) 2014 GeoffMacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMMChatVC : UIViewController <NSStreamDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSInputStream * inputStream;
    NSOutputStream * outputStream;
    NSMutableArray * messages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UITextField *msgField;

- (IBAction)joinTapped:(id)sender;

@end

//
//  GMMSecondViewController.m
//  LocalChat
//
//  Created by Xtreme Dev on 2014-03-03.
//  Copyright (c) 2014 GeoffMacDonald. All rights reserved.
//

#import "GMMChatVC.h"

@interface GMMChatVC ()

@end

@implementation GMMChatVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initNetwork];
    
    [_msgField setDelegate:self];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    messages = [NSMutableArray new];
}

-(void)initNetwork{
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 70, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinTapped:(id)sender {
    
    NSString * req  = [NSString stringWithFormat:@"iam:%@", _nickField.text];
    NSData * dataToWrite = [NSData dataWithData:[req dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[dataToWrite bytes] maxLength:[dataToWrite length]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *s = (NSString *) [messages objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self resignFirstResponder];
    
    //send message and clear
    [self sendMessage:textField.text];
    
    return NO;
}

-(void)sendMessage:(NSString*)msg{
    
    NSString * req  = [NSString stringWithFormat:@"msg:%@", msg];
    NSData * dataToWrite = [NSData dataWithData:[req dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[dataToWrite bytes] maxLength:[dataToWrite length]];
}

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    
	NSLog(@"stream event %lu", eventCode);
    
    if (aStream == inputStream) {
        uint8_t buffer[1024];
        int len;
        
        switch (eventCode) {
            case NSStreamEventHasBytesAvailable:
                
                while([inputStream hasBytesAvailable]){
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if(len > 0){
                        NSString * output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        NSLog(@"%@",output);
                        
                        [messages insertObject:output atIndex:0];
                        [_tableView reloadData];
                    }
                }
                break;
                
            default:
                break;
        }
    }
}



@end

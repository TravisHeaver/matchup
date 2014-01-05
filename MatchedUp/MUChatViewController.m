//
//  MUChatViewController.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUChatViewController.h"

@interface MUChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComlete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation MUChatViewController

-(NSMutableArray *)chats
{
    if ((!_chats)) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
    
    [super viewDidLoad];
    

    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[kMUChatRoomUser1Key];
    if ([testUser1.objectId isEqual:self.currentUser.objectId]){
        self.withUser = self.chatRoom[kMUChatRoomUser2Key];
    }
    else {
        self.withUser = self.chatRoom[kMUChatRoomUser1Key];
    }
    self.title = self.withUser[kMUUserProfileKey][kMUUserProfileFirstNameKey];
    self.initialLoadComlete = NO;
    [self checkForNewChats];
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}

#pragma mark -tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"the number of chats is: %lu", (unsigned long)[self.chats count]);
    return [self.chats count];
}
#pragma mark - tableview delegate
- (void)didSendText:(NSString *)text
{
    if (text.length != 0) {
        PFObject *chat = [PFObject objectWithClassName:kMUChatClassKey];
        [chat setObject:self.chatRoom forKey:kMUChatChatRoomKey];
        [chat setObject:[PFUser currentUser] forKey:kMUChatFromUserKey];
        [chat setObject:self.withUser forKey:kMUChatToUserKey];
        [chat setObject:text forKey:kMUChatTextKey];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"save complete");
            [self.chats addObject:chat];
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
        }];
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* If we are doing the sending return JSBubbleMessageTypeOutgoing 
     else JSBubbleMessageTypeIncoming
     */
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[kMUChatFromUserKey];
    if ([testFromUser.objectId isEqual:currentUser.objectId])
        
    {
        return JSBubbleMessageTypeOutgoing;;
    }
    else{
        return JSBubbleMessageTypeIncoming;
    }
}
- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[kMUChatFromUserKey];
    if ([testFromUser.objectId isEqual:currentUser.objectId])
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else{
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}
-(JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}
-(JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyAll;
}
-(JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}
-(JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}
#pragma mark - messages view delegate OPTIONAL
-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}
-(BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}
#pragma mark - messages view data source required

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[kMUChatTextKey];
    return message;
}
-(NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark -helper methods

-(void) checkForNewChats
{
    NSLog(@"checking for new chats");
    
    int oldChatCount = [self.chats count];
    PFQuery *queryForChats  = [PFQuery queryWithClassName:kMUChatClassKey];
    [queryForChats whereKey:kMUChatChatRoomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComlete == NO || oldChatCount != [objects count]){

                NSLog(@"old chat count %i", oldChatCount);
                NSLog(@"objects count %lu", (unsigned long)[objects count]);

                
                self.chats = [objects mutableCopy];
                if (self.initialLoadComlete == YES){
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                [self.tableView reloadData];
                self.initialLoadComlete = YES;
                [JSMessageSoundEffect playMessageReceivedSound];
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}



@end

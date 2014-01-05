//
//  MUChatViewController.h
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface MUChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (strong, nonatomic) PFObject *chatRoom;

@end

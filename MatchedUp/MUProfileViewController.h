//
//  MUProfileViewController.h
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUProfileViewControlerDelegate <NSObject>

-(void)didPressLike;
-(void)didPressDislike;

@end


@interface MUProfileViewController : UIViewController


@property (strong, nonatomic) PFObject *photo;

@property (weak, nonatomic) id <MUProfileViewControlerDelegate> delegate;
@end

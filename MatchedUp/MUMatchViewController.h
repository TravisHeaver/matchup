//
//  MUMatchViewController.h
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUMatchViewControlerDelegate <NSObject>
-(void)presentMatchesViewController;

@end

@interface MUMatchViewController : UIViewController

@property (weak) id <MUMatchViewControlerDelegate> delegate;

@property (strong, nonatomic) UIImage *matchedImage;
@end

//
//  MUProfileViewController.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUProfileViewController.h"

@interface MUProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;

@end

@implementation MUProfileViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    PFFile *pictureFile = self.photo[kMUPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.profileImageView.image = [UIImage imageWithData:data];
    }];
    
    PFUser *user = self.photo[kMUPhotoUserKey];
    self.locationLabel.text = user[kMUUserProfileKey][kMUUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kMUUserProfileKey][kMUUserProfileAgeKey]];
    
    if (user[kMUUserProfileKey][kMUUserProfileRelationshipStatusKey] == nil) {
        self.statusLabel.text = @"Single";
    }
    else
    {
        self.statusLabel.text = user[kMUUserProfileKey][kMUUserProfileRelationshipStatusKey];
    }
    
    self.taglineLabel.text = user[kMUUserProfileKey][kMUUserTageLineKey];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.title = user[kMUUserProfileKey][kMUUserProfileFirstNameKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disLikeButtonPressed:(UIButton *)sender {
    [self.delegate didPressDislike];
}
- (IBAction)likeButtonPressed:(UIButton *)sender {
    [self.delegate didPressLike];
}

@end

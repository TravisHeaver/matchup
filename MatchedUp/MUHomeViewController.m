//
//  MUHomeViewController.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUHomeViewController.h"
#import "MUTestUser.h"
#import "MUProfileViewController.h"
#import "MUMatchViewController.h"
#import "MUTransitionAnimator.h"
@interface MUHomeViewController () <MUMatchViewControlerDelegate, MUProfileViewControlerDelegate,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIImage *photoImageViewImageCopyForChatroomCreate;

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;


@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) PFObject *photo;

@property (strong, nonatomic) PFObject *photoCopyForChatroomCreate;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;
@property (strong, nonatomic) IBOutlet UIView *labelContainerView;
@property (strong, nonatomic) IBOutlet UIView *buttonContainerView;

@end

@implementation MUHomeViewController

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

    //Create Darth and Jennifer
//    [MUTestUser saveTestUserToParse];
//    [MUTestUser saveTestUserToParse2];
    [self setupViews];
}

-(void)setupViews
{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShaddowForView:self.buttonContainerView];
    [self addShaddowForView:self.labelContainerView];
    self.photoImageView.layer.masksToBounds = YES;
    
}

-(void)addShaddowForView:(UIView *)view;
{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 4;
    view.layer.shadowRadius = 1;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 0.25;
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString *string1 = [[NSString alloc] init];
    NSString *string2 = [[NSString alloc] init];
    
    string1 = @"hello";
    string2 = string1;
    
    NSLog(@"string 1 = :%@",string1);
    NSLog(@"string 2 = :%@",string2);

    string1 = @"new updated string";
    NSLog(@"string 1 = :%@",string1);
    NSLog(@"string 2 = :%@",string2);
    
    self.photoImageView.image = nil;
    self.firstNameLabel.text = nil;
    self.ageLabel.text = nil;
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = YES;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];
    [query includeKey:kMUPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.photos = objects;
            if ([self allowPhoto] == NO) {
                [self setupNextPhoto];
            }
            else{
                [self queryForCurrentPhotoIndex];
            }
        }
        else{
            NSLog(@"error: %@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"])
    {
        MUProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
        profileVC.delegate = self;
    }
}

#pragma mark -IBactions
- (IBAction)chatButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
}
- (IBAction)settingsButtonPressed:(UIBarButtonItem *)sender {
}
- (IBAction)likeButtonPressed:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    [mixpanel track:@"like"];
    [mixpanel flush];
    
    [self checkLike];
}
- (IBAction)dislikeButtonPressed:(UIButton *)sender {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];

    [mixpanel track:@"dislike"];
    [mixpanel flush];
    [self checkDislike];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}

#pragma mark - helper methods
-(void)queryForCurrentPhotoIndex
{
    NSLog(@"query for current photo index");
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kMUPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error){
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }
            else NSLog(@"error %@",error);
        }];
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForLike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
        [queryForLike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForDislike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeDislikeKey];
        [queryForDislike whereKey:kMUActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error){
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0) {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                } else {
                    PFObject *activity = self.activities[0];
                    if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityTypeLikeKey]){
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityTypeDislikeKey]){
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else {
                        //Some other type of activity
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
            }
        }];
    }
}

-(void)updateView
{
    self.firstNameLabel.text = self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@",self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileAgeKey]];
    NSLog(@"%@",self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileAgeKey]);
}
-(void)setupNextPhoto
{
    NSLog(@"set up next photo");
    if (self.currentPhotoIndex + 1 < self.photos.count) {
        self.currentPhotoIndex ++;
        
        if ([self allowPhoto] == NO) {
            [self setupNextPhoto];
        }
        else{
            [self queryForCurrentPhotoIndex];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"no more useres" message:@"check back later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(BOOL)allowPhoto
{
    int maxAge = [[NSUserDefaults standardUserDefaults] integerForKey:kMUAgeMaxEnabledKey];
    BOOL men = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    BOOL women = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    BOOL single = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];
    
    PFObject *photo = self.photos[self.currentPhotoIndex];

    PFUser *user = photo[kMUPhotoUserKey];
    
    int userAge = [user[kMUUserProfileKey][kMUUserProfileAgeKey] intValue];
    NSString *gender = user[kMUUserProfileKey][kMUUserProfileGenderKey];
    NSString *relationshipStatus = user[kMUUserProfileKey][kMUUserProfileRelationshipStatusKey];
    
    if(userAge > maxAge)
    {
        return NO;
    }
    else if (men == NO && [gender isEqualToString:@"male"]) return NO;
    else if (women == NO && [gender isEqualToString:@"female"]) return NO;
    else if (single == NO && ([relationshipStatus isEqualToString:@"single"] || relationshipStatus==nil)) return NO;
    else return YES;
}

- (void)saveLike {
    PFObject *likeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [likeActivity setObject:kMUActivityTypeLikeKey forKey:kMUActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    
    NSLog(@"saving like, photo user key: %@", [self.photo objectForKey:kMUPhotoUserKey]);
    
    [likeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    NSLog(@"with photo: %@",self.photo);
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         self.isLikedByCurrentUser = YES;
         self.isDislikedByCurrentUser = NO;
         [self.activities addObject: likeActivity];
         NSLog(@"about to check for photo user likes");
         [self checkForPhotoUserLikes];
         NSLog(@"check for photo user likes should be done, about to setup next photo");

         [self setupNextPhoto];
         NSLog(@"set up next photo is now done");

     }];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [dislikeActivity setObject:kMUActivityTypeDislikeKey forKey:kMUActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kMUActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject: dislikeActivity];
        [self setupNextPhoto];
    }];
}

- (void)checkLike
{
    if (self.isLikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else [self saveLike];
}

- (void)checkDislike
{
    NSLog(@"dislike pressed");
    if (self.isDislikedByCurrentUser){
        NSLog(@"Case1");
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser){
        NSLog(@"case2");
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else [self saveDislike];
}

-(void)checkForPhotoUserLikes
{
    //I am creating a copy here because I believe I have a race condition. CreateChatRoom has a secondary thread that requires photo data. This data is however updated in the setup next photo, which runs on the main thread.
    self.photoCopyForChatroomCreate = self.photo;
    self.photoImageViewImageCopyForChatroomCreate = self.photoImageView.image;
    
    NSLog(@"check for photo user likes");
    PFQuery *query = [PFQuery queryWithClassName:kMUActivityClassKey];
    [query whereKey:kMUActivityFromUserKey equalTo:self.photo[kMUPhotoUserKey]];
    
    NSLog(@"checking for from user with key: %@", self.photo[kMUPhotoUserKey]);
    
    [query whereKey:kMUActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"the number of likes: %lu", (unsigned long)[objects count]);
        if ([objects count] > 0) {
            //create chatroom
            [self createChatRoom];
        }
    }];
}
-(void) createChatRoom
{
    NSLog(@"Creating Chatroom");
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [queryForChatRoom whereKey:kMUChatRoomUser1Key equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:kMUChatRoomUser2Key equalTo:self.photoCopyForChatroomCreate[kMUPhotoUserKey]];
    
    NSLog(@"Creating chatroom with user1 key: %@", [PFUser currentUser]);
    NSLog(@"Creating chatroom with user2 key: %@", self.photoCopyForChatroomCreate[kMUPhotoUserKey]);

    PFQuery *queryForChatRoomInvers = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [queryForChatRoomInvers whereKey:kMUChatRoomUser1Key equalTo:self.photoCopyForChatroomCreate[kMUPhotoUserKey]];
    [queryForChatRoomInvers whereKey:kMUChatRoomUser2Key equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom,queryForChatRoomInvers]];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSLog(@"the number of chatrooms is: %lu", (unsigned long)[objects count]);
        if ([objects count] == 0) {
            NSLog(@"the count is 0, creating the chatroom");
            PFObject *chatroom = [PFObject objectWithClassName:kMUChatRoomClassKey];
            [chatroom setObject:[PFUser currentUser] forKey:kMUChatRoomUser1Key];
            [chatroom setObject:self.photoCopyForChatroomCreate[kMUPhotoUserKey] forKey:kMUChatRoomUser2Key];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                
                UIStoryboard *myStoryBoard = self.storyboard;
                MUMatchViewController *matchViewController = [myStoryBoard instantiateViewControllerWithIdentifier:@"matchVC"];
                matchViewController.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
                matchViewController.transitioningDelegate = self;
                matchViewController.matchedImage = self.photoImageViewImageCopyForChatroomCreate;
                
                matchViewController.delegate = self;
                matchViewController.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:matchViewController animated:YES completion:nil];
            }];
        }
    }];
}

#pragma mark -MUMatchedViewControllerDelegate
-(void)presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}


#pragma mark - MUProfileViewControllerDelegate
-(void)didPressLike{
    [self.navigationController popViewControllerAnimated:NO];
    [self checkLike];
}
-(void)didPressDislike{
    [self.navigationController popViewControllerAnimated:NO];
    [self checkDislike];
}
#pragma mark -UIViewcontroller transitioning delegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    MUTransitionAnimator *animator = [[MUTransitionAnimator alloc]init];
    animator.presenting = YES;
    return animator;
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    MUTransitionAnimator *animator = [[MUTransitionAnimator alloc] init];
    return animator;
}
@end

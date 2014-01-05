//
//  MUMatchesViewController.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUMatchesViewController.h"
#import "MUChatViewController.h"

@interface MUMatchesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *availableChatRooms;


@end

@implementation MUMatchesViewController

#pragma mark - lazy instantiation
-(NSMutableArray *)availableChatRooms
{
    if (!_availableChatRooms) {
        _availableChatRooms = [[NSMutableArray alloc] init];
    }
    return _availableChatRooms;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateAvailableChatRooms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MUChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    chatVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
    
}

#pragma mark -helper methods

-(void) updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [query whereKey:kMUChatRoomUser1Key equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:kMUChatRoomClassKey];
    [query whereKey:kMUChatRoomUser2Key equalTo:[PFUser currentUser]];
    PFQuery *querCombined = [PFQuery orQueryWithSubqueries:@[query,queryInverse]];
    [querCombined includeKey:kMUChatClassKey];
    [querCombined includeKey:kMUChatRoomUser1Key];
    [querCombined includeKey:kMUChatRoomUser2Key];
    
    [querCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
            
            NSLog(@"The number of available chat rooms is: %lul", (unsigned long)[self.availableChatRooms count]);
        }
    }];

}
#pragma mark - UItableview DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatRooms count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    
    PFUser *testUser1 = chatRoom[kMUChatRoomUser1Key];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        likedUser = [chatRoom objectForKey:kMUChatRoomUser2Key];
    }
    else
    {
        likedUser = [chatRoom objectForKey:kMUChatRoomUser1Key];
    }

    cell.textLabel.text = likedUser[kMUUserProfileKey][kMUUserProfileFirstNameKey];
    
    //cell.imageView.image = place holder image
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:kMUPhotoClassKey];
    [queryForPhoto whereKey:kMUPhotoUserKey equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMUPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
    
    return cell;
}

#pragma  mark - UITableView Delegets
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath];
}
@end

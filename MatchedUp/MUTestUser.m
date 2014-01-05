//
//  MUTestUser.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/24/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

+(void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"darth";
    newUser.password = @"password";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"creating darth");
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1985", @"firstName" : @"Darth", @"gender" : @"male", @"location" : @"Berlin, Germany", @"name" : @"Darth V"};
            [newUser setObject:profile forKey:kMUUserProfileKey];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"darth.jpg"];
                NSData *imageDate = UIImageJPEGRepresentation(profileImage, 0.8);
                
                PFFile *photoFile = [PFFile fileWithData:imageDate];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
                        [photo setObject:newUser forKey:kMUPhotoUserKey];
                        [photo setObject:photoFile forKey:kMUPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"darth photo saved");
                        }];
                        
                    }
                }];
            }];
        }
    }];
}

+(void)saveTestUserToParse2
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"Jennifer";
    newUser.password = @"password2";
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            
            NSLog(@"sign up %@", error);
            NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1985", @"firstName" : @"Jennifer", @"gender" : @"female", @"location" : @"Berlin, Germany", @"name" : @"Jennifer L"};
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIImage *profileImage = [UIImage imageNamed:@"jennifer.jpg"];
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                PFFile *photoFile = [PFFile fileWithData:imageData];
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded){
                        PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
                        [photo setObject:newUser forKey:kMUPhotoUserKey];
                        [photo setObject:photoFile forKey:kMUPhotoPictureKey];
                        [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            NSLog(@"Photo saved successfully");
                        }];
                    }
                }];
            }];
        }
    }];
}



@end

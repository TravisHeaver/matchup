//
//  MUconstants.h
//  MatchedUp
//
//  Created by Travis Heaver on 12/23/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUconstants : NSObject


#pragma mark - user profile

extern NSString *const kMUUserTageLineKey;

extern NSString *const kMUUserProfileKey;
extern NSString *const kMUUserProfileNameKey;
extern NSString *const kMUUserProfileFirstNameKey;
extern NSString *const kMUUserProfileLocationKey;
extern NSString *const kMUUserProfileGenderKey;
extern NSString *const kMUUserProfileBirthdayKey;
extern NSString *const kMUUserProfileInterestedInKey;
extern NSString *const kMUUserProfilePictureURL;

extern NSString *const kMUUserProfileRelationshipStatusKey;
extern NSString *const kMUUserProfileAgeKey;

#pragma mark - photo class
extern NSString *const kMUPhotoClassKey;
extern NSString *const kMUPhotoUserKey;
extern NSString *const kMUPhotoPictureKey;


#pragma mark - Activity Class
extern NSString *const kMUActivityClassKey;
extern NSString *const kMUActivityTypeKey;
extern NSString *const kMUActivityFromUserKey;
extern NSString *const kMUActivityToUserKey;
extern NSString *const kMUActivityPhotoKey;
extern NSString *const kMUActivityTypeLikeKey;
extern NSString *const kMUActivityTypeDislikeKey;

#pragma mark -settings
extern NSString *const kMUMenEnabledKey;
extern NSString *const kMUWomenEnabledKey;
extern NSString *const kMUSingleEnabledKey;
extern NSString *const kMUAgeMaxEnabledKey;

#pragma mark ChatRoom
extern NSString *const kMUChatRoomClassKey;
extern NSString *const kMUChatRoomUser1Key;
extern NSString *const kMUChatRoomUser2Key;

#pragma mark Chat
extern NSString *const kMUChatClassKey;
extern NSString *const kMUChatChatRoomKey;
extern NSString *const kMUChatFromUserKey;
extern NSString *const kMUChatToUserKey;
extern NSString *const kMUChatTextKey;



@end

//
//  MUconstants.m
//  MatchedUp
//
//  Created by Travis Heaver on 12/23/13.
//  Copyright (c) 2013 Travis Heaver. All rights reserved.
//

#import "MUconstants.h"

@implementation MUconstants

#pragma mark - user class
NSString *const kMUUserTageLineKey              = @"tagLine";

NSString *const kMUUserProfileKey               = @"profile";
NSString *const kMUUserProfileNameKey           = @"name";
NSString *const kMUUserProfileFirstNameKey      = @"firstName";
NSString *const kMUUserProfileLocationKey       = @"location";
NSString *const kMUUserProfileGenderKey         = @"gender";
NSString *const kMUUserProfileBirthdayKey       = @"birthday";
NSString *const kMUUserProfileInterestedInKey   = @"interestedIn";
NSString *const kMUUserProfilePictureURL        = @"pictureURL";

NSString *const kMUUserProfileRelationshipStatusKey = @"relationshipStatus";
NSString *const kMUUserProfileAgeKey            = @"age";

#pragma mark - photo class
NSString *const kMUPhotoClassKey                = @"Photo";
NSString *const kMUPhotoUserKey                 = @"user";
NSString *const kMUPhotoPictureKey              = @"image";



#pragma mark - Activity Class
NSString *const kMUActivityClassKey             = @"Activity";
NSString *const kMUActivityTypeKey              = @"type";
NSString *const kMUActivityFromUserKey          = @"fromUser";
NSString *const kMUActivityToUserKey            = @"toUser";
NSString *const kMUActivityPhotoKey             = @"photo";
NSString *const kMUActivityTypeLikeKey          = @"like";
NSString *const kMUActivityTypeDislikeKey       = @"dislike";


NSString *const kMUMenEnabledKey                = @"men";
NSString *const kMUWomenEnabledKey              = @"women";
NSString *const kMUSingleEnabledKey             = @"single";
NSString *const kMUAgeMaxEnabledKey             = @"maxAge";

#pragma mark ChatRoom
NSString *const kMUChatRoomClassKey             = @"Chatroom";
NSString *const kMUChatRoomUser1Key             = @"user1";
NSString *const kMUChatRoomUser2Key             = @"user2";

#pragma mark Chat
NSString *const kMUChatClassKey                 = @"Chat";
NSString *const kMUChatChatRoomKey              = @"chatroom";
NSString *const kMUChatFromUserKey              = @"fromUser";
NSString *const kMUChatToUserKey                = @"toUser";
NSString *const kMUChatTextKey                  = @"text";





















@end

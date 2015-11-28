//
//  SMAchievementData.h
//  SessionM 
//
//  Copyright (c) 2015 SessionM. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class Achievement data class.
 @abstract Defines information about achievement used to customize achievement alert presentation.
 */
@interface SMAchievementData : NSObject
/*!
 @property identifier
 @abstract Achievement ID.
 */
@property(nonatomic, copy, readonly) NSString *identifier;
/*!
 @property importID
 @abstract ID assigned to the achievement in the csv file exported from the SessionM Developer Portal.
 */
@property(nonatomic, copy, readonly) NSString *importID;
/*!
 @property instructions
 @abstract Instructions explaining how to earn achievement.
 */
@property(nonatomic, copy, readonly) NSString *instructions;
/*!
 @property name
 @abstract Achievement name.
 */
@property(nonatomic, copy, readonly) NSString *name;
/*!
 @property message
 @abstract Message describing the achievement.
 */
@property(nonatomic, copy, readonly) NSString *message;
/*!
 @property action
 @abstract Action name.
 */
@property(nonatomic, copy, readonly) NSString *action;
/*!
 @property limitText
 @abstract Description of amount of times achievement can be earned (e.g. "Once" or "1 time every day").
 */
@property(nonatomic, copy, readonly) NSString *limitText;
/*!
 @property mpointValue
 @abstract Achievement mPoint value.
 @deprecated This value is deprecated. Use @link pointValue @/link instead.
 */
@property(nonatomic, readonly) NSUInteger mpointValue __attribute__((deprecated));
/*!
 @property pointValue
 @abstract Achievement point value.
 */
@property(nonatomic, readonly) NSUInteger pointValue;
/*!
 @property achievementIconURL
 @abstract Icon URL.
 */
@property(nonatomic, copy, readonly) NSString *achievementIconURL;
/*!
 @property isCustom
 @abstract Boolean indicating if achievement presentation is custom.
 */
@property(nonatomic, readonly) BOOL isCustom;
/*!
 @property lastEarnedDate
 @abstract Date the unclaimed achievement was last earned.
 */
@property(nonatomic, readonly) NSDate *lastEarnedDate;
/*!
 @property timesEarned
 @abstract Amount of times the achievement has been earned by the user.
 */
@property(nonatomic, readonly) NSUInteger timesEarned;
/*!
 @property unclaimedCount
 @abstract Current amount of this achievement the user has earned, but not yet claimed.
 */
@property(nonatomic, readonly) NSInteger unclaimedCount;
/*!
 @property distance
 @abstract Number of actions required to earn new achievement. -1 if achievment is unearnable in the current session. 
 */
@property(nonatomic, readonly) NSInteger distance;
@end

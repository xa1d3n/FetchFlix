//
//  SMFeedMessageData.h
//  SessionM
//
//  Copyright (c) 2015 SessionM. All rights reserved.
//

#import "SMMessageData.h"

/*!
 @class SMFeedMessageData
 @abstract Defines the data associated with an activity feed message.
 @discussion Note: the developer can configure the following properties for each message through the SessionM Mobile Marketing Cloud portal. The @link //apple_ref/occ/cl/SMActivityFeedViewCell @/link and @link //apple_ref/occ/cl/SMActivityFeedViewController @/link classes are provided as out-of-the-box implementations for presenting feed messages inside an activity feed. The @link //apple_ref/occ/cl/SMDefaultMessageView @/link class is provided for presenting outside an activity feed.
 */
@interface SMFeedMessageData : SMMessageData

/*!
 @property subheader
 @abstract Message subtitle.
 */
@property(nonatomic, copy, readonly) NSString *subheader;
/*!
 @property iconURL
 @abstract URL for icon displayed in @link //apple_ref/occ/cl/SMActivityFeedViewCell @/link instance.
 */
@property(nonatomic, copy, readonly) NSString *iconURL;
/*!
 @property icon
 @abstract Icon loaded from bundle URL.
 */
@property(nonatomic, copy, readonly) UIImage *icon;
/*!
 @property imageURL
 @abstract URL for optional banner image displayed at bottom of @link //apple_ref/occ/cl/SMActivityFeedViewCell @/link instance.
 */
@property(nonatomic, copy, readonly) NSString *imageURL;
/*!
 @property image
 @abstract Image loaded from bundle URL.
 */
@property(nonatomic, copy, readonly) UIImage *image;

@end

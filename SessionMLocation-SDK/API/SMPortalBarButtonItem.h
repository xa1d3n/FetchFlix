//
//  SMPortalBarButtonItem.h
//  SessionM
//
//  Copyright (c) 2015 SessionM. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @class SMPortalBarButtonItem
 @abstract Portal bar button item.
 */
@interface SMPortalBarButtonItem : UIBarButtonItem

/*!
 @property presentingController
 @discussion UIViewController object to use as presenting controller for portal view controller.
 */
@property(nonatomic, strong) UIViewController *presentingController;

/*!
 Returns new instance.
 @result New SMPortalBarButtonItem object
 */
+ (SMPortalBarButtonItem *)newInstance;

@end

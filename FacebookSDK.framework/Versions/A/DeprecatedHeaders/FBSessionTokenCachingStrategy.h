/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>

/*! 
 @class
 
 @abstract
 The `FBSessionTokenCachingStrategy` class is responsible for persisting and retrieving cached data related to
 an <FBSession> object, including the user's Facebook access token. 
 
 @discussion
 `FBSessionTokenCachingStrategy` is designed to be instantiated directly or used as a base class. Usually default
 token caching behavior is sufficient, and you do not need to interface directly with `FBSessionTokenCachingStrategy` objects.
 However, if you need to control where or how `FBSession` information is cached, then you may take one of two approaches.
 
 The first and simplest approach is to instantiate an instance of `FBSessionTokenCachingStrategy`, and then pass
 the instance to `FBSession` class' `init` method. This enables your application to control the key name used in
 `NSUserDefaults` to store session information. You may consider this approach if you plan to cache session information
 for multiple users.
 
 The second and more advanced approached is to derive a custom class from `FBSessionTokenCachingStrategy`, which will
 be responsible for caching behavior of your application. This approach is useful if you need to change where the 
 information is cached, for example if you prefer to use the filesystem or make a network connection to fetch and
 persist cached tokens.  Inheritors should override the cacheTokenInformation, fetchTokenInformation, and clearToken methods.
 Doing this enables your application to implement any token caching scheme, including no caching at all.
 
 Direct use of `FBSessionTokenCachingStrategy`is an advanced technique. Most applications use <FBSession> objects without
 passing an `FBSessionTokenCachingStrategy`, which yields default caching to `NSUserDefaults`.
 */
@interface FBSessionTokenCachingStrategy : NSObject

/*!
 @abstract Initializes and returns an instance
 */
- (id)init;

/*!
 @abstract 
 Initializes and returns an instance
 
 @param tokenInformationKeyName     Specifies a key name to use for cached token information in NSUserDefaults, nil
 indicates a default value of @"FBAccessTokenInformationKey"
 */
- (id)initWithUserDefaultTokenInformationKeyName:(NSString*)tokenInformationKeyName;

/*!
 @abstract 
 Called by <FBSession> (and overridden by inheritors), in order to cache token information.
 
 @param tokenInformation            Dictionary containing token information to be cached by the method
 */
- (void)cacheTokenInformation:(NSDictionary*)tokenInformation;

/*!
 @abstract 
 Called by <FBSession> (and overridden by inheritors), in order to fetch cached token information
 
 @discussion
 An overriding implementation should only return a token if it
 can also return an expiration date, otherwise return nil
 */
- (NSDictionary*)fetchTokenInformation;

/*!
 @abstract 
 Called by <FBSession> (and overridden by inheritors), in order delete any cached information for the current token
 */
- (void)clearToken;

/*!
 @abstract 
 Helper function called by the SDK as well as apps, in order to fetch the default strategy instance.
 */
+ (FBSessionTokenCachingStrategy*)defaultInstance;

/*!
 @abstract 
 Helper function called by the SDK as well as application code, used to determine whether a given dictionary
 contains the minimum token information usable by the <FBSession>.
 
 @param tokenInformation            Dictionary containing token information to be validated
 */
+ (BOOL)isValidTokenInformation:(NSDictionary*)tokenInformation;

@end

// The key to use with token information dictionaries to get and set the token value
extern NSString *const FBTokenInformationTokenKey;

// The to use with token information dictionaries to get and set the expiration date
extern NSString *const FBTokenInformationExpirationDateKey;

// The to use with token information dictionaries to get and set the refresh date
extern NSString *const FBTokenInformationRefreshDateKey;

// The key to use with token information dictionaries to get the related user's fbid
extern NSString *const FBTokenInformationUserFBIDKey;

// The key to use with token information dictionaries to determine whether the token was fetched via Facebook Login
extern NSString *const FBTokenInformationIsFacebookLoginKey;

// The key to use with token information dictionaries to get the latest known permissions
extern NSString *const FBTokenInformationPermissionsKey;
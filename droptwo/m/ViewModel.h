//
//  ViewModel.h
//  droptwo
//
//  Created by Mac on 25/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject
{

    NSMutableData *data;
    NSMutableData *data_from_fb;
    id delegate_refresh_my_data;
}

@property (nonatomic, retain)id delegate_refresh_my_data;

@property (nonatomic, retain) NSMutableArray *invites;
@property (nonatomic, retain) NSMutableArray *your_turn;
@property (nonatomic, retain) NSMutableArray *their_turn;


@property (nonatomic, retain) NSURL *webservice_url;
@property (nonatomic, retain) NSMutableURLRequest *webservice_request;
@property (nonatomic, retain) NSURLConnection *active_webservice_connection;
@property (nonatomic, retain) NSString *get_webservice_file_from_request;
@property (nonatomic, retain) NSMutableDictionary *get_dictionary_from_url;


-(void)modelGetDataFromWebServiceForSectionsInvitesYourturnTheirturn;

@end
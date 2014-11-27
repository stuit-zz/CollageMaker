//
//  CMGlobals.h
//  CollageMaker
//
//  Created by Ilhom Khodjaev on 20.11.14.
//  Copyright (c) 2014 Test Project. All rights reserved.
//

#ifndef CollageMaker_CMGlobals_h
#define CollageMaker_CMGlobals_h



#endif

#define ACCESS_TOKEN            @"1193519136.04072c4.43aba4886afd47ee867fe831de1e9bd5"

#define API_URL                 @"https://api.instagram.com/v1"
#define SEARCH_METHOD(string)   [NSString stringWithFormat:@"%@/users/search?access_token=%@&q=%@&count=1", API_URL, ACCESS_TOKEN, string]
#define RECENT_METHOD(string)   [NSString stringWithFormat:@"%@/users/%@/media/recent/?access_token=%@&count=10", API_URL, string, ACCESS_TOKEN]

#define IMAGE_DIRECTORY         [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//
//  ssh_interface.h
//  Secret Socks
//
//  Created by Joshua Chan on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskWrapper.h"


@interface ssh_interface : NSObject {
//	NSString *localSocksPort;
//	NSString *serverSshPort;
//	NSString *serverHostname;
//	NSString *serverSshUsername;
//	NSString *serverSshPasswd;
//	NSString *serverSshObfuscatedKey;
	
	TaskWrapper *sshTask;
}

@property NSString *localSocksPort;
@property NSString *serverSshPort;
@property NSString *serverHostname;
@property NSString *serverSshObfuscatedKey;
@property NSString *serverSshUsername;
@property NSString *serverSshPasswd;

- (void)connectToServer: (id) controller;
- (void)disconnectFromServer;
- (BOOL)hasTerminated;
- (void)dealloc;

@end

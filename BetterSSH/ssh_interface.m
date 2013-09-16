//
//  ssh_interface.m
//  Secret Socks
//
//  Created by Joshua Chan on 10/07/09.
//

#import "ssh_interface.h"


@implementation ssh_interface


- (void)connectToServer:(id <TaskWrapperController>) controller 
{
	//NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	// Bundled obfuscated-openssh client.
	NSString *sshPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/ssh"];
	// Dirty hack around openssh piped password restriction.
	NSString *askpassPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/pass"];

	// Required arguments
	NSMutableArray *sshArguments = [[NSMutableArray alloc]initWithCapacity:20];
    
    [sshArguments addObjectsFromArray:[NSArray arrayWithObjects:
                                       @"-p", self.serverSshPort,
                                       @"-l", self.serverSshUsername,
                                       @"-ND", self.localSocksPort,
                                       @"-o StrictHostKeyChecking=no",
                                       self.serverHostname,nil]];
//    [NSMutableArray arrayWithObjects:
		
	// Obfuscation key is optional. If not specified, normal SSH will be used instead.
	if ([self.serverSshObfuscatedKey length] > 0) {
        
		[sshArguments insertObject:@"-Z" atIndex:0];
		[sshArguments insertObject:self.serverSshObfuscatedKey atIndex:1];
	}
	// Set launch path
	[sshArguments insertObject: sshPath atIndex: 0];
	// Set environment
	NSDictionary *environment = [NSDictionary 
		dictionaryWithObjects:
			[NSArray arrayWithObjects: @":1", askpassPath, self.serverSshPasswd, nil]
		forKeys:
			[NSArray arrayWithObjects: @"DISPLAY", @"SSH_ASKPASS", @"SSH_PASSWD", nil]
	];
	[sshArguments insertObject: environment atIndex: 0];
    
	
	sshTask = [[TaskWrapper alloc] initWithController:controller arguments:sshArguments];
	[sshTask startProcess];

	return;
}


- (void)disconnectFromServer 
{
	[sshTask stopProcess];
    
}

- (BOOL)hasTerminated
{
	return [sshTask hasTerminated];
}

- (void)dealloc
{
	[self disconnectFromServer];
	//[super dealloc];
}


@end



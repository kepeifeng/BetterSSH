//
//  AppDelegate.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate()

@property  sshConfigPanelController *configController;


@end

@implementation AppDelegate



//@synthesize sheet = _sheet;
@synthesize isAutoConnect = _autoConnect;
@synthesize startAtLogin = _startAtLogin;
@synthesize connectionStatus = _connectionStatus;
@synthesize statusIndicator = _statusIndicator;
@synthesize isExpaned = _isExpaned;
@synthesize timeout = _timeout;
id statusBarIconDisconnected;
id statusBarIconConnecting;
id statusBarIconConnected;



//@synthesize config = _config;

-(id)init{

    self = [super init];
    if(self){
    
        
        statusBarIconDisconnected   = [NSImage imageNamed:@"status-bar-disconnected.png"];
        statusBarIconConnecting     = [NSImage imageNamed:@"status-bar-connecting.gif"];
        statusBarIconConnected      = [NSImage imageNamed:@"status-bar-connected.png"];

    }
    
    return self;

}




- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"didFinishLaunching");
    // Insert code here to initialize your application
    

    //Initial config panel
    self.configController = [[sshConfigPanelController alloc]init];
    
    //self.presetManager = [[presetManager alloc] init];
    [self.configPanel addSubview:self.configController.view];
    
    //[self.presetManager setPresetSelectedToConnectAction:self action:@selector(presetSelectedToConnect:)];
    [self.presetManager setDelegate:self];

    //Set config tab view to tabless and borderless
    tabView.tabViewType = NSNoTabsNoBorder;
    
    //Active first tab view on launch
    [tabMatrix selectCellAtRow:0 column:0 ];
    [tabView selectTabViewItemAtIndex:0];
    
    //Load Configurations from local file.
    [self LoadConfigurationFromFile];
    
    orangeColor = [NSColor colorWithCalibratedRed:0.82 green:0.337 blue:0.102 alpha:1];
    darkColor = [NSColor colorWithSRGBRed:0.1529 green:0.1529 blue:0.1529 alpha:1];
    
    windowHasBeenClosed = false;
	thisBundle = [NSBundle bundleForClass:[self class]];
    
	preferences = [NSUserDefaults standardUserDefaults];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"" ,@"hostName",
                          [NSNumber numberWithUnsignedInteger:22] , @"portNumber",
                          @"", @"obfuscationKey",
                          @"", @"userName",
                          @"",@"password",
                          [NSNumber numberWithUnsignedInteger:8088], @"socksPortNumber",
                          [NSNumber numberWithInteger:30],@"timeout",
                          //[NSNumber numberWithInt:0], @"applyToNetwork",
                          //[NSNumber numberWithInt:0], @"isAsyncKeysFirst",
                          [NSNumber numberWithBool:NO], @"isAutoLogin",
                          nil ]; // terminate the list
	[preferences registerDefaults:dict];
    

    //Create statue bar item
    NSMenu *menu = [self createMenu];
    
    //Create status bar icon
    statusItem = [[NSStatusBar systemStatusBar]
                   statusItemWithLength:NSSquareStatusItemLength];
    
    //Attach context menu to status bar icon
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setToolTip:@"BETTERSSH"];
    
    self.connectionStatus = DISCONNECT;
    //[self showEnableIcon];
    
    
    [self setIsExpaned:NO];
    [window setMiniwindowImage:[NSImage imageNamed:@"minisize-icon.png"]];
    //[window center];
    
    
    
	[self loadPrefs];
    NSLog(@"didFinishLaunching, load Prefs");
    //TODO:ENABLE AUTO LOGIN
    
    if (self.isAutoConnect)
    {
        NSLog(@"Start to do auto login");
        [self doConnect:nil];
    }
    
    
    
}

-(void)LoadConfigurationFromFile{

    self.startAtLogin = FALSE;
    self.isAutoConnect = FALSE;

}



-(void)setIsAutoConnect:(BOOL)autoConnect{

    _autoConnect = autoConnect;
    
    autoConnectCheckBox.state = (autoConnect)?NSOnState:NSOffState;
    
    
}




-(IBAction)rowChanged:(id)sender{
    
    
    [tabView selectTabViewItemAtIndex:[[sender selectedCell] tag]];

}




- (IBAction)openAtLoginButtonClicked:(id)sender {

    [NSApp beginSheet:openAtLoginSheet modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];

}

- (IBAction)closeOpenAtLoginSheetButtonClicked:(id)sender {
    
    [NSApp endSheet:openAtLoginSheet];
    
}

- (IBAction)importPresetsClicked:(id)sender {
    
    NSString *error;
    if([self.presetManager importPresets:error]){
        
        [tabMatrix selectCellAtRow:0 column:1];
        
    }
    else{
        
        if(error)
            NSLog(@"%@",error);
    }
    
}

- (IBAction)exportPresetsClicked:(id)sender {
    
    NSString *error;
    if([self.presetManager exportPresets:error]){
    
        //TODO: say preset exported
    
    }
    else{
    
        if(error)
            NSLog(@"%@",error);
    }
    
}


-(void)sheetDidEnd:(NSWindow *)targetSheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
    
    [targetSheet orderOut:self];
    
}



// Respond to clicking the "Connect" button
- (IBAction)doConnect:(id)sender {
    
    NSLog(@"doConnect");
	[self doAutoConnect];
    
}

-(bool)doAutoConnect{
    
	if (!isConnected) {
		// Make sure hostname settings is present
        
        self.connectionStatus = CONNECTING;
        
        sshConfig *currentConfig = self.config;
        
		if ([currentConfig.hostName length] == 0 || currentConfig.portNumber==0 || currentConfig.socksPortNumber == 0) {
            self.isExpaned = YES;
            self.connectionStatus = DISCONNECT;
            [self openWindow];
			return false;
		}

        
        //save the user setting
        [self savePrefs];
        
		// Initialize sshInterface with config settings
		sshInterface = [[ssh_interface alloc]init];
        
		[sshInterface setLocalSocksPort:[NSString stringWithFormat:@"%ld",currentConfig.socksPortNumber]];
		[sshInterface setServerSshPort:[NSString stringWithFormat:@"%ld",currentConfig.portNumber]];
		[sshInterface setServerHostname:currentConfig.hostName];
		[sshInterface setServerSshObfuscatedKey:currentConfig.obfuscationKey];
		[sshInterface setServerSshUsername:currentConfig.userName];
		[sshInterface setServerSshPasswd:currentConfig.password];
		// Connect
        [sshInterface performSelectorInBackground:@selector(connectToServer:) withObject:self];
		//[sshInterface connectToServer:self];
        
        isConnected=[self checkConnection];
		
    if (isConnected) {
			//TODO:close password drawer
            
            //[passwordDrawer close];
            //[self showEnableIcon];
		}
		
	} else {
		// Disconnect
        
		[sshInterface disconnectFromServer];
        //[self showDisableIcon];
	}
    return isConnected;
}

// in the near future,i will add code to check the connection status
// but now just return true;
- (bool)checkConnection
{
    return (self.connectionStatus == CONNECTED)?TRUE:FALSE;
//    return true;
}

//save prefs when the check box status changes
- (IBAction)stateChanged:(id)sender
{
    [self savePrefs];
}


#pragma mark - Preset Manager Protocol Implement
-(void)presetManger:(presetManager *)presetManger appendOutput:(NSString *)output{

    [self appendOutput:output];

}

-(void)presetManger:(presetManager *)presetManger applyConfig:(sshConfig *)config{

    [self presetSelectedToConnect:config];

}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)appendOutput:(NSString *)output
{
    // add the string to the NSTextView's
    // backing store, in the form of an attributed string

    [[statusLabel textStorage] appendAttributedString: [[NSAttributedString alloc]
                                                         initWithString: output]];
    [statusLabel setTextColor:orangeColor];
    //[[statusLabel textStorage] addAttribute:NSForegroundColorAttributeName value:orangeColor range: NSMakeRange(0, [[statusLabel textStorage]length])];
    
    

    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
    NSLog(@"%@",output);
}


// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
    [statusLabel scrollRangeToVisible:NSMakeRange([[statusLabel string] length], 0)];
}


// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.
- (void)processStarted
{
    
    //Change app's connnection state to CONNECTING;
    [self appendOutput:@"\nConnecting..."];
    
    self.connectionStatus = CONNECTING;
	
	char searchStr[255];
	char outputStr[1024];
	FILE *fh;
	int hasMatch, hasTimedOut;
	NSDate *timeStarted = [NSDate date];
	sprintf(searchStr, "127.0.0.1.%s", [[NSString stringWithFormat:@"%ld",self.config.socksPortNumber] cStringUsingEncoding:1]);
	
	// Warning: n00b hack
	// Keep running netstat to check whether the local SOCKS port is listening
	do {
		sleep(1);
		hasMatch = false;
		fh = popen("netstat -na", "r");
		do {
			fgets(outputStr, sizeof(outputStr), fh);
			if (strstr(outputStr, searchStr)) {
				hasMatch = true;
				break;
			}
		} while (!feof(fh));
		pclose(fh);
        [self appendOutput:@"."];
		//hasTimedOut = (abs((int)[timeStarted timeIntervalSinceNow]) > SSH_TIMEOUT);
        NSLog(@"timeIntervalSinceNow = %d",abs((int)[timeStarted timeIntervalSinceNow]));
        hasTimedOut = (abs((int)[timeStarted timeIntervalSinceNow]) > self.timeout);
	} while (!hasTimedOut && !hasMatch && ![sshInterface hasTerminated]);
	
	//[busySpin stopAnimation: self];
    [self appendOutput:@"\n"];
    
	// Check if socks proxy is open
	if (hasMatch) {
        self.connectionStatus = CONNECTED;
		[self appendOutput:@"Success!\n"];
		// Turn on SOCKS in the system wide settings
		if ([applyToNetwork state] == NSOnState) {
			[self toggleSOCKSSetting: true];
		}
	} else {
		// Timed out
		//isConnected = false;
        self.connectionStatus = DISCONNECT;
		[sshInterface disconnectFromServer];
		[self appendOutput:@"Failed to connect.\n"];
	}
}


// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)processFinished
{
	[NSApp requestUserAttention:NSCriticalRequest];
    //TODO:SELECT STATUS TAB
	//[tabs selectTabViewItemWithIdentifier:@"status"];
	//[self toggleCheckmark: false];
	[self appendOutput:@"Not connected.\n"];
    self.connectionStatus = DISCONNECT;
	// Turn off SOCKS in the system wide settings
	if ([applyToNetwork state] == NSOnState) {
		[self toggleSOCKSSetting: false];
	}
}



- (void)toggleSOCKSSetting:(bool)state
{
	FILE *fh;
	int count = 0;
	char buffer;
	char activeInterfaceName[80];
	memset(activeInterfaceName, 0, 80);
    
	// Determine the active network interface
	fh = popen(
               // Rely on the bundled "getservice" Python script to discover the active network service name
               [[NSString stringWithFormat:@"\"%@/%@\"", [thisBundle resourcePath], @"getservice.py"] cStringUsingEncoding:1],
               "r"
               );
	while (!feof(fh)) {
		buffer = fgetc(fh);
		if (iscntrl(buffer) || count >= 80) {
			break;
		}
		activeInterfaceName[count] = buffer;
		count++;
	}
	pclose(fh);
    
	if (strlen(activeInterfaceName) < 1) {
		// default to AirPort in case "getservice" script fails mysteriously
		strcpy(activeInterfaceName, "AirPort");
	}
    
	// Enable/disable the system wide SOCKS proxy setting
	if (state) {
		fh = popen(
                   [[NSString stringWithFormat:@"networksetup -setsocksfirewallproxy %s 127.0.0.1 %ld off 2> /dev/null",
                     activeInterfaceName, self.config.socksPortNumber] cStringUsingEncoding:1], "r"
                   );
	} else {
		fh = popen(
                   [[NSString stringWithFormat:@"networksetup -setsocksfirewallproxystate %s off  2> /dev/null",
                     activeInterfaceName] cStringUsingEncoding:1], "r"
                   );
	}
	
	int exitCode;
	if ((exitCode = pclose(fh))) {
		printf("networksetup exit with code: %d\n", exitCode);
	}
}




- (void)loadPrefs
{
    //TODO: LOAD PREFERENCES
    
    sshConfig *config = [[sshConfig alloc]init];
    
    config.hostName = [preferences stringForKey:@"hostName"];
    config.portNumber = [(NSNumber *)[preferences objectForKey:@"portNumber"] unsignedIntegerValue];
    config.socksPortNumber = [(NSNumber *)[preferences objectForKey:@"socksPortNumber"] unsignedIntegerValue];
    config.userName = [preferences stringForKey:@"userName"];
    config.password = [preferences stringForKey:@"password"];
    config.obfuscationKey = [preferences stringForKey:@"obfuscationKey"];
    
    self.isAutoConnect = [preferences boolForKey:@"isAutoConnect"];
    self.config = config;
    
    self.timeout = [preferences integerForKey:@"timeout"];
    
    
//	[applyToNetwork setState:[preferences integerForKey:@"applyToNetwork"]];
//    [timeoutField setStringValue:[preferences stringForKey:@"timeout"]];
//    [isAsyncKeysFirst setState:[preferences integerForKey:@"isAsyncKeysFirst"]];
   
}

- (void)savePrefs
{

    //TODO: SAVE PREFERENCESE
    
    sshConfig *config = self.config;
	[preferences setObject: config.hostName forKey:@"hostName"];
	[preferences setObject: [NSNumber numberWithUnsignedInteger:config.portNumber] forKey:@"portNumber"];
	[preferences setObject: config.obfuscationKey forKey:@"obfuscationKey"];
	[preferences setObject: config.userName forKey:@"userName"];
    [preferences setObject: config.password forKey:@"password"];
	[preferences setObject: [NSNumber numberWithUnsignedInteger:config.socksPortNumber] forKey:@"socksPortNumber"];
//	[preferences setInteger:  forKey:@"applyToNetwork"];
    [preferences setInteger:self.timeout forKey:@"timeout"];
//    [preferences setInteger:[isAsyncKeysFirst state] forKey:@"isAsyncKeysFirst"];
    [preferences setBool: self.isAutoConnect forKey:@"isAutoConnect"];
    
	[preferences synchronize];
}



- (void)windowDidMiniaturize:(NSNotification *)notification
{
	// Miniaturizing and restoring results in a messed up drawer.
	// Close all drawers to avoid the problem.
//    
//	[drawer close];
//	[toggleDrawer setState: NSOffState];
//	[passwordDrawer close];
}



- (void)windowDidDeminiaturize:(NSNotification *)notification
{
//    
//	[[drawer contentView] setHidden: false];
//	[[passwordDrawer contentView] setHidden: false];
//    
}

/*
 // Confirm with user before terminating
 - (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)theSender
 {
 if (windowHasBeenClosed || !isConnected) {
 // Must terminate if the window has already been closed.
 return NSTerminateNow;
 }
 
 NSAlert *alert = [[NSAlert alloc]init];
 [alert setMessageText: @"Please confirm if you really want to quit and turn off your SOCKS proxy"];
 [alert addButtonWithTitle: @"Quit"];
 [alert addButtonWithTitle: @"Don't quit"];
 
 if ([alert runModal] == NSAlertFirstButtonReturn) {
 [alert release];
 return NSTerminateNow;
 } else {
 [alert release];
 return NSTerminateCancel;
 }
 }
 */

// Confirm with user before closing window
- (BOOL)windowShouldClose:(id)theWindow
{
    /*
     if ([self applicationShouldTerminate: NSApp]) {
     windowHasBeenClosed = true;
     return YES;
     } else {
     return NO;
     }
     */
    //hide window,but not exit
    [window orderOut:nil];
    return NO;
}


// Make sure to disconnect from SSH when terminating
- (void)applicationWillTerminate:(NSApplication *)theApplication
{
	[self quitApp:self];
    NSLog(@"I Quit!");
    return;
}

-(void)quitApp:(id)sender
{
    if (self.connectionStatus == CONNECTED || self.connectionStatus == CONNECTING) {
        [sshInterface disconnectFromServer];
    }
    
    [NSApp terminate:self];

}

//open window when click
-(BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [window makeKeyAndOrderFront:nil];
    return YES;
}


// Terminate when window is closed
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return NO;
}

//Create status bar icon's context menu.
- (NSMenu *) createMenu
{
    NSLog(@"createMenu run");
    NSZone *menuZone = [NSMenu menuZone];
    NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
    NSMenuItem *menuItem;
    
    menuItem = [menu addItemWithTitle:@"Status: DISCONNECT" action:nil keyEquivalent:@""];
    [menuItem setTag:1];
    
    // Add Separator
    [menu addItem:[NSMenuItem separatorItem]];
    
    // Add To Items
    menuItem = [menu addItemWithTitle:@"Connect"
                               action:@selector(doAutoConnect)
                        keyEquivalent:@""];
    
    [menuItem setTag:2];
    [menuItem setTarget:self];

    
    // Add To Items
    menuItem = [menu addItemWithTitle:@"Open Window"
                               action:@selector(openWindow)
                        keyEquivalent:@""];
    [menuItem setTarget:self];
    // Add Separator
    [menu addItem:[NSMenuItem separatorItem]];
    
    // Add Quit Action
    menuItem = [menu addItemWithTitle:@"Quit"
                               action:@selector(quitApp:)
                        keyEquivalent:@""];
    
    [menuItem setToolTip:@"Click to Quit this App"];
    [menuItem setTarget:self];
    return menu;
}

- (void) openWindow
{
    [window makeKeyAndOrderFront:nil];
    [window setLevel: NSStatusWindowLevel];
}


-(sshConfig *)config{
    
    return self.configController.configuration;

}

-(void)setConfig:(sshConfig *)config{

    self.configController.configuration = config;

}

-(void)setConnectionStatus:(connectionStatus)connectionStatus{
    
    
    //When status changed, change the following items' status too.
    //1. statusInicator
    //2. Status bar item's icon
    //3. variable isConnected
    //4. Status bar item's context menu items' title
    //5. Conncect Button's editablity
    //6. Config Panel's editablity
    if(_connectionStatus == connectionStatus){
        //return;
    }
    
    _connectionStatus = connectionStatus;
    if(connectionStatus == DISCONNECT){
        
        [_statusIndicator setImage:[NSImage imageNamed:@"start-normal.png"]];
        isConnected = FALSE;
        
        [self stopAnimating];
        NSImage *img = [NSImage imageNamed:@"status-bar-disconnected.png"];
        [statusItem setImage:img];
        
        [[statusItem.menu itemWithTag:1]setTitle:@"Status:DISCONNECT"];
        [[statusItem.menu itemWithTag:2]setTitle:@"Connect"];
        
        [connectButton setEnabled:YES];

    
    }
    else if(connectionStatus == CONNECTING){
        
        isConnected = FALSE;
        [_statusIndicator setImage:[NSImage imageNamed:@"loading.gif"]];
        [_statusIndicator setAnimates:TRUE];
        
        
        //Start animation on status bar item
        [self startAnimating];
        
        //NSImage *img = [NSImage imageNamed:@"status-bar-connecting.gif"];
        
        //[statusItem setImage:img];

    
        
        [[statusItem.menu itemWithTag:1]setTitle:@"Status:CONNECTING..."];
        [[statusItem.menu itemWithTag:2]setTitle:@"Stop Connection"];
        
        [connectButton setEnabled:NO];

        
    
    }
    else if (connectionStatus == CONNECTED){
        
        isConnected = TRUE;
        [_statusIndicator setImage:[NSImage imageNamed:@"start-highlight.png"]];
        
        [self stopAnimating];
        NSImage *img = [NSImage imageNamed:@"status-bar-connected.png"];
        [statusItem setImage:img];
        
        
        [[statusItem.menu itemWithTag:1]setTitle:@"Status:CONNECTED"];
        [[statusItem.menu itemWithTag:2]setTitle:@"Disconnect"];

        [connectButton setEnabled:YES];
    
    }


}

-(void)presetSelectedToConnect:(sshConfig *)preset{
    
    NSLog(@"presetSelectedToConnect, preset = %@", preset);
    self.config = preset;
    
    //Turn to Config Tab
    [tabMatrix selectCellAtRow:0 column:0];
    
    [self doAutoConnect];

}

-(IBAction)saveAsPreset:(id)sender{

    [self.presetManager newPreset:self.config];

}


/*
 
 assume these instance variables are defined:
 
 NSInteger currentFrame;
 NSTimer* animTimer;
 
 */

- (void)startAnimating
{
    currentFrame = 1;
    
    if(!animTimer)
    {
        animTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateImage:) userInfo:nil repeats:YES];
    }
    else{
        
        [animTimer fire];
    }
}

- (void)stopAnimating
{

    [animTimer invalidate];

}

- (void)updateImage:(NSTimer*)timer
{
    //get the image for the current frame
    NSInteger frameCount = 4;
    
    
    NSImage* image = [NSImage imageNamed:[NSString stringWithFormat:@"status-bar-connecting-%ld",(long)currentFrame]];
    [statusItem setImage:image];
    
    if(currentFrame==frameCount){
        currentFrame = 1;
    }
    else{
        currentFrame++;
    }
}

- (IBAction)expandingButtonClicked:(id)sender{
    
    [self setIsExpaned:(!self.isExpaned)];


}

-(void)setIsExpaned:(BOOL)isExpaned{


    
    _isExpaned = isExpaned;
    //width+472
    

    //NSInteger x = 472;
    NSRect frame = [window frame];
    
    if(isExpaned){
        
        //Expand Window's Size

        frame.size.width =756;
        [window setFrame:frame display:YES animate:YES];
        
        [expandingButton setImage:[NSImage imageNamed:@"collage-button.png"]];
        
        
        
    }
    else
    {
        //Collage Window's Size
        frame.size.width = 284;
        [window setFrame:frame display:YES animate:YES];
        [expandingButton setImage:[NSImage imageNamed:@"expand-button.png"]];
        
    }

}


-(void)setStartAtLogin{

    
}

-(NSInteger)timeout{

    return [timeoutField integerValue];

}

-(void)setTimeout:(NSInteger)timeout{

    _timeout = timeout;
    [timeoutField setIntegerValue:timeout];

}


@end

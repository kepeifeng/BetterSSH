//
//  SecretSocksController.h
//  Secret Socks
//
//  Created by Joshua Chan on 11/07/09.
//  Enhanced by Ling Mo on 20/01/2013

#import <Cocoa/Cocoa.h>
#import "ssh_interface.h"
#import "TaskWrapper.h"

#include <stdio.h>
#include <string.h>
//#import <Security/Authorization.h>

// Number of seconds to wait for SSH to connect
#define SSH_TIMEOUT 30

@interface SecretSocksController : NSObject <TaskWrapperController> 
{
	IBOutlet NSMenuItem *connectMenu;
	IBOutlet NSMenuItem *disconnectMenu;
	
	IBOutlet NSTabView *tabs;
	IBOutlet NSTextField *hostnameField;
	IBOutlet NSTextField *portnumField;
	IBOutlet NSTextField *keyField;
	IBOutlet NSTextField *usernameField;
	IBOutlet NSTextField *passwordField;
	IBOutlet NSTextField *socksportField;
    //Add by Ling Let user to select the Timeout value
    IBOutlet NSTextField *timeoutField;
    
	IBOutlet NSButton *applyToNetwork;
	IBOutlet NSButton *toggleDrawer;
    //Add by Ling
    IBOutlet NSButton *isAsyncKeysFirst;
    IBOutlet NSButton *isAutoLogin;
    
	IBOutlet NSTextView *statusLabel;
	IBOutlet NSButton *connectButton;
	IBOutlet NSImageView *checkmark;
	IBOutlet NSProgressIndicator *busySpin;
	IBOutlet NSWindow *window;
	IBOutlet NSDrawer *drawer;

	IBOutlet NSDrawer *passwordDrawer;
	IBOutlet NSTextField *passwordField2;


	ssh_interface *sshInterface;
	bool isConnected;
	bool windowHasBeenClosed;
	NSBundle *thisBundle;
	
	NSUserDefaults *preferences;
    NSStatusItem *statusItem;
}

- (id)init;
- (IBAction)showConfig:(id)sender;
- (IBAction)showStatus:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)doConnect:(id)sender;
- (void)toggleCheckmark:(bool)status;
- (void)toggleSOCKSSetting:(bool)status;
- (void)loadPrefs;
- (void)savePrefs;
- (BOOL)drawerShouldOpen:(NSDrawer *)sender;
- (BOOL)drawerShouldClose:(NSDrawer *)sender;
- (void)drawerDidOpen:(NSNotification *)notification;
- (void)windowDidMiniaturize:(NSNotification *)notification;
//- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)theSender;
- (BOOL)windowShouldClose:(id)theWindow;
- (void)applicationWillTerminate:(NSApplication *)theApplication;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;

//Add by Ling
-(bool)doAutoConnect;
-(IBAction)stateChanged:(id)sender;
-(void)quitApp:(id)sender;;
-(bool)checkConnection;
-(void)showDisableIcon;
-(void)showEnableIcon;
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;


@end

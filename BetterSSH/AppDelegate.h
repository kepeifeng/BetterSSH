//
//  AppDelegate.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "presetManager.h"
#import "sshConfigPanelController.h"
#import "ssh_interface.h"
#import "sshConfig.h"
#import <ServiceManagement/SMLoginItem.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,TaskWrapperController>{

    IBOutlet NSTabView *tabView;

	ssh_interface *sshInterface;
    BOOL isConnected;
    
	BOOL windowHasBeenClosed;
	NSBundle *thisBundle;
	
	NSUserDefaults *preferences;
    NSStatusItem *statusItem;
    
    IBOutlet NSMenuItem *connectMenu;
	IBOutlet NSMenuItem *disconnectMenu;
	
    
    IBOutlet NSTextField *timeoutField;
	IBOutlet NSButton *applyToNetwork;
    IBOutlet NSButton *isAsyncKeysFirst;
    IBOutlet NSButton *autoConnectCheckBox;
    
	IBOutlet NSTextView *statusLabel;
	IBOutlet NSButton *connectButton;
    
    IBOutlet NSWindow *window;
    
    IBOutlet NSMatrix *tabMatrix;
    
    IBOutlet NSButton *expandingButton;
    
    NSInteger currentFrame;
    NSTimer* animTimer;
    
    NSColor *orangeColor;
    NSColor *darkColor;
    
    
}


@property (weak) IBOutlet NSView *configPanel;
@property (strong) IBOutlet presetManager *presetManager;
@property (nonatomic) sshConfig *config;

@property NSArray *presets;

@property (nonatomic) BOOL isAutoConnect;

@property (nonatomic) BOOL startAtLogin;
@property NSInteger timeout;


//For tab selection changed.
-(IBAction)rowChanged:(id)sender;

@property (nonatomic) connectionStatus connectionStatus;

@property (nonatomic) BOOL isExpaned;






- (IBAction)doConnect:(id)sender;
- (void)toggleSOCKSSetting:(bool)status;
- (void)loadPrefs;
- (void)savePrefs;
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
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;

-(IBAction)saveAsPreset:(id)sender;

- (IBAction)expandingButtonClicked:(id)sender;



@property (weak) IBOutlet NSImageView *statusIndicator;

@end

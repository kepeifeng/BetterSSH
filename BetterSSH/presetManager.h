//
//  presetManager.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sshConfig.h"
#import "myTableCellView.h"
#import "myTableView.h"
#import "sshConfigPanelController.h"
#import "myTableRowView.h"
#import "SimplePing.h"

@protocol PresetManagerDelegate;

#pragma mark - Preset Manger Interface
@interface presetManager : NSObject <NSTableViewDataSource, NSTableViewDelegate,NSOpenSavePanelDelegate,SimplePingDelegate>{

    IBOutlet NSWindow *sheet;
    IBOutlet NSWindow *modelWindow;
    IBOutlet NSView *sshPresetEditPanel;
    IBOutlet NSWindow *newPresetSheet;
    IBOutlet NSTextField *newPresetName;
    
    
    NSColor *orangeColor;
    NSColor *darkColor;
    NSDate *startPingTime;
    NSInteger pingCounter;
    NSMutableArray *cellArray;
    NSInteger currentPingingPresetIndex;
	NSInteger totalPingTime;
	BOOL pingPass;
    
}

#pragma mark - Properties
@property NSMutableArray *presets;
@property (weak) IBOutlet myTableView *presetTebleView;
@property (nonatomic) BOOL isEditingMode;
@property id <PresetManagerDelegate> delegate;
@property (nonatomic, strong, readwrite) SimplePing *   pinger;
@property (nonatomic, strong, readwrite) NSTimer *      sendTimer;

#pragma mark - Actions
//Close preset editing sheet
- (IBAction)closeSheetClicked:(id)sender;
- (IBAction)editPresetClicked:(id)sender;
- (IBAction)deletePresetClicked:(id)sender;
- (IBAction)usePresetConfigToConnectClicked:(id)sender;
- (IBAction)savePresetClicked:(id)sender;
- (IBAction)cancelEditingClicked:(id)sender;
- (IBAction)newPresetSheetCancelButtonClicked:(id)sender;
- (IBAction)newPresetSheetSaveButtonClicked:(id)sender;
- (IBAction)pingServersClicked:(id)sender;


#pragma - Private Methods
- (BOOL)importPresets:(out NSString *)error;
- (BOOL)exportPresets:(out NSString *)error;

//Setup callback method for other classes when preset is selected to use.
- (void)setPresetSelectedToConnectAction:(NSObject*)target action:(SEL)action;

- (void)newPreset:(sshConfig *)config;
- (void)saveNewPreset:(sshConfig *)config;


#pragma mark - IBOutlets
@property (weak) IBOutlet NSButton *editButton;
@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSButton *deleteButton;
@property (weak) IBOutlet NSButton *closeButton;
@property (weak) IBOutlet NSButton *pingButton;
@property (weak) IBOutlet NSProgressIndicator *pingProgressIndicator;

@end





#pragma mark - Preset Manger Delegate Protocol
@protocol PresetManagerDelegate <NSObject>


-(void)presetManger:(presetManager *)presetManger appendOutput:(NSString *)output;
-(void)presetManger:(presetManager *)presetManger applyConfig:(sshConfig *)config;


@end

//
//  presetManager.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "presetManager.h"

@interface presetManager()

@property  sshConfigPanelController *editPresetConfigController;
@property (nonatomic)sshConfig *presetSelectedToConnect;
@property sshConfig *openedPreset;



@end
@implementation presetManager{
   
    myTableCellView *lastSelectedCell;
    
    

}

@synthesize isEditingMode = _isEditingMode;
@synthesize presets = _presetList;
@synthesize presetSelectedToConnect = _presetSelectedToConnect;

SEL presetSelectedToConnectAction;
NSObject *presetSelectedToConnectActionTarget;
sshConfig *_newConfigToSave;



- (id)init
{
    self = [super init];
    NSLog(@"preset manager init");
    if (self) {
      
        //get presets from plist file.
        _presetList = [self getPresetsFromFile];
        
        //[self savePresetsToFile];
        
        //Initial preset editing panel
        self.editPresetConfigController = [[sshConfigPanelController alloc] init];
        
        if(!sheet){
            [NSBundle loadNibNamed:@"sshConfigSheet" owner:self];
        }
        
        
    }
    return self;
}


- (void)awakeFromNib{
    
    //Initial preset list's double click action.
    [self.presetTebleView setDoubleAction:@selector(presetTableViewDoubleAction)];

    [self.presetTebleView setTarget:self];
    [self exitEditingMode];
    

}

-(void)enterEditingMode{
    
    self.isEditingMode = TRUE;
    

}

-(void)exitEditingMode{
    self.isEditingMode = FALSE;

}

-(void)setIsEditingMode:(BOOL)isEditingMode{

    _isEditingMode = isEditingMode;
    
    [self.connectButton setEnabled:!isEditingMode];
    [self.deleteButton setEnabled:!isEditingMode];
    [self.editButton setEnabled:!isEditingMode];
    [self.closeButton setEnabled:!isEditingMode];
    
    [self.saveButton setEnabled:isEditingMode];
    [self.cancelButton setEnabled:isEditingMode];
    
    self.editPresetConfigController.isEditable = isEditingMode;


}



- (IBAction)editPresetClicked:(id)sender {
    

    [self enterEditingMode];
    
}

- (IBAction)deletePresetClicked:(id)sender {
    
    NSAlert *deleteAlert = [[NSAlert alloc]init];
    
    [deleteAlert addButtonWithTitle:@"OK"];
    
    [deleteAlert addButtonWithTitle:@"Cancel"];
    
    deleteAlert.messageText = @"Detele this preset?";
    
    [deleteAlert beginSheetModalForWindow:sheet modalDelegate:self didEndSelector:@selector(deleteAlertDidEnd:) contextInfo:nil];
    
    
}

-(void)deleteAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode{

    NSLog(@"-deleteAlertDidEnd returnCode = %ld",(long)returnCode);
    

}

- (IBAction)usePresetConfigToConnectClicked:(id)sender {
    
    [self closeSheetClicked:nil];
    if(presetSelectedToConnectActionTarget && presetSelectedToConnectAction){
        
        [presetSelectedToConnectActionTarget performSelector:presetSelectedToConnectAction withObject:self.presetSelectedToConnect];
    
            
        
    }
    
}

- (IBAction)savePresetClicked:(id)sender {
    
    [self exitEditingMode];
}

- (IBAction)cancelEditingClicked:(id)sender {
    
    [self.editPresetConfigController setConfiguration:self.openedPreset];
    [self exitEditingMode];
}

- (IBAction)newPresetSheetCancelButtonClicked:(id)sender {
    
    [NSApp endSheet:newPresetSheet];
    //[newPresetSheet close];
    //newPresetSheet = nil;
    
    
}

-(void)sheetDidEnd:(NSWindow *)targetSheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{

    [targetSheet orderOut:self];

}






- (IBAction)newPresetSheetSaveButtonClicked:(id)sender {
    
    _newConfigToSave.presetName = [newPresetName stringValue];
    [self saveNewPreset:_newConfigToSave];
    _newConfigToSave = nil;
}

- (IBAction)ExpandingButtonClicked:(id)sender {
}

-(void)presetTableViewDoubleAction{
//    
//        NSLog(@"大家好，我是presetTableViewDoubleAction");
//        NSLog(@"ClickedRow = %ld",self.presetTebleView.clickedRow);
//        NSLog(@"ClickedColumn = %ld", self.presetTebleView.clickedColumn);
//    
    

    
    sshConfig *selectedPreset = self.presets[self.presetTebleView.clickedRow];
    self.openedPreset = selectedPreset;
    [self editConfig:selectedPreset];
    
    //[NSApp beginSheet:sheet modalForWindow:<#(NSWindow *)#> modalDelegate:<#(id)#> didEndSelector:<#(SEL)#> contextInfo:<#(void *)#>]

}

-(void)editConfig:(sshConfig *)config{
    

    [NSApp beginSheet:sheet
       modalForWindow:modelWindow
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
    
    if(sshPresetEditPanel.subviews.count == 0 ){
        [sshPresetEditPanel addSubview:self.editPresetConfigController.view];
    }
    
    self.editPresetConfigController.configuration = config;
    self.editPresetConfigController.isEditable = FALSE;
    
    
    
}



- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{

    return [_presetList count];
    
}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    sshConfig *config = _presetList[row];
    
    NSString *identifier = [tableColumn identifier];
    if([identifier isEqualToString:@"presetItem"]){
        
        NSTableCellView *cellview = [tableView makeViewWithIdentifier:@"presetItem" owner:self];
        
        //Display hostname on the list.
        [cellview.textField setStringValue:config.presetName];
        
        //Add context menu to list item
//        NSZone *menuZone = [NSMenu menuZone];
//        NSMenu *menu = [[NSMenu allocWithZone:menuZone]init];
//        NSMenuItem *menuItem;
//        menuItem = [menu addItemWithTitle:@"Edit" action:@selector(editPreset:) keyEquivalent:@""];
//        [menuItem setTarget:self];
//        cellview.menu = menu;
        
        return cellview;
        
    }
    
    return nil;

}



-(void)tableViewSelectionDidChange:(NSNotification *)notification{

    myTableView *table = [notification object];
    if(lastSelectedCell){
        lastSelectedCell.isSelected = FALSE;
    }
    myTableCellView *selectedCell = table.selectedCell;
    
    selectedCell.isSelected = TRUE;
    
    lastSelectedCell = selectedCell;

    
    
}




-(IBAction)closeSheetClicked:(id)sender{
    
    if(_isEditingMode){
    
        NSAlert *closeAlert  = [[NSAlert alloc]init];
        closeAlert.messageText = @"Close the window without saving preset?";
        [closeAlert addButtonWithTitle:@"YES"];
        [closeAlert addButtonWithTitle:@"NO"];
        [closeAlert beginSheetModalForWindow:sheet
                               modalDelegate:self didEndSelector:@selector(closeAlertDidEnd:) contextInfo:NULL];
        
    
    }

    [self closeSheet];

}

-(void)closeSheet{

    
    [NSApp endSheet:sheet];
    //[sheet close];
    //sheet = nil;
}


-(void)closeAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode{

        

}


- (IBAction)clearList:(id)sender {
    
    [_presetList removeAllObjects];
    NSLog(@"The number of presetList's objects is %ld",(unsigned long)_presetList.count);
    
}

-(sshConfig *)presetSelectedToConnect{

    return self.openedPreset;


}

-(NSArray *)convertSshConfigListToDictionaryList:(NSArray *)sshConfigList{

    NSMutableArray *newConfigList = [[NSMutableArray alloc]init];
    
    for(sshConfig *ssConfig in sshConfigList){
        [newConfigList addObject:[ssConfig getDictionary]];
    }
    return newConfigList;

}

-(NSMutableArray *)convertDictionaryListToSshConfigList:(NSArray *)dictionaryList{
    
    NSMutableArray *newConfigList = [[NSMutableArray alloc]init];
    
    for(NSDictionary  *dictionary in dictionaryList){
        [newConfigList addObject:[sshConfig getSshConfigFromDictionary:dictionary]];
    }
    return newConfigList;
    

}

-(void)setPresetSelectedToConnectAction:(NSObject *)target action:(SEL)action{


    presetSelectedToConnectAction = action;
    presetSelectedToConnectActionTarget = target;
}



-(NSMutableArray *)getPresetsFromFile{
    
    
    NSMutableArray *_presetsFromFile = [[NSMutableArray alloc]init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"presets" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    if(!plistData){
    
        return _presetsFromFile;
    
    }
    
    NSString *error;
    
    NSPropertyListFormat format;
    
    NSArray *plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    _presetsFromFile = [self convertDictionaryListToSshConfigList:plist];
    
    return _presetsFromFile;
    
}



-(void)savePresetsToFile{
//TODO: IMPLEMENT SAVE PRESETS INTO PROPERTY LIST FILE.
    

    NSArray *presetListForXmlData = [self convertSshConfigListToDictionaryList:_presetList];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"presets" ofType:@"plist"];
    NSData *xmlData;
    NSString *error;
    
    
    
    xmlData = [NSPropertyListSerialization dataFromPropertyList:(id)presetListForXmlData format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    
    if(xmlData){
        //write xmlData into file.
        NSLog(@"Writing xml data into file.");
        [xmlData writeToFile:path atomically:YES];
        NSLog(@"Done writing xml data.");

        
    
    }
    else{
    
        NSLog(@"Error occurs when trying to write xml data into property list file. \nError: %@",error);
        
    }
    

}


- (void)newPreset:(sshConfig *)config{

    //TODO: IMPELEMENT SAVE NEW PRESET

    //[self editConfig:config];
    
    [NSApp beginSheet:newPresetSheet
       modalForWindow:modelWindow
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];

    [newPresetName setStringValue:@""];
    _newConfigToSave = config;
}


-(void)saveNewPreset:(sshConfig *)config{
    
    [_presetList addObject:config];
    [self savePresetsToFile];
    [self.presetTebleView reloadData];
    [self newPresetSheetCancelButtonClicked:nil];
    NSUserNotification *notification = [[NSUserNotification alloc]init];
    notification.title = @"Preset Saved!";
    notification.informativeText = @"You can find your new preset under preset tab.";
    notification.soundName = NSUserNotificationDefaultSoundName;

    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    
    

}


@end




//
//  presetManager.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "presetManager.h"
#include <sys/socket.h>
#include <netdb.h>
#include <SystemConfiguration/SCNetworkReachability.h>


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
        orangeColor = [NSColor colorWithCalibratedRed:0.82 green:0.337 blue:0.102 alpha:1];
        darkColor = [NSColor colorWithSRGBRed:0.1529 green:0.1529 blue:0.1529 alpha:1];
    
        
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
    
    [deleteAlert beginSheetModalForWindow:sheet modalDelegate:self didEndSelector:@selector(deleteAlertDidEnd:returnCode:) contextInfo:nil];
    
    
}

-(void)deleteAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode{

    
    //OK button clicked
    if(returnCode == 1000){
        
        [_presetList removeObject:self.openedPreset];
        [self savePresetsToFile];
        [self.presetTebleView reloadData];
        [self exitEditingMode];
        [self closeSheet];
        
    }
    NSLog(@"-deleteAlertDidEnd returnCode = %ld",(long)returnCode);
    
    

}

- (IBAction)usePresetConfigToConnectClicked:(id)sender {
    
    [self closeSheetClicked:nil];
    
    if(self.delegate){
    
        [self.delegate presetManger:self applyConfig:self.presetSelectedToConnect];
    
    }
    
//    if(presetSelectedToConnectActionTarget && [presetSelectedToConnectActionTarget respondsToSelector:presetSelectedToConnectAction]){
//        //TODO: VALID SELECTOR
//        //[self.delegate respondsToSelector:@selector(simplePing:didTimeoutWaitingForResponsePacket:)]
//        
//        [presetSelectedToConnectActionTarget performSelector:presetSelectedToConnectAction withObject:self.presetSelectedToConnect];
//    
//            
//        
//    }
    
}

- (IBAction)savePresetClicked:(id)sender {
    
    [_presetList replaceObjectAtIndex:[_presetList indexOfObject:self.openedPreset] withObject:self.editPresetConfigController.configuration];
    [self savePresetsToFile];
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


-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    return _presetList[row];


}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    //NSLog(@"tableView");
    sshConfig *config = _presetList[row];
    
    myTableCellView *cellview = [tableView makeViewWithIdentifier:@"presetItem" owner:[NSApp delegate]];
    
    //Display hostname on the list.
    [cellview.textField setStringValue:config.presetName];
    [cellview setObjectValue:config];
	
	NSInteger progressValue = 0;
	
	if(config.pingTime == -1){
		
		progressValue = 0;
	}
	else if(config.pingTime >0 && config.pingTime <1000){
		
		progressValue = 10 - ((NSInteger)(config.pingTime / 100));
		
	}
	else{
		
		progressValue = 0;
	}
	
    [cellview setProgressValue:[NSNumber numberWithInteger:progressValue]];

    if(!cellArray){
    
        cellArray = [[NSMutableArray alloc]init];
        
    }
    
    
    [cellArray addObject:cellview];
    
    return cellview;

}



-(void)tableViewSelectionDidChange:(NSNotification *)notification{

    
    NSLog(@"tableViewSelectionDidChange");
    //myTableView *table = [notification object];
    
//
//    if(lastSelectedCell){
//        lastSelectedCell.textField.textColor = orangeColor;
//    }
//    
//    myTableCellView *selectedCell = table.selectedCell;
//    
//    selectedCell.isSelected = TRUE;
//    selectedCell.textField.textColor = darkColor;
//    
//    lastSelectedCell = selectedCell;

    
    
}

-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{

    myTableRowView *rowView = [[myTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 50)];
    
    return rowView;

}




-(IBAction)closeSheetClicked:(id)sender{
    
    if(_isEditingMode){
    
        NSAlert *closeAlert  = [[NSAlert alloc]init];
        closeAlert.messageText = @"Close the window without saving preset?";
        [closeAlert addButtonWithTitle:@"YES"];
        [closeAlert addButtonWithTitle:@"NO"];
        [closeAlert beginSheetModalForWindow:sheet
                               modalDelegate:self didEndSelector:@selector(closeAlertDidEnd:) contextInfo:NULL];
        
        return;
    
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

- (BOOL)importPresets:(out NSString *)error{
    
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
//    [openDialog setDelegate:self];
    [openDialog setCanChooseFiles:YES];
    [openDialog setCanChooseDirectories:NO];
    [openDialog setAllowsMultipleSelection:NO];
    [openDialog setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"bspresets",@"BSPRESETS",nil]];

    
    if([openDialog runModal]==NSOKButton){
        
        //TODO: import presets
        
        
        NSMutableArray *_presetsFromFile = [[NSMutableArray alloc]init];
        
        NSURL *path = [openDialog URL];
        NSData *plistData = [NSData dataWithContentsOfURL:path];
        if(!plistData){
            
            //throw error
            error = @"FILE IS EMPTY";
            return FALSE;
            
        }
        
        //NSString *error;
        
        NSPropertyListFormat format;
        
        NSArray *plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        
        if(error){
            return FALSE;
        }
        
        _presetsFromFile = [self convertDictionaryListToSshConfigList:plist];
        
        if(_presetsFromFile){
            [_presetList addObjectsFromArray:_presetsFromFile];
        }
        
        [self.presetTebleView reloadData];
        
        [self savePresetsToFile];
        
        return TRUE;
        //return _presetsFromFile;
    
        
    
    }
    
    return FALSE;

}

- (BOOL)exportPresets:(out NSString *)error{
    
    NSSavePanel *savePanel = [[NSSavePanel alloc]init];
    
    [savePanel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"bspresets",nil]];
    
    if([savePanel runModal]==NSOKButton){
    
        
        NSArray *presetListForXmlData = [self convertSshConfigListToDictionaryList:_presetList];
        NSURL *path = [savePanel URL];
        NSData *xmlData;

        xmlData = [NSPropertyListSerialization dataFromPropertyList:(id)presetListForXmlData format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
        
        if(xmlData){
            //write xmlData into file.
            NSLog(@"Writing xml data into file.");
            [xmlData writeToURL:path atomically:YES];
            NSLog(@"Done writing xml data.");
            return TRUE;
        }
        else{
            
            return FALSE;
            //NSLog(@"Error occurs when trying to write xml data into property list file. \nError: %@",error);
            
        }
        
    
    }
    return FALSE;
    


}


-(BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename{
    
    NSString* ext = [filename pathExtension];
    if ([ext isEqual: @""] || [ext isEqual: @"/"] || ext == nil || ext == NULL || [ext length] < 1) {
        return TRUE;
    }
    
    NSLog(@"Ext: '%@'", ext);
    
    if([ext caseInsensitiveCompare:@"bspreset"]){
        return TRUE;
    }
    

//    NSEnumerator* tagEnumerator = [[NSArray arrayWithObjects:@"png", @"tiff", @"jpg", @"gif", @"jpeg", nil] objectEnumerator];
//    NSString* allowedExt;
//    while ((allowedExt = [tagEnumerator nextObject]))
//    {
//        if ([ext caseInsensitiveCompare:allowedExt] == NSOrderedSame)
//        {
//            return TRUE;
//        }
//    }

    
    return FALSE;
}


#pragma mark - SimplePing

static NSString * DisplayAddressForAddress(NSData * address)
// Returns a dotted decimal string for the specified address (a (struct sockaddr)
// within the address NSData).
{
    int         err;
    NSString *  result;
    char        hostStr[NI_MAXHOST];
    
    result = nil;
    
    if (address != nil) {
        err = getnameinfo([address bytes], (socklen_t) [address length], hostStr, sizeof(hostStr), NULL, 0, NI_NUMERICHOST);
        if (err == 0) {
            result = [NSString stringWithCString:hostStr encoding:NSASCIIStringEncoding];
            assert(result != nil);
        }
    }
    
    return result;
}

- (NSString *)shortErrorFromError:(NSError *)error
// Given an NSError, returns a short error string that we can print, handling
// some special cases along the way.
{
    NSString *      result;
    NSNumber *      failureNum;
    int             failure;
    const char *    failureStr;
    
    assert(error != nil);
    
    result = nil;
    
    // Handle DNS errors as a special case.
    
    if ( [[error domain] isEqual:(NSString *)kCFErrorDomainCFNetwork] && ([error code] == kCFHostErrorUnknown) ) {
        failureNum = [[error userInfo] objectForKey:(id)kCFGetAddrInfoFailureKey];
        if ( [failureNum isKindOfClass:[NSNumber class]] ) {
            failure = [failureNum intValue];
            if (failure != 0) {
                failureStr = gai_strerror(failure);
                if (failureStr != NULL) {
                    result = [NSString stringWithUTF8String:failureStr];
                    assert(result != nil);
                }
            }
        }
    }
    
    // Otherwise try various properties of the error object.
    
    if (result == nil) {
        result = [error localizedFailureReason];
    }
    if (result == nil) {
        result = [error localizedDescription];
    }
    if (result == nil) {
        result = [error description];
    }
    assert(result != nil);
    return result;
}


int rand_range(int min_n, int max_n)
{
    return rand() % (max_n - min_n + 1) + min_n;
}

- (IBAction)pingServersClicked:(id)sender{
	
    
    
    
//    bool success = false;
//    const char *host_name = [@"s1.123ssh.com"
//                             cStringUsingEncoding:NSASCIIStringEncoding];
//    
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL,
//                                                                                host_name);
//    SCNetworkReachabilityFlags flags;
//    success = SCNetworkReachabilityGetFlags(reachability, &flags);
//    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) &&
//    !(flags & kSCNetworkFlagsConnectionRequired);
//    if (isAvailable) {
//        NSLog(@"Host is reachable: %d", flags);
//    }else{
//        NSLog(@"Host is unreachable");
//    }
    

    
    [self.pingButton setEnabled:FALSE];
    
    [self.pingProgressIndicator setMinValue:0];
    [self.pingProgressIndicator setMaxValue:self.presets.count];
    [self.pingProgressIndicator setDoubleValue:0];
    [self.pingProgressIndicator setHidden:FALSE];
    [self.pingProgressIndicator startAnimation:self];
    [self.pingProgressIndicator incrementBy:1];
    
	totalPingTime = 0;
    currentPingingPresetIndex = 0;
    self.pinger = [SimplePing simplePingWithHostName:[(sshConfig *)_presetList[currentPingingPresetIndex] hostName]];
    self.pinger.delegate = self;
    pingCounter = 0;
    self.pinger.timeOut = 2;
    [self.pinger start];
    NSLog(@"%@",self.pinger.hostName);
	
	//TODO: active processing indicator of ping server.
    

}


//Set ping time to the perset of given index and reload the cell in preset table view.
- (void)setPingTimeToPresetAtIndex:(NSInteger)index pingTime:(NSInteger)pingTime{
	
	
       ((sshConfig *)_presetList[index]).pingTime = pingTime;
       [self.presetTebleView reloadDataForRowIndexes:[[NSIndexSet alloc]initWithIndex:index] columnIndexes:[[NSIndexSet alloc]initWithIndex:0]];

}


// Called to send a ping, both directly (as soon as the SimplePing object starts up)
// and via a timer (to continue sending pings periodically).
- (void)sendPing
{
    
    
    assert(self.pinger != nil);

    [self.pinger sendPingWithData:nil];
    pingCounter++;
    
}


// A SimplePing delegate callback method.  We respond to the startup by sending a
// ping immediately and starting a timer to continue sending them every second.
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
    assert(address != nil);
    
    NSLog(@"pinging %@", DisplayAddressForAddress(address));
    
    // Send the first ping straight away.
    
    [self sendPing];
    
    // And start a timer to send the subsequent pings.
    
    assert(self.sendTimer == nil);
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:pinger.timeOut+1 target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    
}


// A SimplePing delegate callback method.  We shut down our timer and the
// SimplePing object itself, which causes the runloop code to exit.
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(error)
    NSLog(@"failed: %@", [self shortErrorFromError:error]);
	
	//TODO:PingFaild
	//TODO:stop processing indicator
    
    [self.sendTimer invalidate];
    self.sendTimer = nil;
    
    // No need to call -stop.  The pinger will stop itself in this case.
    // We do however want to nil out pinger so that the runloop stops.
    
    self.pinger = nil;
    
    [self pingOver:-1];
}




// A SimplePing delegate callback method.  We just log the send.
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet
{
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    
    startPingTime = [NSDate date];
    NSLog(@"#%u sent", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber) );
    
    
    
}






// A SimplePing delegate callback method.  We just log the failure.
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error
{

#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
#pragma unused(error)
    NSLog(@"#%u send failed: %@", (unsigned int) OSSwapBigToHostInt16(((const ICMPHeader *) [packet bytes])->sequenceNumber), [self shortErrorFromError:error]);
    
	[self pingOver :-1];
}




// A SimplePing delegate callback method.  We just log the reception of a ping response.
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet
{
	

#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    
    NSTimeInterval duration = [startPingTime timeIntervalSinceNow];
	 // += (duration * -1000);
    NSLog(@"#%u received, time = %f ms", (unsigned int) OSSwapBigToHostInt16([SimplePing icmpInPacket:packet]->sequenceNumber),duration*-1000 );
    
	[self pingOver :(duration * -1000)];
}



// A SimplePing delegate callback method.  We just log the receive.
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{

    const ICMPHeader *  icmpPtr;
    
#pragma unused(pinger)
    assert(pinger == self.pinger);
#pragma unused(packet)
    
    icmpPtr = [SimplePing icmpInPacket:packet];
    if (icmpPtr != NULL) {
        NSLog(@"#%u unexpected ICMP type=%u, code=%u, identifier=%u", (unsigned int) OSSwapBigToHostInt16(icmpPtr->sequenceNumber), (unsigned int) icmpPtr->type, (unsigned int) icmpPtr->code, (unsigned int) OSSwapBigToHostInt16(icmpPtr->identifier) );
    } else {
        NSLog(@"unexpected packet size=%zu", (size_t) [packet length]);
    }
	
	[self pingOver :-1];
}


-(void)simplePing:(SimplePing *)pinger didTimeoutWaitingForResponsePacket:(NSInteger)timeOut{

    NSLog(@"ping time out.");
    [self pingOver:-1];


}


- (void)pingNextServer{

	
    [self.pinger stop];
    self.pinger = nil;
    [self.sendTimer invalidate];
    self.sendTimer = nil;

    
    if(currentPingingPresetIndex<[_presetList count]-1){
        //还没全部Ping完
        //开始ping下一个
        currentPingingPresetIndex ++;
        
        [self.pingProgressIndicator incrementBy:1];
 
        totalPingTime = 0;
        //Start pinging next Server with a new Pinger.
        self.pinger = [SimplePing simplePingWithHostName:[(sshConfig *)_presetList[currentPingingPresetIndex] hostName]];
        self.pinger.delegate = self;
        pingCounter = 0;
        [self.pinger start];
        NSLog(@"%@",self.pinger.hostName);
        return;
        
    }
    else{
        
        //全部Ping完了

		//TODO:stop processing indicator
        [self.pingProgressIndicator stopAnimation:self];
        [self.pingProgressIndicator setHidden:TRUE];
        [self.pingButton setEnabled:TRUE];
        return;
    
    }
	
}

- (void)pingOver:(NSInteger)pingTime{
	
	if(pingTime > 0){
		
		totalPingTime += pingTime;
		
	    if(pingCounter>=4){
			//当前服务器ping完了
			//set ping time to preset
				
			[self setPingTimeToPresetAtIndex:currentPingingPresetIndex pingTime:totalPingTime/4 ];
			[self pingNextServer];

	    }
		
	}
	else{
		//ping next
		
		
		[self setPingTimeToPresetAtIndex:currentPingingPresetIndex pingTime:-1 ];
		[self pingNextServer];

       
	}
	
	


    
	
}


@end




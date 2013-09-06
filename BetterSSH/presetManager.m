//
//  presetManager.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-6.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "presetManager.h"

@implementation presetManager{
    NSMutableArray *_presetList;

}


- (void)awakeFromNib{
    
    
    _presetList = [[NSMutableArray alloc] init];
    
    sshConfig *newConfig = [[sshConfig alloc] initWithDetail:@"S14.USASSH.COM" hostName:@"s14.usassh.com" portNumber:[NSNumber numberWithInt:443] sockPortNumber:[NSNumber numberWithInt:8088] userName:@"user1234" password:@"abcd1234" obfuscationKey:@"usassh"];
    
    
    [_presetList addObject:newConfig];
    
    newConfig = [[sshConfig alloc] initWithDetail:@"S15.USASSH.COM" hostName:@"s15.usassh.com" portNumber:[NSNumber numberWithInt:443] sockPortNumber:[NSNumber numberWithInt:8088]  userName:@"user1234" password:@"abcd1234" obfuscationKey:@"usassh"];
    
    
    [_presetList addObject:newConfig];
    
    //get presets from plist file.
    
    
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{

    return [_presetList count];
    
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (NSView *)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    sshConfig *config = _presetList[row];
    NSLog(@"WHAT");
    NSString *identifier = [tableColumn identifier];
    if([identifier isEqualToString:@"presetItem"]){
        
        NSTableCellView *cellview = [tableView makeViewWithIdentifier:@"presetItem" owner:self];
        [cellview.textField setStringValue:config.presetName];
        return cellview;
    
    }
    
    return nil;
    

}


@end




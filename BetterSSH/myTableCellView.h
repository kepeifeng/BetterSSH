//
//  myTableCellView.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-7.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface myTableCellView : NSTableCellView

@property IBOutlet NSTextField *backgroundLayer;

@property (nonatomic) BOOL isSelected;


@end

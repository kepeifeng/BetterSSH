//
//  myTableView.h
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-7.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "myTableCellView.h"

@interface myTableView : NSTableView

@property (nonatomic, readonly) myTableCellView *selectedCell;
@property (nonatomic, readonly) myTableCellView *lastSelectedCell;

@property NSColor *highlightColor;

@end

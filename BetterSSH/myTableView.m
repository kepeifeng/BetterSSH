//
//  myTableView.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-7.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "myTableView.h"

@implementation myTableView

myTableCellView *_lastSelectedCell;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}



-(NSColor *)highlightColor{

    return [NSColor redColor];
}

-(void)setHighlightColor:(NSColor *)highlightColor{

}


-(myTableCellView *)selectedCell{
    
    if(self.selectedRow<0)
        return nil;
    
    return [self viewAtColumn:self.selectedColumn row:self.selectedRow makeIfNecessary:FALSE];
    
    
    
}

-(myTableCellView *)lastSelectedCell{

    return _lastSelectedCell;
    
    
}

-(void)highlightSelectionInClipRect:(NSRect)clipRect{

    NSLog(@"highlightSelectionInClipRect");
}

@end

//
//  myTableRowView.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-17.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "myTableRowView.h"

@implementation myTableRowView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        orangeColor = [NSColor colorWithCalibratedRed:0.82 green:0.337 blue:0.102 alpha:1];
        darkColor = [NSColor colorWithSRGBRed:0.1529 green:0.1529 blue:0.1529 alpha:1];
    
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [super drawRect:dirtyRect];
}


-(void)drawSelectionInRect:(NSRect)dirtyRect{

    //[super drawSelectionInRect:dirtyRect];
    
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 2.5, 2.5);
        [orangeColor setStroke];
        [[NSColor colorWithCalibratedWhite:0 alpha:0] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:6 yRadius:6];
        [selectionPath fill];
        [selectionPath stroke];
    }
    
    
    
    
    
    
}
@end

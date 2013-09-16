//
//  myTableCellView.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-7.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "myTableCellView.h"

@implementation myTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.isSelected = FALSE;
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}


-(void)setIsSelected:(BOOL)isSelected{
    
    
    [self.backgroundLayer setDrawsBackground:isSelected];
    if(isSelected){
        
        self.textField.textColor = [NSColor colorWithSRGBRed:0.1529 green:0.1529 blue:0.1529 alpha:1];
        
        
    }else{
        
        self.textField.textColor = [NSColor colorWithCalibratedRed:0.82 green:0.337 blue:0.102 alpha:1];
 
        
    }
    
    
}






@end

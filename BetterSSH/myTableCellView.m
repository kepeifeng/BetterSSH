//
//  myTableCellView.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-7.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "myTableCellView.h"

@implementation myTableCellView

@synthesize isSelected = _isSelected;
@synthesize progressValue = _progressValue;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.isSelected = FALSE;
        _progressValue = 0;
        
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    
    [super drawRect:dirtyRect];

//    NSRect selectionRect = NSInsetRect(self.bounds, 1.5, 1.5);
//    [[NSColor redColor] setStroke];
//    [[NSColor colorWithCalibratedWhite:0 alpha:0] setFill];
//    NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:6 yRadius:6];
//    [selectionPath fill];
//    [selectionPath stroke];

    //NSLog(@"%@,progress = %ld",[(sshConfig *)[self objectValue] hostName],[_progressValue integerValue]);
    
    //NSImage *processImage = [NSImage imageNamed:[NSString stringWithFormat:@"progress-%ld.png",[_progressValue integerValue]]];
    //[processImage drawInRect:NSMakeRect(258, 34, 48, 12) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
}



-(BOOL)isSelected{

    
    return _isSelected;
    

}


-(void)setIsSelected:(BOOL)isSelected{
    
    _isSelected = isSelected;
    
    //[self.backgroundLayer setDrawsBackground:isSelected];
//    if(isSelected){
//        
//        self.textField.textColor = [NSColor colorWithSRGBRed:0.1529 green:0.1529 blue:0.1529 alpha:1];
//        
//        
//    }else{
//        
//        self.textField.textColor = [NSColor colorWithCalibratedRed:0.82 green:0.337 blue:0.102 alpha:1];
// 
//        
//    }
    
    
}

-(NSNumber *)progressValue{

    return _progressValue;
    
}

-(void)setProgressValue:(NSNumber *)newProgressValue{
    
    
    NSInteger progressValue = [newProgressValue integerValue];
    if(progressValue>=0 &&progressValue<=10){

        _progressValue = newProgressValue;
        
    }
    else if(progressValue>10){
    
        _progressValue = [NSNumber numberWithInteger:10];
    
    }
    else{
        
        _progressValue = [NSNumber numberWithInteger:0];
    
    }
    
    [self.imageView setImage:[NSImage imageNamed:[NSString stringWithFormat:@"progress-%ld.png",(long)progressValue]]];
    
//    [self updateTrackingAreas];
    
}








@end

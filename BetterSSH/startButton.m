//
//  startButton.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "startButton.h"

@interface startButton()

@property NSImage *button;
@property NSImage *start;
@property NSImage *circle;

@end

@implementation startButton



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
    // Drawing code here.
}

- (void)setStatus:(connectionStatus)status{
    
    if(status == DISCONNECT){
        
        self.button = [NSImage imageNamed:@"button.png"];
        self.start = [NSImage imageNamed:@"start_dark.png"];
        self.circle = [NSImage imageNamed:@"circle.png"];
    
    }
    else if(status == CONNECTTING){
        
        //self.button = [NSImage imageNamed:@"button.png"];
        self.start = [NSImage imageNamed:@"start_dark.png"];
        self.circle = [NSImage imageNamed:@"loading.gif"];
    
    }
    else if(status == CONNECTTED){
    
        self.start = [NSImage imageNamed:@"start_light.png"];
        self.circle = [NSImage imageNamed:@"circle_light.png"];
    }
    
    
    
}

@end

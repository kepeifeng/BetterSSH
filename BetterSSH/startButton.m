//
//  startButton.m
//  BetterSSH
//
//  Created by Kent Peifeng Ke on 13-9-5.
//  Copyright (c) 2013年 Kent Peifeng Ke. All rights reserved.
//

#import "startButton.h"

@interface startButton()

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
            
    }
    else if(status == CONNECTING){
            }
    else if(status == CONNECTED){
    
    }
    
    
    
}

@end

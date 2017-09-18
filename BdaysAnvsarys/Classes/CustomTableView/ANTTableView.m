//
//  ANTTableView.m
//  BdaysAnvsarys
//
//  Created by Swapnil Jain on 11/6/13.
//  Copyright (c) 2013 Arihant. All rights reserved.
//

#import "ANTTableView.h"

@implementation ANTTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.tableHeaderView.frame;
    rect.origin.y = MIN(0, self.contentOffset.y);
    self.tableHeaderView.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

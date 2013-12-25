//
//  TPDataModel.m
//  TPGestureTableViewDemo
//
//  Created by kavin on 13-3-19.
//  Copyright (c) 2013年 TangPin. All rights reserved.
//

#import "TPDataModel.h"

@implementation TPDataModel

@synthesize title=_title;
@synthesize detail=_detail;
@synthesize isExpand=_isExpand;
@synthesize dishDate = _dishDate;

- (void)dealloc
{
    self.title=nil;
    self.detail=nil;
    self.dishDate=nil;
    //[super dealloc];
}
@end

//
//  ChartLeftListDelegate.h
//  MathMonsters
//
//  Created by Xcode on 13-11-29.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChartLeftListDelegate <NSObject>
@optional
-(void)modelChanged:(NSString *)driverId;
@end

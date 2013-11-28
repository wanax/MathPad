//
//  GraphExchangeViewController.h
//  MathMonsters
//
//  Created by Xcode on 13-9-26.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphExchangeDelegate <NSObject>
@optional
-(void)keyWordChanged:(NSString *)key;
@end

@interface GraphExchangeViewController : UIViewController<UISearchBarDelegate>

@property (nonatomic,retain) id<GraphExchangeDelegate> delegate;

@property (nonatomic,retain) UISearchBar *searchBar;

@end

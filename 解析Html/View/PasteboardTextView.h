//
//  PasteboardTextView.h
//  GraspCourse
//
//  Created by admin10 on 2019/3/18.
//  Copyright © 2019年 sun. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PasteboardTextViewDelegateall <NSObject>

- (void)getContentSelected:(NSString *)content selectedIndex:(int)selectIndex;

@end

@interface PasteboardTextView : UITextView
@property (nonatomic,weak)id <PasteboardTextViewDelegateall> delegates;
@property (nonatomic,copy)NSString *showContent;
@end



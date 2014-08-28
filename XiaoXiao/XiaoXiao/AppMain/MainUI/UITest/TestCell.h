//
//  TestCell.h
//  WordPressMobile
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCell : UITableViewCell<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
{
    DTAttributedTextContentView *textContentView;
}

- (void)setContentHtmlAttributedString:(NSAttributedString*)attributedString;

+ (CGFloat)heightWithContentHtmlAttributedString:(NSAttributedString*)attributedString forTable:(UITableView*)table;

@end

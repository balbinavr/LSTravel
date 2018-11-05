//
//  CellActivityTableViewCell.m
//  LSTravel
//
//  Created by Balbina Virgili Rocosa on 30/8/16.
//  Copyright © 2016 Balbina Virgili Rocosa. All rights reserved.
//

#import "CellActivityTableViewCell.h"

@implementation CellActivityTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        
        for (UIView *subview2 in subview.subviews) {
            
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                
                [subview bringSubviewToFront:subview2];
                
            }
        }
    }
}

@end

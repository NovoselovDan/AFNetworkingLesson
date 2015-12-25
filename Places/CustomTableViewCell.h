//
//  CustomTableViewCell.h
//  Places
//
//  Created by Daniil Novoselov on 24.12.15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@end

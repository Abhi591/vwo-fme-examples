/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "LogTableViewCell.h"

@implementation LogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    // Type indicator view
    self.typeIndicatorView = [[UIView alloc] init];
    self.typeIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.typeIndicatorView.layer.cornerRadius = 4.0;
    [self.contentView addSubview:self.typeIndicatorView];
    
    // Type label
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.typeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.cornerRadius = 8.0;
    self.typeLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.typeLabel];
    
    // Message label
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.font = [UIFont systemFontOfSize:14.0];
    self.messageLabel.textColor = [UIColor labelColor];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.messageLabel];
    
    // Timestamp label
    self.timestampLabel = [[UILabel alloc] init];
    self.timestampLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timestampLabel.font = [UIFont systemFontOfSize:11.0];
    self.timestampLabel.textColor = [UIColor secondaryLabelColor];
    self.timestampLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timestampLabel];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Type indicator view
        [self.typeIndicatorView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16.0],
        [self.typeIndicatorView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.typeIndicatorView.widthAnchor constraintEqualToConstant:8.0],
        [self.typeIndicatorView.heightAnchor constraintEqualToConstant:8.0],
        
        // Type label
        [self.typeLabel.leadingAnchor constraintEqualToAnchor:self.typeIndicatorView.trailingAnchor constant:12.0],
        [self.typeLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8.0],
        [self.typeLabel.widthAnchor constraintGreaterThanOrEqualToConstant:60.0],
        [self.typeLabel.heightAnchor constraintEqualToConstant:20.0],
        
        // Message label
        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.typeLabel.trailingAnchor constant:12.0],
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8.0],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
        [self.messageLabel.bottomAnchor constraintEqualToAnchor:self.timestampLabel.topAnchor constant:-4.0],
        
        // Timestamp label
        [self.timestampLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16.0],
        [self.timestampLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8.0],
        [self.timestampLabel.heightAnchor constraintEqualToConstant:16.0]
    ]];
}

- (void)configureWithMessage:(NSString *)message type:(NSString *)type timestamp:(NSString *)timestamp {
    self.messageLabel.text = message;
    self.typeLabel.text = type;
    self.timestampLabel.text = timestamp;
    
    // Configure type label appearance based on type
    UIColor *typeColor = [self colorForLogType:type];
    self.typeLabel.backgroundColor = typeColor;
    self.typeIndicatorView.backgroundColor = typeColor;
    
    // Adjust type label width based on content
    CGSize typeSize = [type sizeWithAttributes:@{NSFontAttributeName: self.typeLabel.font}];
    CGFloat typeWidth = MAX(60.0, typeSize.width + 16.0);
    
    // Update type label width constraint
    for (NSLayoutConstraint *constraint in self.typeLabel.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = typeWidth;
            break;
        }
    }
}

- (UIColor *)colorForLogType:(NSString *)type {
    if ([type isEqualToString:@"INFO"]) {
        return [UIColor systemBlueColor];
    } else if ([type isEqualToString:@"USER"]) {
        return [UIColor systemGreenColor];
    } else if ([type isEqualToString:@"FEATURE_FLAG"]) {
        return [UIColor systemOrangeColor];
    } else if ([type isEqualToString:@"AB_TEST"]) {
        return [UIColor systemPurpleColor];
    } else if ([type isEqualToString:@"GOAL"]) {
        return [UIColor systemTealColor];
    } else if ([type isEqualToString:@"ERROR"]) {
        return [UIColor systemRedColor];
    } else if ([type isEqualToString:@"WARNING"]) {
        return [UIColor systemYellowColor];
    } else {
        return [UIColor systemGrayColor];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.messageLabel.text = nil;
    self.typeLabel.text = nil;
    self.timestampLabel.text = nil;
}

@end

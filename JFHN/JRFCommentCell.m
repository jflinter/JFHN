//
//  JRFCommentCell.m
//  JFHN
//
//  Created by Jack Flintermann on 10/17/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "JRFCommentCell.h"
#import "JRFComment.h"

#define rightPadding 10

@interface JRFCommentCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentLabel;
@end

@implementation JRFCommentCell

- (void) awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.commentLabel.textContainer.lineFragmentPadding = 0;
    self.commentLabel.textContainerInset = UIEdgeInsetsZero;
    self.commentLabel.delegate = self;
}

- (CGFloat) xForLabels {
    return (self.indentationLevel + 1) * 10;
}

- (CGFloat) widthForLabels {
    return self.frame.size.width - [self xForLabels] - rightPadding;
}

- (void) setIndentationLevel:(NSInteger)indentationLevel {
    [super setIndentationLevel:indentationLevel];
    CGRect authorFrame = self.authorLabel.frame;
    authorFrame.origin.x = [self xForLabels];
    authorFrame.size.width = [self widthForLabels];
    CGRect commentFrame = self.commentLabel.frame;
    commentFrame.origin.x = [self xForLabels];
    commentFrame.size.width = [self widthForLabels];
    self.authorLabel.frame = authorFrame;
    self.commentLabel.frame = commentFrame;
    UIEdgeInsets insets = self.separatorInset;
    insets.left = [self xForLabels];
    self.separatorInset = insets;
}

- (CGSize) intrinsicContentSize {
    CGFloat width = self.frame.size.width;
    CGSize size = self.commentLabel.frame.size;
    size.height = CGFLOAT_MAX;
    CGFloat commentHeight = [self.commentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[self attributesForComment] context:nil].size.height;
    CGFloat height = CGRectGetMinY(self.commentLabel.frame) + commentHeight + 11;
    return CGSizeMake(width, height);
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.commentLabel.frame = ({
        CGRect rect = self.commentLabel.frame;
        rect.size.height = CGRectGetHeight(self.frame) - CGRectGetMinY(rect) - 5;
        rect.size.width = CGRectGetWidth(self.frame) - CGRectGetMinX(rect) - 5;
        rect;
    });
}

- (void) configureWithComment:(JRFComment *)comment {
    self.authorLabel.text = comment.authorName;
    self.commentLabel.attributedText = [[NSAttributedString alloc] initWithString:comment.text attributes:[self attributesForComment]];
}

- (NSDictionary *)attributesForComment {
    return @{NSFontAttributeName: [UIFont secondaryAppFontWithSize:16], NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [self.delegate commentCellDidSelectURL:URL];
    return NO;
}

@end

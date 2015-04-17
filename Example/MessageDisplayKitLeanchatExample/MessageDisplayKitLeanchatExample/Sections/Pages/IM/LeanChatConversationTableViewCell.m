//
//  LeanChatConversationTableViewCell.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 iOS软件开发工程师 曾宪华 热衷于简洁的UI QQ:543413507 http://www.pailixiu.com/blog   http://www.pailixiu.com/Jack/personal. All rights reserved.
//

#import "LeanChatConversationTableViewCell.h"
#import "JSBadgeView.h"
#import "AVIMConversation+Custom.h"

@interface LeanChatConversationTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JSBadgeView *badgeView;

@end

@implementation LeanChatConversationTableViewCell

+(NSString*)indentifier{
    return NSStringFromClass([LeanChatConversationTableViewCell class]);
}

+(CGFloat)heightOfConversationTableViewCell{
    return kConversationTableViewCellImageSize+kConversationTableViewCellVerticalSpacing*2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.titleLabel];
}

-(UIImageView*)avatarImageView{
    if(_avatarImageView==nil){
        _avatarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kConversationTableViewCellHorizontalSpacing, kConversationTableViewCellVerticalSpacing, kConversationTableViewCellImageSize, kConversationTableViewCellImageSize)];
    }
    return _avatarImageView;
}

-(UILabel*)titleLabel{
    if(_titleLabel==nil){
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+kConversationTableViewCellHorizontalSpacing, CGRectGetMinY(_avatarImageView.frame), CGRectGetWidth(self.frame)-3*kConversationTableViewCellHorizontalSpacing-kConversationTableViewCellImageSize, CGRectGetHeight(_avatarImageView.frame))];
    }
    return _titleLabel;
}

-(JSBadgeView*)badgeView{
    if(_badgeView==nil){
        _badgeView=[[JSBadgeView alloc] initWithParentView:_avatarImageView alignment:JSBadgeViewAlignmentTopRight];
    }
    return _badgeView;
}

-(void)setConversation:(AVIMConversation *)conversation{
    _conversation=conversation;
    self.avatarImageView.image=[UIImage imageNamed:@"avator"];
    self.titleLabel.text=[conversation.members componentsJoinedByString:@"、"];
    if(conversation.unreadCount>0){
        self.badgeView.badgeText=[NSString stringWithFormat:@"%ld",(long)conversation.unreadCount];
    }else{
        self.badgeView.badgeText=nil;
    }
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

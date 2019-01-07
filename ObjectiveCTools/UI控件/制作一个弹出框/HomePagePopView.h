//
//  HomePagePopView.h
//  yuency
//
//  Created by yuency on 2019/7/19.
//  Copyright © 2019年 yuency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePagePopView : UIView

typedef void(^BlockClose)(void);

typedef void(^BlockClick)(void);

///标题
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
///副标题
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;
///图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
///文本
@property (weak, nonatomic) IBOutlet UITextView *textView;
///按钮事件
@property (nonatomic, strong) BlockClick blockClick;
///关闭
@property (nonatomic, strong) BlockClose blockClose;

///显示
+ (void)show:(nullable NSString *)title subTitle:(nullable NSString *)subtitle image:(nullable UIImage *)image content:(nullable NSString *)content click:(nullable BlockClick)click close:(nullable BlockClose)close;

///显示
- (instancetype)initWithFrame:(CGRect)frame;


@end


/*
 
 注意点:
 1.图片 UIImageView 的 content compression resistance priority - vertical 默认是 750, 这里我们不要做修改.
 2.图片 UIImageView 添加了一条距离 副标题的约束 和 一条距离主标题的约束, 这两个约束有冲突, 需要更改优先级
   因为距离副标题的优先级比较高(副标题会被移除), 距离副标题的约束优先级默认是1000,不做更改, 距离主标题的优先级改为  751.
 3.副标题控件的 content compression resistance priority - vertical 改为 752.
 4.主标题控件的 content compression resistance priority - vertical 改为 753.
 5.满足上述大小关系, UIImageView 就不会产生'模糊的内容高度'这个说法.
 
 */



/*
 
 NSString *content = @"火星文（火星文：焱暒妏），趣味地意指地球人看不懂的文字，由符号、繁体字、日文、韩文、冷僻字或汉字拆分后的部分等非正规化文字符号组合而成。随着互联网的普及，年轻网民为求彰显个性，开始大量使用同音字、音近字、特殊符号来表音的文字。由于这种文字与日常生活中使用的文字相比有明显的不同并且文法也相当奇异，所以亦称火星文，趣指地球人看不懂的文字。火星文这种称法最早出现于台湾社会，随即流行于中国大陆、香港和海外华人社会，成为中文互联网上的一种普遍用法，并逐渐向现实社会中渗透，成为中国文字史的别致现象。在大量的85后，90后，95后，一族中有所使用，在游戏玩家中也屡屡出现火星文的角色名字。另外，在军事通信领域也用一些所谓的“火星文”。火星文由符号、繁体字、日文、韩文、冷僻字或汉字拆分后的部分等非正规化文字符号组合而成。怎么看都像是乱码或打错的字，用法也不同于汉字那么规范，从字面上根本无法了解。其实，“火星文”几年前就作为一种游戏用语在泡泡堂流行，接着又通过QQ资料及聊天快速传播，成为许多年轻人的共用语言。据考证，“火星文”起源于中国台湾地区，随着互联网的发展，一些上网族最初为了打字方便，用注音文替代一些常用文字在网上交流，达到了快速打字兼可理解内容的效果。很快，一些台湾网友觉得这种文字另类醒目，便把这种输入方式发扬光大。所以说互联网的发展为火星文的快速推广起到了推波助澜的作用，网络也就成了火星文发展的创业实验田。随着《劲舞团》等网游在大陆的流行，这一潮流随着网游等渠道进入大陆，一部分网友开始延续这种独特的文字，并自创了适合简体中文发挥的输入方式，比如“劳エ”(老公)、“侽喷叐”(男朋友)、“蒶ロ耐·”（很可爱）“伱傃谁”（你是谁）。当使用人群和新生词组形成一定规模后，出现了一些热衷软件开发的网络高手制作出“火星文”专用软件。转换软件的出现使得“火星文”具备了密码功能，它成了一个群体保护隐私的方法。在受众中，这年轻的群体成了火星文的追捧者和传播者。有些“火星汉字”只能在《康熙字典》或《辞海》才能查到，一般的新华字典都查不到。中国部分的“90后”，因为凸显个性而使用。火星文，字面可作火星人用的文字。随著互联网的普及，网友（尤其是年轻网友）开始大量使用以同音字、音近字、特殊符号来表音的文字。由于这种文字与日常生活中使用的文字相比有明显的不同并且相当奇异，故被称为火星文。";
 
 NSString *title_1 = @"莣了噯";
 
 NSString *title_2 = @"莪庰騑別妩選萚，軹煶罘厢弌錯侢錯。莪庰騑別妩選萚，軹煶罘厢弌錯侢錯。";
 
 NSString *subTitle_1 = @"zǎì葉廽丕詓魡曾經";
 
 NSString *subTitle_2 = @"過祛锝憱穰τā過祛，曾俓滭竟枳褆曾俓。過祛锝憱穰τā過祛，曾俓滭竟枳褆曾俓。";
 
 NSString *image = @"忘了爱.jpg";

 */

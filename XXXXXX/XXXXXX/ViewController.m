//
//  ViewController.m
//  XXXXXX
//
//  Created by 东健FO_OF on 2017/8/27.
//  Copyright © 2017年 夏东健. All rights reserved.
//

#import "ViewController.h"

#import "NSString+Helper.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 认识 UILabel 的 lineBreakMode
    //[self meetLineBreakModels];
    
    // 计算文字所占区域
    //[self computeTextSizeWithFont:14];
    
    // 富文本 的坑
    //[self AttributeText];
    
}

#pragma mark - 认识 UILabel 的 lineBreakMode
- (void)meetLineBreakModels
{
    //注意这个字符串中并不含有换行符以及其他特殊符号，只是单纯的汉字字母数字组合
    NSString *string = @"11222aaaaabbbbbcccccccddddddd第一行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第三行eeeeeffffffffgggggggghhhhhhhhiiiiiiiiiiiijjjjjjjjjj第四行3333333444444444445555555结束";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((Screen_Width - 300)/2, 100, 300, 10)];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.text = string;
    [label sizeToFit]; //自适应大小
    [self.view addSubview:label];
    
    //在这里我们会发现 label 的文字在 “单位” 之后发生了换行，
    //但是我们文字中并没有换行符，这其实是 label 的一个属性来控制的
    /*
     NSLineBreakByWordWrapping = 0,     	// 默认根据“单词”来换行，也就是label会默认认为一串连续的英文是一个单词,大家可以在上面string中字母部分中间插入一个空格，会发现界面就会发生改变
     NSLineBreakByCharWrapping,		// 只根据换行符换行，所有字符会依次排满label整行后才会另起一行
     NSLineBreakByClipping,		// 当文字过多的时候，label 会直接切除多余的文字不显示省略号
     NSLineBreakByTruncatingHead,	// 当文字过多的时候，label 会省略最前面的部分作为 省略号
     NSLineBreakByTruncatingTail,	// 当文字过多的时候，label 会省略最后面的部分作为 省略号
     NSLineBreakByTruncatingMiddle
     */
    
    //设置了这个属性之后，label中的文字就不会突然“断截了”
    
    //label.lineBreakMode = NSLineBreakByCharWrapping;
}

#pragma mark - 计算文字所占区域
- (void)computeTextSizeWithFont:(NSInteger)font text:(NSString *)string
{
    // 前面的字符串并没有代表性，所以来个复杂点的， 加入了换行符 空格 再来看看计算高度
    string = @"11222aaaaabbbbbcccccccddddddd第一行  \n  第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行  \n  第三行eeeeeffffffffgggggggghhhhhhhhiiiiiiiiiiiijjjjjjjjjj第三行 \n 第四行3333333444444444445555555结束";
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    //[label sizeToFit]; //自适应大小
    [self.view addSubview:label];
    label.text = string;
    
    // 这里是关键
    CGSize textSize = [string textSizeWithFont:[UIFont systemFontOfSize:font]
                             constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:font];
    label.frame = CGRectMake((Screen_Width - 300)/2, 100, 300, textSize.height);

}

#pragma mark - 富文本 的坑
- (void)AttributeText
{
    //注意这个字符串中并不含有换行符以及其他特殊符号，只是单纯的汉字字母数字组合
    NSString *string = @"11222aaaaabbbbbcccccccddddddd第一行第二行第二行第二行第二行第二行第二行第二行第二行第二行第二行第三行eeeeeffffffffgggggggghhhhhhhhiiiiiiiiiiiijjjjjjjjjj第四行3333333444444444445555555结束";
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor greenColor];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    // 注意这里
    // 注意这里
    // 注意这里
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(0, string.length)];
    //设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:0];
    [attributString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, string.length)];
    
    CGSize textSize = [string textSizeWithFont:[UIFont systemFontOfSize:14]
                             constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    label.frame = CGRectMake((Screen_Width - 300)/2, 100, 300, textSize.height);
    label.attributedText = attributString;
    
    // ?????? 居中对齐失效了？ 其实这里的坑就在行间距，设置了行间距之后就必须要重新设置对齐，
    // 如果不设置行间距，那么富文本还是能够居中对齐的
    
    // 不信，打开下面的注释看看？
    // 不信，打开下面的注释看看？
    // 不信，打开下面的注释看看？
    //label.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end

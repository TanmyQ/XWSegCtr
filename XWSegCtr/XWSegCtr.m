//
//  XWSegCtr.m
//  QQ:286218985
//
//  Created by viviwu on 16/4/18.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWSegCtr.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kItemW [UIScreen mainScreen].bounds.size.width/5
#define kItemH 35.0f
#define kScrollLineH    2.0f

@interface XWSegCtr()

@property ( nonatomic, strong) UIScrollView * bgScroll;
@property ( nonatomic, strong) UIView *scrollLine;
//@property ( nonatomic, strong) NSMutableArray * labels;

@end

@implementation XWSegCtr

-(id)initWithFrame:(CGRect)frame Titles:(NSArray*)titles
{
    CGRect rect=frame;
    frame.size.height=kItemH;
    frame=rect;
    self=[super initWithFrame:frame];
    if (self) {
        self.titles=titles;
        [self proxyDefaultPreferences];
        [self addScroll];
        [self configTitlesLabel];

    }
    return self;
}
-(void)awakeFromNib
{
    self.titles=_titles;
    [self proxyDefaultPreferences];
    [self addScroll];
    [self configTitlesLabel];
}

-(void)addScroll{
    if (nil==_bgScroll) {
        _bgScroll=[[UIScrollView alloc]initWithFrame:self.frame];
        [self addSubview:_bgScroll];
    }
    
    [_bgScroll setFrame:CGRectMake(0, 0, kScreenW, kItemH)];
    _bgScroll.backgroundColor=[UIColor whiteColor];
    _bgScroll.delegate=(id)self;
    _bgScroll.scrollEnabled = YES;
    _bgScroll.showsVerticalScrollIndicator = NO;
    _bgScroll.showsHorizontalScrollIndicator = YES;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
     self.bgScroll.backgroundColor=self.backgroundColor;
    [self configTitlesLabel];
 
}

-(void)addnewItemTitle:(NSString*)title
{
    NSMutableArray * mArr=[NSMutableArray arrayWithArray:_titles];
    [mArr addObject:title];
    _titles=mArr;
    [self configTitlesLabel];
}

-(void)addNewItemsTitles:(NSArray*)titles
{
    NSMutableArray * mArr=[NSMutableArray arrayWithArray:_titles];
    for (NSString *title in titles) {
        if ([title isKindOfClass:[NSString class]]) {
            [mArr addObject:title];
        }
    }
    _titles=mArr;
    [self configTitlesLabel];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _bgScroll.contentSize=CGSizeMake(kItemW*_titles.count, 0);
}

- (void)configTitlesLabel{
    
    _bgScroll.contentSize=CGSizeMake(kItemW*_titles.count, 0);
    _bgScroll.directionalLockEnabled = YES;
    _bgScroll.alwaysBounceVertical = NO;
    [_bgScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    [self.labels removeAllObjects];
    for (int i = 0;  i < self.titles.count; i++)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * kItemW, 0, kItemW, kItemH)];
        titleLabel.text = [self.titles objectAtIndex:i];
        titleLabel.textColor =  self.titleColor;
        titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (_isSeparated) {
            if (i < self.titles.count - 1) {
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kItemW - 0.5, kItemH/7*2, 1.0, kItemH/7*3)];
                [line setBackgroundColor:[UIColor lightGrayColor]];
                [titleLabel addSubview:line];
            }
        }
        titleLabel.tag = 100+i;
        titleLabel.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabelWithGesture:)];
        tap.numberOfTapsRequired = 1;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tap]; 
        [_bgScroll addSubview:titleLabel];
//        [self.labels addObject:titleLabel];
    }
    _scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, kItemH - kScrollLineH, kItemW, kScrollLineH)];
    [_scrollLine setBackgroundColor:self.selectedColor];
    [_bgScroll addSubview:_scrollLine];
    
    [self selectLabelWithIndex:self.selectedIndex];
}

- (void)touchLabelWithGesture:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = label.tag - 100;
    [self selectLabelWithIndex:index];
    if (self.selectedIndexHandle) {
        self.selectedIndexHandle(index);
    }
}

- (void)selectLabelWithIndex:(NSInteger)index{
    UILabel *selectedLabel = [self viewWithTag:index+100];
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *label = [self viewWithTag:100+i];
        if ([label isEqual:selectedLabel]) {
            label.textColor = self.selectedColor;
        }else{
            label.textColor = self.titleColor;
        }
    }
    CGRect scrollLineFrame = _scrollLine.frame;
    scrollLineFrame.origin.x = kItemW*index;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollLine setFrame:scrollLineFrame];
    }];
    if ([self.touchDelegate respondsToSelector:@selector(SelectedItemWithIndex:)]) {
        [self.touchDelegate SelectedItemWithIndex:index];
    }
    
}


-(void)proxyDefaultPreferences
{
//    self.labels=[NSMutableArray array];
    self.backgroundColor=[UIColor whiteColor];
    self.titleColor=[UIColor lightGrayColor];
    self.titleFontSize=17.0;
    self.selectedColor=[UIColor greenColor];
    self.isSeparated=NO;
    self.selectedIndex=0;
}


- (void)changeTitleColorWithColor:(UIColor *)color{
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.textColor = color;
    }
}

- (void)changeTitleLabelFontWithFont:(CGFloat)font{
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self viewWithTag:100+i];
        label.font = [UIFont systemFontOfSize:font];
    }
}

@end

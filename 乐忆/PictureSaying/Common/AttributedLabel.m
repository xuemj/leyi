//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"
#import "UIView+Additions.h"
#import "NSAttributedString+Additions.h"

#define limitHeight 100000

@interface AttributedLabel(){

}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;

- (void)dealloc{
    [_attString release];
    [_URLs release];
    if (_framesetter)
    {
        CFRelease(_framesetter);
        _framesetter = NULL;
    }
    if (_frame)
    {
        CFRelease(_frame);
        _frame = NULL;
    }
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initData];
}

-(void)initData
{
    _topOffset = 10;
    _URLs = [[NSMutableDictionary alloc] init];
    _isNeedLineBreakMode = NO;
}

-(void)setAutoresizeWithLimitWidth:(float)limitWidth
{
    int total_height = 0;

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, limitWidth, limitHeight);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,[_attString length]), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    if ([linesArray count] == 1)
    {
        float width = [_attString getWidthAutoresizeWithLimitWidth:limitWidth];
        [self setFrame_width:width];
    }
    else
    {
        [self setFrame_width:limitWidth];
    }
        
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    if ([linesArray count] > 0)
    {
        CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = limitHeight - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
        [self setFrame_height:total_height];
    }
    else
    {
        [self setFrame_height:0];
    }
    CFRelease(textFrame);
}

+(float)getHeightWithLimitWidth:(float)limitWidth string:(NSString *)string font:(UIFont *)font
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL)
                       range:NSMakeRange(0, string.length)];
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, limitWidth, limitHeight);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,[attString length]), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    if ([linesArray count] > 0)
    {
        CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        total_height = limitHeight - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
        
        CFRelease(textFrame);
        return total_height;
    }
    else
    {
        CFRelease(textFrame);
        return 0;
    }
}

- (void)drawRect:(CGRect)rect{
    @synchronized(self)
    {
        context = UIGraphicsGetCurrentContext();//注，像许多低级别的API，核心文本使用的Y翻转坐标系 更杯具的是，内容是也渲染的翻转向下！
        //手动翻转,注，每次使用可将下面三句话复制粘贴过去。必用
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height+_topOffset);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGMutablePathRef path = CGPathCreateMutable();//1,外边框。mac支持矩形和圆，ios仅支持矩形。本例中使用self.bounds作为path的reference
        CGPathAddRect(path, NULL, self.bounds);
        
        //MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
        
        //NSAttributedString *attString = [p attrStringFromMarkup:@"Hello <font color=\"red\">core text <font color=\"blue\">world!"];
        //[[[NSAttributedString alloc]initWithString:@"Hello core text World!"] autorelease];//2,在core text中，不再使用NSString应使用NSAttributedString。它是NSString的一个衍生类，允许你应用文本格式属性
        
        if (_framesetter)
        {
            CFRelease(_framesetter);
            _framesetter = NULL;
        }
        _framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attString);//3CTFramesetter是最重要的类时使用的绘图核心文本。管理您的字体引用和绘制文本框。就目前而言，你需要知道什么是CTFramesetterCreateWithAttributedString为您将创建一个CTFramesetter的，保留它，并使用附带的属性字符串初始化。在本节中，你有framesetter后你创建一个框架，你给CTFramesetterCreateFrame，呈现了一系列的字符串（我们选择这里的整个字符串）和矩形绘制文本时会出现。
        if (_frame)
        {
            CFRelease(_frame);
            _frame = NULL;
        }
        
        _frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, [_attString length]), path, NULL);
//        CTFrameDraw(_frame, context);//4绘制
        if (_frame)
        {
            CFArrayRef lines = CTFrameGetLines(_frame);
            CGPoint lineOrigins[CFArrayGetCount(lines)];
            CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), lineOrigins);
            for (int i = 0; i < CFArrayGetCount(lines); i++) {
                CTLineRef line = CFArrayGetValueAtIndex(lines, i);
                CGContextSetTextPosition(context,  lineOrigins[i].x, lineOrigins[i].y);
                CTLineDraw(line, context);
            }
        }
        
        if (path != NULL)
        {
            CFRelease(path);
        }
    }
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
        [self setFont:self.font fromIndex:0 length:[text length]];
        
        if (_isNeedLineBreakMode)
        {
            CTParagraphStyleSetting lineBreakMode;
            CTLineBreakMode lineBreak = kCTLineBreakByTruncatingTail;
            lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
            lineBreakMode.value = &lineBreak;
            lineBreakMode.valueSize = sizeof(CTLineBreakMode);
            
            CTParagraphStyleSetting settings[] = {
                lineBreakMode
            };
            
            CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
            
            
            // build attributes
            NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName];
            
            // set attributes to attributed string
            [_attString addAttributes:attributes range:NSMakeRange(0, [_attString length])];
        }
    }
}

// 设置某段字的带有下划线
- (void)setUnderlineFromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    NSRange range = NSMakeRange(location, length);
    NSString *urlString = [self.text substringWithRange:range];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url)
    {
        [_URLs setObject:[NSURL URLWithString:urlString] forKey:NSStringFromRange(range)];
    }
    
    [_attString addAttribute:(NSString *)NSUnderlineStyleAttributeName
                       value:[NSNumber numberWithInteger:kCTUnderlineStyleSingle]
                       range:NSMakeRange(location, length)];
    [self setColor:[UIColor blueColor] fromIndex:location length:length];
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                       font.pointSize,
                                                       NULL)
                        range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
}

-(BOOL)labelTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    NSURL *url = [self urlForPoint:point];
    if (url)
    {
        if ([self.delegate respondsToSelector:@selector(attributedLabel:openUrl:)])
        {
            [self.delegate attributedLabel:self openUrl:url];
        }
    }
    return url?YES:NO;
//    NSDictionary *attribute = [_attString attributesAtIndex:0 effectiveRange:NULL];
//    ITLog(attribute);
//    NSNumber *num = [attribute objectForKey:(NSString *)kCTUnderlineStyleAttributeName];
//    if (num.intValue == kCTUnderlineStyleSingle)
//    {
//        
//    }
}

- (NSURL *)urlForPoint:(CGPoint)point
{
	CGMutablePathRef mainPath = CGPathCreateMutable();
        CGPathAddRect(mainPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
	
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attString);
    CFRelease(framesetter);
    CGPathRelease(mainPath);
	
    NSArray *lines = (__strong NSArray *)CTFrameGetLines(_frame);
    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    
    if (lineCount != 0) {
		
		CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), origins);
		
		for (int i = 0; i < lineCount; i++) {
			CGPoint baselineOrigin = origins[i];
			//the view is inverted, the y origin of the baseline is upside down
			baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
			
			CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
			CGFloat ascent, descent;
			CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
			
			CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
			
			if (CGRectContainsPoint(lineFrame, point)) {
				//we look if the position of the touch is correct on the line
				
				CFIndex index = CTLineGetStringIndexForPosition(line, point);
                
				NSArray *urlsKeys = [_URLs allKeys];
				
				for (NSString *key in urlsKeys) {
					NSRange range = NSRangeFromString(key);
					if (index >= range.location && index < range.location + range.length) {
						NSURL *url = [_URLs objectForKey:key];
						return url;
					}
				}
            }
		}
	}
	return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

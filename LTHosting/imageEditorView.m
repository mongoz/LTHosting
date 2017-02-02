//
//  imageEditorView.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/12/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "imageEditorView.h"
#import "textToolViewController.h"
#import "borderToolViewController.h"
#import "usefulArray.h"

@interface  imageEditorView(){
    NSArray<smartLayer*>* layerStack;
    CALayer *baseLayer;
    CGSize baseLayerImageSize;
    
    smartLayer *selected;
    
    CGPoint panStart;
    CGFloat pinchStartScale;
    
    NSInteger panHelper;
    NSInteger pinchHelper;
    
    CGRect keyboardFrame;
    BOOL hasKeyboardFrame;
    
    UIView *textInputView;
    BOOL hasTranferredText;
    
    smartBorderLayer *borderLayer;
    
    smartTextLayer *bodyText;
    smartTextLayer *titleText;
}
@end

@implementation imageEditorView

static imageEditorView *sharedInstance=nil;

-(smartBorderLayer*)borderLayer{
    return borderLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary *keyboardInfo=[notification userInfo];
    NSValue *keyboardFrameBegin=[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect=[keyboardFrameBegin CGRectValue];
    keyboardFrame=keyboardFrameBeginRect;
    hasKeyboardFrame=YES;
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    
}

-(void)updateImageContainer
{
    
    [self updateImageContainerWithImage:[[event sharedInstance] image]];
}

-(void)updateImageContainerWithImage:(UIImage *)image
{
    [baseLayer removeFromSuperlayer];
    baseLayer=[CALayer layer];
    [baseLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [baseLayer setContentsGravity:kCAGravityResizeAspect];
    [baseLayer setContents:(id)image.CGImage];
    baseLayerImageSize=image.size;
    [self.layer addSublayer:baseLayer];
    [borderLayer removeFromSuperlayer];
    borderLayer=[smartBorderLayer newSmartBorderInParentRect:CGRectZero];
    [borderLayer setContentsGravity:kCAGravityResize];
    [borderLayer setContents:nil];
    [self.layer addSublayer:borderLayer];
    [self setFrame:self.frame];
    
}

-(void)setTitleAndBodyText
{
    NSAttributedString *currentBody=nil;
    NSAttributedString *currentTitle=nil;
    if(titleText!=nil)
    {
        currentTitle=[titleText textLayer].attributedText;
        [titleText removeFromSuperlayer];
    }
    if(bodyText!=nil)
    {
        currentBody=[bodyText textLayer].attributedText;
        [bodyText removeFromSuperlayer];
    }
    __block UIFont *bodyFont;
    __block UIFont *titleFont;
    if(currentBody!=nil)
    {
        [currentBody enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, currentBody.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop){
            bodyFont=(UIFont*)value;
            *stop=YES;
        }];
    }
    else
    {
        bodyFont=[self defaultBodyFont];
    }
    if(currentTitle!=nil)
    {
        [currentTitle enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, currentTitle.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop){
            titleFont=(UIFont*)value;
            *stop=YES;
        }];
    }
    else
    {
        titleFont=[self defaultTitleFont];
    }
    NSAttributedString *body=[[NSAttributedString alloc] initWithAttributedString:[[event sharedInstance] flyerBodyForCurrentState]];
    NSAttributedString *title=[[NSAttributedString alloc] initWithString:[[event sharedInstance] name]];
    CGFloat margin=44;
    CGRect titleFrame=CGRectMake(margin, margin, self.frame.size.width-margin*2, self.frame.size.height-margin*2);
    titleText=[[smartTextLayer alloc] initWithParentRect:titleFrame attributedString:title font:titleFont];
    
    CGFloat seperation=8;
    CGRect bodyFrame=CGRectMake(titleText.frame.origin.x, titleText.frame.origin.y+titleText.frame.size.height+seperation, self.frame.size.width-margin*2, self.frame.size.height-(titleText.frame.origin.y+titleText.frame.size.height+margin+seperation));
    bodyText=[[smartTextLayer alloc] initWithParentRect:bodyFrame attributedString:body font:bodyFont];
    
    [titleText.textLayer setTextColor:[UIColor whiteColor]];
    [bodyText.textLayer setTextColor:[UIColor whiteColor]];
    [titleText.textLayer setTextAlignment:NSTextAlignmentCenter];
    [bodyText.textLayer setTextAlignment:NSTextAlignmentCenter];
    
    [self.layer addSublayer:titleText];
    [self.layer addSublayer:bodyText];
}

-(UIFont*)defaultBodyFont
{
    return  [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
}

-(UIFont*)defaultTitleFont
{
    return [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
}

-(id)init
{
    if(self=[super init])
    {
        
        UIImage *chosenImage=[[event sharedInstance] image];
        baseLayer=[CALayer layer];
        [baseLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI_2)];
        [baseLayer setContentsGravity:kCAGravityResizeAspect];
        [baseLayer setContents:(id)chosenImage.CGImage];
        baseLayerImageSize=chosenImage.size;
        [self.layer addSublayer:baseLayer];
        

        //[baseLayer setMasksToBounds:YES];
        //[self setBounds:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*(baseLayer.bounds.size.height/baseLayer.bounds.size.width))];
        
        layerStack=[[NSArray alloc] init];
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [pan setDelegate:self];
        UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [pinch setDelegate:self];
        [self addGestureRecognizer:pan];
        [self addGestureRecognizer:pinch];
        
        panStart=CGPointZero;
        panHelper=0;
        pinchStartScale=0;
        pinchHelper=0;
        selected=nil;
        
        hasKeyboardFrame=NO;
        textInputView=nil;
        hasTranferredText=NO;
        
        /*CALayer *test=[CALayer layer];
        [test setBackgroundColor:[UIColor purpleColor].CGColor];
        [test setFrame:self.layer.bounds];
        [self.layer addSublayer:test];*/
        [self.layer setMasksToBounds:YES];
        
        titleText=nil;
        bodyText=nil;
    }
    return self;
}

-(IBAction)panFired:(UIPanGestureRecognizer*)pan
{
    if(selected!=nil)
    {
        if([pan state]==UIGestureRecognizerStateEnded)
        {
            panStart=CGPointZero;
        }
        else
        {
            NSInteger panCycle=3;
            panHelper=(panHelper+1)%panCycle;
            if(panHelper!=0)
            {
                return;
            }
            CGPoint translation=[pan translationInView:self];
            if(!(panStart.x==0&&panStart.y==0))
            {
                CGSize diff=CGSizeMake(translation.x-panStart.x, translation.y-panStart.y);
                [selected moveBy:diff];
            }
            panStart=translation;
        }
    }
}

-(IBAction)pinchFired:(UIPinchGestureRecognizer*)swipe
{
    if(selected!=nil)
    {
        if([swipe state]==UIGestureRecognizerStateEnded)
        {
            pinchStartScale=0;
        }
        else
        {
            NSInteger pinchCycle=3;
            pinchHelper=(pinchHelper+1)%pinchCycle;
            if(pinchHelper!=0)
            {
                return;
            }
            if(pinchStartScale!=0)
            {
                [selected scaleBy:swipe.scale/pinchStartScale];
            }
            pinchStartScale=swipe.scale;
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    CGSize prop=CGSizeMake(frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
    CGRect change=CGRectMake(frame.origin.x-self.frame.origin.x, frame.origin.y-self.frame.origin.y, prop.width, prop.height);
    [super setFrame:frame];
    [baseLayer setFrame:CGRectMake(0, frame.size.height/2-(frame.size.width*baseLayerImageSize.height/baseLayerImageSize.width)/2, frame.size.width, frame.size.width*baseLayerImageSize.height/baseLayerImageSize.width)];
    [borderLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self proportionalizeFrameForLayer:titleText withRect:change];
    [self proportionalizeFrameForLayer:bodyText withRect:change];
}

-(void)proportionalizeFrameForLayer:(CALayer*)layer withRect:(CGRect)rect
{
    CGRect currentFrame=layer.frame;
    [layer setFrame:CGRectMake(currentFrame.origin.x+rect.origin.x, currentFrame.origin.y+rect.origin.y, currentFrame.size.width*rect.size.width, currentFrame.size.height*rect.size.height)];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [baseLayer setFrame:bounds];
}

+(imageEditorView*)sharedInstance
{
    if(sharedInstance==nil)
    {
        sharedInstance=[[self alloc] init];
    }
    return sharedInstance;
}

-(CGSize)size
{
    return CGSizeMake(self.frame.size.width, self.frame.size.width);
}

//Add a layer

-(void)addBorderLayerWithThumbnail:(smartLayerThumbnail*)nail
{
    smartBorderLayer *newlayer=[smartBorderLayer newSmartBorderInParentRect:self.bounds];
    [newlayer setMirror:nail];
    [self pushSmartLayer:newlayer];
}

-(void)addTextLayerWithThumbnail:(smartLayerThumbnail*)nail
{
    NSBlockOperation *blockop=[NSBlockOperation blockOperationWithBlock:^{
        while(!hasTranferredText)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
        }
    }];
    [blockop setCompletionBlock:^{
        NSBlockOperation *block=[NSBlockOperation blockOperationWithBlock:^{
            smartTextLayer *newlayer=[smartTextLayer newSmartTextLayerInParentRect:self.bounds withTextView:(UITextView*)textInputView.subviews.firstObject];
            [newlayer setMirror:nail];
            [self pushSmartLayer:newlayer];
        }];
        [block setCompletionBlock:^{
        }];
        [[NSOperationQueue mainQueue] addOperation:block];
    }];
    [[NSOperationQueue new] addOperation:blockop];
}

-(void)setTitleString:(NSString *)string
{
    [titleText setText:string];
}

-(void)setBodyString:(NSString *)string
{
    [bodyText setText:string];
}

//Managing view stack
-(void)pushSmartLayer:(smartLayer*)layer
{
    smartLayer *adjusted=layer;
    adjusted.stackIndex=layerStack.count;
    [self.layer insertSublayer:adjusted atIndex:0];
    NSMutableArray *temp=[NSMutableArray arrayWithArray:layerStack];
    [temp addObject:adjusted];
    layerStack=temp;
    [self.layer displayIfNeeded];
}

-(void)popSmartLayer
{
    smartLayer *delete=[layerStack lastObject];
    [delete removeFromSuperlayer];
    if(delete==selected)
    {
        selected=nil;
    }
    NSMutableArray *temp=[NSMutableArray arrayWithArray:layerStack];
    [temp removeObjectAtIndex:temp.count-1];
    layerStack=temp;
}

-(void)removeSelectedLayer
{
    [selected removeFromSuperlayer];
    selected=nil;
    NSMutableArray *temp=[NSMutableArray arrayWithArray:layerStack];
    [temp removeObject:selected];
    layerStack=temp;
}

//Handling command from toolkitviewcontroller to create a new layer
-(void)createNewLayerWithController:(toolKitViewController *)controller thumbnail:(smartLayerThumbnail *)nail
{
    if([controller class]==[borderToolViewController class])
    {
        [self addBorderLayerWithThumbnail:nail];
    }
    else
    {
        [self addTextLayerWithThumbnail:nail];
    }
}

//Methods for handling swipe & pan gestures on imageeditorview


//Delegate methods for UIGestureRecognizer
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    pinchStartScale=0;
    panStart=CGPointZero;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    //uncomment below to not allow pinch & pan gestures to occur at the same time
    /*if(([gestureRecognizer class]==[UIPanGestureRecognizer class]&&[otherGestureRecognizer class]==[UIPinchGestureRecognizer class])||([gestureRecognizer class]==[UIPinchGestureRecognizer class]&&[otherGestureRecognizer class]==[UIPanGestureRecognizer class]))
    {
        return NO;
    }*/
    return YES;
}

//Get and set layer selected for editing
-(void)setSelectedLayer:(smartLayer *)layer
{
    BOOL noChange=selected==layer;
    if(selected!=nil&&!noChange)
    {
        [selected.mirror layerWasDeselected];
    }
    selected=layer;
    if(!noChange&&layer!=nil)
    {
        [selected.mirror layerWasSelected];
    }
}

-(smartLayer*)selectedLayer
{
    return selected;
}

//Reset layers, in case editing is cancelled
+(void)reset
{
    [sharedInstance removeFromSuperview];
    CGImageRelease((CGImageRef)sharedInstance->baseLayer.contents);
    sharedInstance=nil;
}

-(UIImage*)currentImage
{
    CGSize temp=[event sharedInstance].image.size;
    CGFloat xScale=temp.width/self.bounds.size.width;
    CGFloat yScale=temp.height/self.bounds.size.height;
    CGFloat scale=xScale;
    CGRect newFrame=self.frame;
    CGRect myFrame=self.frame;
    if(xScale<yScale)
    {
        scale=yScale;
        
    }
    else if(yScale<xScale)
    {
        scale=xScale;
    }
    newFrame=CGRectMake(myFrame.origin.x+myFrame.size.width/2*(1-xScale/scale), myFrame.size.height/2*(1-yScale/scale) , self.frame.size.width*(xScale/scale), self.frame.size.height*(yScale/scale));
    
    UIGraphicsBeginImageContextWithOptions(newFrame.size, NO, scale);
    [self drawViewHierarchyInRect:newFrame afterScreenUpdates:NO];
    //[layer.presentationLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *flyer = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  flyer;
}

-(void)setBorderLayer:(smartBorderLayer*)layer
{
    borderLayer=layer;
}

-(smartTextLayer*)titleLayer
{
    return titleText;
}

-(smartTextLayer*)bodyLayer
{
    return bodyText;
}

@end

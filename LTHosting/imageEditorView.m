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

@interface  imageEditorView(){
    NSArray<smartLayer*>* layerStack;
    CALayer *baseLayer;
    
    smartLayer *selected;
    
    CGPoint panStart;
    CGFloat pinchStartScale;
    
    NSInteger panHelper;
    NSInteger pinchHelper;
    
    CGRect keyboardFrame;
    BOOL hasKeyboardFrame;
    
    UIView *textInputView;
    BOOL hasTranferredText;
}
@end

@implementation imageEditorView

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
    [baseLayer setContents:(id)[event sharedInstance].image.CGImage];
}

-(id)init
{
    if(self=[super init])
    {
        
        UIImage *chosenImage=[event sharedInstance].image;
        baseLayer=[CALayer layer];
        [baseLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI_2)];
        [baseLayer setContentsGravity:kCAGravityResizeAspect];
        [baseLayer setContents:(id)chosenImage.CGImage];
        //[baseLayer setMasksToBounds:YES];
        //[self setBounds:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*(baseLayer.bounds.size.height/baseLayer.bounds.size.width))];
        [self.layer addSublayer:baseLayer];
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
    [super setFrame:frame];
    [baseLayer setFrame:self.bounds];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [baseLayer setFrame:bounds];
}

+(imageEditorView*)sharedInstance
{
    static imageEditorView *one=nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        one=[[self alloc] init];
    });
    return one;
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
    [self beginTextEditing];
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
            [self endTextEditing];
        }];
        [[NSOperationQueue mainQueue] addOperation:block];
    }];
    [[NSOperationQueue new] addOperation:blockop];
}

-(void)beginTextEditing
{
    hasTranferredText=NO;
    UIView *shade=[[UIView alloc] initWithFrame:self.bounds];
    [shade.layer setBackgroundColor:[UIColor blackColor].CGColor];
    [shade setTintColor:[UIColor blackColor]];
    [shade.layer setOpacity:.5];
    UITextView *editor=[[UITextView alloc] initWithFrame:shade.bounds];
    [shade addSubview:editor];
    [shade bringSubviewToFront:editor];
    [editor setTextColor:[UIColor blackColor]];
    [editor setFont:[UIFont fontWithName:@"Keep Calm" size:32]];
    [editor setReturnKeyType:UIReturnKeyDone];
    [self addSubview:shade];
    [self bringSubviewToFront:shade];
    editor.delegate=self;
    [editor becomeFirstResponder];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textEditingLayerTapped:)];
    [editor addGestureRecognizer:tap];
    
    textInputView=shade;
    //[shade setFrame:CGRectMake(shade.frame.origin.x, shade.frame.origin.y, shade.frame.size.width, self.superview.frame.size.height-self.frame.origin.y-keyboardFrame.size.height)];
}

-(IBAction)textEditingLayerTapped:(UITapGestureRecognizer*)tap
{
    UITextView *tView=(UITextView*)tap.view;
    if(![tView.text isEqualToString:@""])
    {
        [self shouldEndTextEditing];
    }
}

-(void)shouldEndTextEditing
{
    hasTranferredText=YES;
}

-(void)endTextEditing
{
    if(textInputView!=nil)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[textInputView.subviews firstObject] endEditing:YES];
            [textInputView removeFromSuperview];
            textInputView=nil;
            [(smartTextLayer*)[self selectedLayer] centerView];
        }];
    }
}

//TextView delegate methods
-(void)textViewDidChange:(UITextView *)textView
{
    if([[textView.text substringFromIndex:textView.text.length-1] isEqualToString:@"\n"])
    {
        [textView setText:[textView.text substringToIndex:textView.text.length-1]];
        [self textViewDidEndEditing:textView];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self shouldEndTextEditing];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

//Managing view stack
-(void)pushSmartLayer:(smartLayer*)layer
{
    smartLayer *adjusted=layer;
    adjusted.stackIndex=layerStack.count;
    [self.layer addSublayer:adjusted];
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
-(void)reset
{
    while (layerStack.count>0) {
        [self popSmartLayer];
    }
    baseLayer=nil;
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

@end

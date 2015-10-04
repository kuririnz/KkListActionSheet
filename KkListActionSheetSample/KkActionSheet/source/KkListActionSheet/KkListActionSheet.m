//
//  ListActionSheet.m
//  RealmSample
//
//  Created by keisuke kuribayashi on 2015/09/12.
//  Copyright (c) 2015年 keisuke kuribayashi. All rights reserved.
//

#import "KkListActionSheet.h"

#define ANIM_ALPHA_KEY      @"animAlpha"
#define ANIM_MOVE_KEY       @"animMove"
#define ORIENT_PORTRAIT     @"PORTRAIT"
#define ORIENT_LANDSCAPE    @"LANDSCAPE"

@interface KkListActionSheet (){
    IBOutlet UIView *kkActionSheetBackGround;
    IBOutlet UIView *kkActionSheet;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *kkCloseButton;
    
    CGRect displaysize;
    CGFloat centerY;
    BOOL animatingFlg;
}
@end

@implementation KkListActionSheet

@synthesize delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        // init process
        displaysize = [[UIScreen mainScreen] bounds];
        self.hidden = YES;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self initalKkListActionSheet];
}

+ (instancetype) createInit: (UIViewController *) parent{
    NSString *className = NSStringFromClass([self class]);
    KkListActionSheet *initKkListActionSheet = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
    [parent.view addSubview:initKkListActionSheet];
    
    initKkListActionSheet.kkTableView.delegate = parent;
    initKkListActionSheet.kkTableView.dataSource = parent;
    
    return initKkListActionSheet;
}

- (void) initalKkListActionSheet {

    animatingFlg = NO;
    
    // Set BackGround Alpha
    kkActionSheetBackGround.alpha = 0.0f;

    // Setting ListActionSheet Layout
    kkActionSheet.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect kkActionSheetRect = kkActionSheet.frame;
    kkActionSheetRect.origin = CGPointMake(0, displaysize.size.height / 3);
    kkActionSheetRect.size.width = displaysize.size.width;
    kkActionSheetRect.size.height = (displaysize.size.height * 2) / 3;
    kkActionSheet.frame = kkActionSheetRect;
    
    // Setting CloseButton Layout
    kkCloseButton.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect closeBtnRect = kkCloseButton.frame;
    closeBtnRect.size.width = displaysize.size.width;
    closeBtnRect.size.height = displaysize.size.height * 0.07;
    kkCloseButton.frame = closeBtnRect;
    
    
    centerY = kkActionSheet.center.y;
    
    // BackGround TapGesuture Event
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(onTapGesture:)];
    [kkActionSheetBackGround addGestureRecognizer:tapGesture];

    // Close Button PanGesture Event
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(onPanGesture:)];
    [kkCloseButton addGestureRecognizer:panGesture];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(didRotation:)
                                                  name:@"UIDeviceOrientationDidChangeNotification"
                                                object:nil];
}

- (void) setTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void) setAttrTitle:(NSAttributedString *)attrTitle {
    titleLabel.attributedText = attrTitle;
}


- (IBAction) closePushBtn:(UIButton *) button {
    [self kkListActionSheetAnimation];
}

#pragma mark - Gesture Event
- (void) onTapGesture:(UITapGestureRecognizer *) recognizer {
    [self kkListActionSheetAnimation];
}

- (void) onPanGesture:(UIPanGestureRecognizer *) recognizer {
    CGPoint location = [recognizer translationInView:self];
    CGRect moveRect = kkActionSheet.frame;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (centerY > moveRect.origin.y + location.y) {
            [self kkListActionSheetReturenAnimation:moveRect.origin.y + location.y];
        } else {
            [self kkListActionSheetAnimation:moveRect.origin.y + location.y];
        }
    } else {
        if (displaysize.size.height / 3 < moveRect.origin.y + location.y) {
            moveRect.origin = CGPointMake(0, moveRect.origin.y + location.y);
            kkActionSheet.frame = moveRect;
        }
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
}

#pragma mark - Animation ListActionSheet
- (void) kkListActionSheetAnimation {
    [self kkListActionSheetAnimation:kkActionSheet.frame.size.height];
}

- (void) kkListActionSheetAnimation:(CGFloat) param {
    // During Animation End
    if (animatingFlg) return;
    
    animatingFlg = YES;
    CGFloat fromPositionY, toPositionY, toAlpha;
    CGFloat currentAlpha = kkActionSheetBackGround.alpha;
    if (currentAlpha == 0.0f) {
        fromPositionY = param;
        toPositionY = 0;
        toAlpha = .8f;
    } else {
        fromPositionY = 0;
        toPositionY = param;
        toAlpha = 0.0f;
    }
    
    CABasicAnimation *moveAnim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    moveAnim.duration = .5f;
    moveAnim.repeatCount = 1;
    moveAnim.autoreverses = NO;
    moveAnim.removedOnCompletion = NO;
    moveAnim.fillMode = kCAFillModeForwards;
    moveAnim.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    moveAnim.fromValue = [NSNumber numberWithFloat:fromPositionY];
    moveAnim.toValue = [NSNumber numberWithFloat:toPositionY];
    
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.delegate = self;
    alphaAnim.duration = .4f;
    alphaAnim.repeatCount = 1;
    alphaAnim.autoreverses = NO;
    alphaAnim.removedOnCompletion = NO;
    alphaAnim.fillMode = kCAFillModeForwards;
    alphaAnim.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    alphaAnim.fromValue = [NSNumber numberWithFloat:kkActionSheetBackGround.alpha];
    alphaAnim.toValue = [NSNumber numberWithFloat:toAlpha];
    
    self.hidden = NO;
    [kkActionSheet.layer addAnimation:moveAnim forKey:ANIM_MOVE_KEY];
    [kkActionSheetBackGround.layer addAnimation:alphaAnim forKey:ANIM_ALPHA_KEY];
}

- (void) kkListActionSheetReturenAnimation:(CGFloat) param {
    // During Animation End
    if (animatingFlg) return;
    
    animatingFlg = YES;
    [UIView animateWithDuration:.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect tmp = kkActionSheet.frame;
                         tmp.origin = CGPointMake(0, displaysize.size.height / 3);
                         kkActionSheet.frame = tmp;
                     }
                     completion:^(BOOL finished) {animatingFlg = NO;}];
}

#pragma mark - CABasicAnimation Method
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [kkActionSheetBackGround.layer animationForKey:ANIM_ALPHA_KEY]) {
        CABasicAnimation *currentAnimation = (CABasicAnimation *) anim;
        kkActionSheetBackGround.alpha = [currentAnimation.toValue floatValue];
        [kkActionSheetBackGround.layer removeAnimationForKey:ANIM_ALPHA_KEY];
        if (kkActionSheetBackGround.alpha == 0.0f) {
            self.hidden = YES;
            CGRect tmpPosition = kkActionSheet.frame;
            tmpPosition.origin = CGPointMake(0, displaysize.size.height / 3);
            kkActionSheet.frame = tmpPosition;
        }
        animatingFlg = NO;
    }
}

#pragma mark - change device rotate method
- (void) didRotation: (NSNotification *) notification {
    UIDeviceOrientation orientation = [[notification object] orientation];
    
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown) {
        NSLog(@"Orientation:Portrait");
        [self changeOrientationTransform:ORIENT_PORTRAIT];
    } else if (orientation == UIDeviceOrientationLandscapeLeft
               || orientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"Orientation:Landscape");
        [self changeOrientationTransform:ORIENT_LANDSCAPE];
    }
}

- (void) changeOrientationTransform: (NSString *) orientarion {
    if (!animatingFlg) {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect tmp = kkActionSheet.frame;
                             displaysize.size = [[UIScreen mainScreen] bounds].size;
                             tmp.origin = CGPointMake(0, displaysize.size.height / 3);
                             tmp.size.width = displaysize.size.width;
                             tmp.size.height = (displaysize.size.height * 2) / 3;
                             kkActionSheet.frame = tmp;
                             centerY = kkActionSheet.center.y;
                         }
                         completion:^(BOOL finished) {animatingFlg = NO;}];
    }
}
@end

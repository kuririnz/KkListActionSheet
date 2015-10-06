//
//  ListActionSheet.m
//  RealmSample
//
//  Created by keisuke kuribayashi on 2015/09/12.
//  Copyright (c) 2015年 keisuke kuribayashi. All rights reserved.
//

#import "KkListActionSheet.h"
#import "KkListCloseButton.h"

#define ANIM_ALPHA_KEY      @"animAlpha"
#define ANIM_MOVE_KEY       @"animMove"
#define ORIENT_PORTRAIT     @"PORTRAIT"
#define ORIENT_LANDSCAPE    @"LANDSCAPE"

@interface KkListActionSheet (){
    IBOutlet UIView *kkActionSheetBackGround;
    IBOutlet UIView *kkActionSheet;
    IBOutlet UILabel *titleLabel;
    IBOutlet KkListCloseButton *kkCloseButton;
    
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
    
    return initKkListActionSheet;
}

- (void) initalKkListActionSheet {

    animatingFlg = NO;
    
    // Set BackGround Alpha
    kkActionSheetBackGround.alpha = 0.0f;
    CGFloat largeOrientation = displaysize.size.width > displaysize.size.height? displaysize.size.width:displaysize.size.height;

    
    // Setting BackGround Layout
    kkActionSheetBackGround.translatesAutoresizingMaskIntoConstraints = YES;
    CGRect kkActionSheetBgRect = kkActionSheetBackGround.frame;
    kkActionSheetBgRect.size.width = largeOrientation;
    kkActionSheetBgRect.size.height = largeOrientation;
    kkActionSheetBackGround.frame = kkActionSheetBgRect;
    
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
    closeBtnRect.size.width = largeOrientation;
    closeBtnRect.size.height = displaysize.size.height * 0.085;
    CGFloat tmpX = closeBtnRect.size.width - displaysize.size.width;
    closeBtnRect.origin = CGPointMake(tmpX > 0 ? tmpX / 2 : 0, 0);
    kkCloseButton.frame = closeBtnRect;
    
    centerY = kkActionSheet.center.y;
    
    // BackGround TapGesuture Event
    UITapGestureRecognizer *backGroundTapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(onTapGesture:)];
    [kkActionSheetBackGround addGestureRecognizer:backGroundTapGesture];

    // Close Button PanGesture Event
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(onPanGesture:)];
    UITapGestureRecognizer *closeTapGesture = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(onTapGesture:)];
    [kkActionSheetBackGround addGestureRecognizer:backGroundTapGesture];

    [kkCloseButton addGestureRecognizer:panGesture];
    [kkCloseButton addGestureRecognizer:closeTapGesture];

    // set device change notification center
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

#pragma mark - Gesture Event
- (void) onTapGesture:(UITapGestureRecognizer *) recognizer {
    [self showHide];
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
- (void) showHide {
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

- (void) changeOrientationTransform: (NSString *) orientation {
    if (!animatingFlg) {
        [UIView animateWithDuration:.5f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect afterSheetRect = kkActionSheet.frame;
                             CGRect afterBtnRect = kkCloseButton.frame;
                             if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
                                 displaysize.size = [[UIScreen mainScreen] bounds].size;
                             } else {
                                 CGSize afterSize = [[UIScreen mainScreen] bounds].size;
                                 BOOL isLargeWidth = afterSize.width > afterSize.height;
                                 if ([orientation isEqualToString:ORIENT_PORTRAIT]) {
                                     displaysize.size.width = isLargeWidth ? afterSize.height : afterSize.width;
                                     displaysize.size.height = isLargeWidth ? afterSize.width : afterSize.height;
                                 } else if ([orientation isEqualToString:ORIENT_LANDSCAPE]) {
                                     displaysize.size.width = isLargeWidth ? afterSize.width : afterSize.height;
                                     displaysize.size.height = isLargeWidth ? afterSize.height : afterSize.width;
                                 }
                             }
                             
                             afterSheetRect.origin = CGPointMake(0, displaysize.size.height / 3);
                             afterSheetRect.size.width = displaysize.size.width;
                             afterSheetRect.size.height = (displaysize.size.height * 2) / 3;
                             
                             CGFloat tmpX = afterBtnRect.size.width - displaysize.size.width;
                             afterBtnRect.origin = CGPointMake(tmpX > 0 ? -(tmpX / 2) : 0, 0);

                             kkActionSheet.frame = afterSheetRect;
                             kkCloseButton.frame = afterBtnRect;
                             centerY = kkActionSheet.center.y;
                         }
                         completion:^(BOOL finished) {animatingFlg = NO;}];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.delegate kkTableView:tableView rowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.delegate kktableView:tableView currentIndex:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate kkTableView:tableView selectIndex:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

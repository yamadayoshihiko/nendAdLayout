//
//  ViewController.m
//  nendAdLayout
//
//  Created by y_yamada on 2015/12/17.
//  Copyright (c) 2015年 yy. All rights reserved.
//

#import "ViewController.h"

#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"

@interface ViewController ()

@property (nonatomic)         BOOL         isInited;
@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) QBPopupMenu *topPopupMenu;
@property (nonatomic)         NSInteger imageTagNumber;
@property (nonatomic, strong) NSMutableDictionary* dict;
@property (nonatomic)         CGAffineTransform    currentTransform;
@property (nonatomic)         CGPoint              point;
@property (nonatomic)         NSInteger            touchBeganTag;
@property (nonatomic)         NSInteger            trashTag;

@end

const unsigned long int TAG_TOP = 1;
const unsigned long int TAG_EVENT_PM  = 101;
const unsigned long int TAG_EVENT_PPM = 102;
const unsigned long int TAG_EVENT_LONG = 103;
const unsigned long int TAG_EVENT_IMAGE_LONG = 104;
const unsigned long int TAG_EVENT_30x30_LONG = 201;
const NSInteger TAG_IMAGE_NUMBER = 201;

const NSInteger AD_TYPE1 = 1;
const NSInteger AD_TYPE2 = 2;
const NSInteger AD_TYPE3 = 3;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = YES;
    self.view.tag = TAG_TOP;
    
    if (!self.isInited) {
        self.isInited = YES;
        
        self.imageTagNumber = TAG_IMAGE_NUMBER; // この番号から開始する
        
        // 背景を設定する
        UIImage* image = [UIImage imageNamed:@"tutorial.png"];
        ((UIImageView*)[self.view.subviews objectAtIndex:0]).image = image;
        // ロングタップ
        QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"" image:[UIImage imageNamed:@"trash"] target:self action:@selector(trashAction)];
        NSArray *items = @[item1];
        
        QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
        popupMenu.tag = TAG_EVENT_PM;
        popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
        self.popupMenu = popupMenu;
        
        // トップのロングタップ
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self.view addGestureRecognizer:longPress];
        
        // 壁紙ロングタップ
        self.topPopupMenu = [self makeTopPopupMenu:TAG_EVENT_LONG];
        
        self.dict = [NSMutableDictionary dictionary];
        
        // 画像1
        UIImageView* imageView1 = [self makeImageView:AD_TYPE3];
        imageView1.frame = CGRectMake(160, 40, 140, 44);
        NSNumber* index1 = [[NSNumber alloc] initWithLong:imageView1.tag];
        self.dict[index1] = imageView1;
        [self.view addSubview:imageView1];
        // 画像2
        UIImageView* imageView2 = [self makeImageView:AD_TYPE3];
        imageView2.frame = CGRectMake(160, 110, 140, 44);
        NSNumber* index2 = [[NSNumber alloc] initWithLong:imageView2.tag];
        self.dict[index2] = imageView2;
        [self.view addSubview:imageView2];
        // 画像3
        UIImageView* imageView3 = [self makeImageView:AD_TYPE3];
        imageView3.frame = CGRectMake(160, 190, 140, 44);
        NSNumber* index3 = [[NSNumber alloc] initWithLong:imageView3.tag];
        self.dict[index3] = imageView3;
        [self.view addSubview:imageView3];
        // 画像4
        UIImageView* imageView4 = [self makeImageView:AD_TYPE3];
        imageView4.frame = CGRectMake(160, 280, 140, 44);
        NSNumber* index4 = [[NSNumber alloc] initWithLong:imageView4.tag];
        self.dict[index4] = imageView4;
        [self.view addSubview:imageView4];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}

- (QBPopupMenu*)makeTopPopupMenu:(unsigned long int)tag
{
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"バナー風" target:self action:@selector(selectImage1Action)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"ロゴ記事風" target:self action:@selector(selectImage2Action)];
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"背景(SS)設定" target:self action:@selector(setBgAction)];
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"リセット" target:self action:@selector(resetAction)];
    NSArray *items = @[item1, item2, item3, item4];
    
    QBPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
    plasticPopupMenu.tag = tag;
    plasticPopupMenu.height = 40;
    
    return plasticPopupMenu;
}

- (UIImageView*)makeImageView:(NSInteger)adType
{
    UIImage *image;
    UIImageView *imageView;
    
    switch (adType) {
        case AD_TYPE1:
            image = [UIImage imageNamed:@"320x100.png"];
            imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0, 230, 320, 100);
            break;
        case AD_TYPE2:
            image = [UIImage imageNamed:@"100x160.png"];
            imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(160, 250, 100, 160);
            break;
        case AD_TYPE3:
            image = [UIImage imageNamed:@"160x50.png"];
            imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0, 230, 140, 44);
            break;
    }
    imageView.tag = self.imageTagNumber++;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    // 1回タップ
    UITapGestureRecognizer *singleTapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCallback:)];
    // 2回タップ
    UITapGestureRecognizer *doubleTapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapCallback:)];
    [doubleTapEvent setNumberOfTapsRequired:2];
    doubleTapEvent.delaysTouchesBegan = 1.0;
    doubleTapEvent.delaysTouchesEnded = 1.0;
    [singleTapEvent requireGestureRecognizerToFail:doubleTapEvent];
    
    [imageView addGestureRecognizer:singleTapEvent];
    [imageView addGestureRecognizer:doubleTapEvent];
    
    // ロングタップ
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress2Callback:)];
    [imageView addGestureRecognizer:longPress2];
    
    // ドラッグ
    UIPanGestureRecognizer *dragEvent = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragCallback:)];
    [imageView addGestureRecognizer:dragEvent];
    
    UIPinchGestureRecognizer *pinchEvent = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchCallback:)];
    [imageView addGestureRecognizer:pinchEvent];
    
    return imageView;
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPress/tag:%lu/self.tag:%lu/touchBeganTag:%lu", sender.view.tag, self.view.tag, self.touchBeganTag);
    
    if (sender.view.tag != self.touchBeganTag) {
        return;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"began");
            [self.topPopupMenu showInView:self.view targetRect:CGRectMake(self.point.x, self.point.y, 0, 0) animated:YES];
            NSLog(@"x:%f", sender.view.bounds.origin.x);
            NSLog(@"y:%f", sender.view.frame.size.width);
            break;
            
        case UIGestureRecognizerStateChanged:
            NSLog(@"changed");
            break;
            
        case UIGestureRecognizerStateEnded:
            NSLog(@"ended");
            break;
            
        default:
            NSLog(@"default/state:%lu", sender.state);
            break;
    }
}

- (void)selectImage1Action
{
    NSLog(@"selectImage1Action");
    
    // 画像view
    UIImageView* imageView = [self makeImageView:AD_TYPE1];
    NSNumber* index = [[NSNumber alloc] initWithLong:imageView.tag];
    self.dict[index] = imageView;
    
    // 登録
    [self.view addSubview:imageView];
}
- (void)selectImage2Action
{
    NSLog(@"selectImage2Action");
    
    // 画像view
    UIImageView* imageView = [self makeImageView:AD_TYPE2];
    NSNumber* index = [[NSNumber alloc] initWithLong:imageView.tag];
    self.dict[index] = imageView;
    
    // 登録
    [self.view addSubview:imageView];
}
- (void)setBgAction
{
    NSLog(@"setBgAction");
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"child:%@", self.childViewControllers );
    
    ((UIImageView*)[self.view.subviews objectAtIndex:0]).image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)resetAction
{
    NSLog(@"resetAction");
    
    // 生成した広告画像を全て削除する
    [self.dict enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, UIImageView* view, BOOL *stop) {
        [self.dict removeObjectForKey:key];
        [view removeFromSuperview];
    }];
    
    // 背景を真っ白へ変える
    UIImage* image = [UIImage imageNamed:@"white-640x1136.png"];
    ((UIImageView*)[self.view.subviews objectAtIndex:0]).image = image;
}
- (void)trashAction
{
    NSLog(@"trashAction");
    
    if (self.trashTag == 0) {
        return;
    }
    
    // 削除対象を探す
    NSNumber* index = [[NSNumber alloc] initWithLong:self.trashTag];
    UIImageView* imageView = self.dict[index];
    [self.dict removeObjectForKey:index];
    
    // トップのビューから削除する
    [imageView removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touch = [touches anyObject];
    self.touchBeganTag = touch.view.tag;
    NSLog(@"touchesBegan/tag:%lu/event:%@", touch.view.tag, event.class);
    UIView *view;
    switch (touch.view.tag) {
        case TAG_TOP      : view = self.view     ; break;
        case TAG_EVENT_PM : view = self.popupMenu; break;
        case TAG_EVENT_LONG: view = self.topPopupMenu; break;
        default:
            if (touch.view.tag >= TAG_IMAGE_NUMBER) {
                NSNumber* index = [[NSNumber alloc] initWithLong:touch.view.tag];
                view = self.dict[index];
            }
            break;
    }
    
    CGPoint point1 = [touch locationInView:view];
    NSString* m = NSStringFromCGPoint(point1);
    NSLog(@"point:%@", m);
    self.point = point1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    
    NSLog(@"multi:%lu", [touches count]);
}

- (UIView*)makeAd:(int)type
{
    UIView* view;
    return view;
}

- (void)longPressNullCallback:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPressNullCallback/tag:%lu", sender.view.tag);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"longPressNullCallback/began");
            break;
        default:
            NSLog(@"longPressNullCallback/default");
            break;
    }
}

- (void)tapCallback:(UITapGestureRecognizer*)sender
{
    NSLog(@"tapCallback/sender:%@", sender);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"began");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"changed");
            break;
        default:
            NSLog(@"default");
            break;
            
    }
}

- (void)doubleTapCallback:(UITapGestureRecognizer*)sender
{
    NSLog(@"doubleTapCallback/sender:%@", sender);
    
    // 横を幅いっぱいに拡大するので同じ比率で縦の高さを計算する
    float scale = 1.0;
    float width = 320;
    float height = 1;
    NSNumber* index = [[NSNumber alloc] initWithLong:sender.view.tag];
    UIImageView* imageView = self.dict[index];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"doubleTapCallback/began");
            break;
        case UIGestureRecognizerStateEnded:
            scale = 320.0 / imageView.frame.size.width;
            height = imageView.frame.size.height * scale;
            imageView.frame = CGRectMake(0, imageView.frame.origin.y, width, height);
            break;
        default:
            NSLog(@"doubleTapCallback/default");
            break;
    }
}

- (void)dragCallback:(UIPanGestureRecognizer*)sender
{
    NSLog(@"dragCallback/sender:%@", sender);
    
    NSNumber* index = [[NSNumber alloc] initWithLong:sender.view.tag];
    UIImageView* imageView = self.dict[index];
    
    CGPoint point = [sender translationInView:self.view];
    CGPoint movedPoint = CGPointMake(imageView.center.x + point.x, imageView.center.y + point.y);
    imageView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:self.view];
}

- (void)longPress2Callback:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPress2Callback/tag:%lu", sender.view.tag);
    
    NSNumber* index = [[NSNumber alloc] initWithLong:sender.view.tag];
    UIImageView* imageView = self.dict[index];
    NSLog(@"2:%lu", imageView.tag);
    
    float x;
    float y;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            x = imageView.frame.origin.x + (imageView.frame.size.width / 2);
            y = imageView.frame.origin.y + (imageView.frame.size.height / 2);
            [self.popupMenu showInView:self.view targetRect:CGRectMake(x, y, 0, 0) animated:YES];
            self.trashTag = sender.view.tag;
            break;
        default:
            NSLog(@"longPress2Callback/default");
            break;
    }
}

- (void)pinchCallback:(UIPinchGestureRecognizer*)sender
{
    NSLog(@"pinchCallback/sender:%@", sender);
    
    NSNumber* index = [[NSNumber alloc] initWithLong:sender.view.tag];
    UIImageView* imageView = self.dict[index];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"pinchCallback/began");
            self.currentTransform = imageView.transform;
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"pinchCallback/changed");
            CGFloat scale = [sender scale];
            NSLog(@"scale:%lf", scale);
            CGAffineTransform affine = CGAffineTransformMakeScale(scale, scale);
            imageView.transform = CGAffineTransformConcat(self.currentTransform, affine);
            break;
        default:
            NSLog(@"pinchCallback/default");
            break;
            
    }
}


@end

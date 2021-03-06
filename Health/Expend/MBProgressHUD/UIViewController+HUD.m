//
//  UIViewController+HUD.m
//
//  Created by Jamie Chapman on 12/02/2014.
//  Copyright (c) 2014 57Digital Ltd. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHud.h"
#import <objc/runtime.h>

NSString * const kHudPropertyKey = @"kViewControllerHud";

@implementation UIViewController (HUD)
@dynamic hud;

#pragma mark - Stores HUD as instance variable within the ViewController

- (void) setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self, (__bridge const void *)(kHudPropertyKey), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, (__bridge const void *)(kHudPropertyKey));
}

#pragma mark - Show Options

- (void) showHudWithAutomatic:(NSString*)title{
    BOOL alreadyInstanitated = YES;
    if(![self hud]) {
        [self setHud:[[MBProgressHUD alloc] initWithView:[self view]]];
        [[self hud] setRemoveFromSuperViewOnHide:YES];
        [[self hud] setMode:MBProgressHUDModeText];
        alreadyInstanitated = NO;
    }
    
    // Customize the HUD...
    [[self hud] setLabelText:(title ? title : @"...")];
    
    // Display the HUD if required...
    if(!alreadyInstanitated) {
        [[self view] addSubview:[self hud]];
        [[self hud] show:YES];
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([self hud]) {
            [[self hud] hide:YES];
            [self setHud:nil];
        }
    });
    
}


- (void) showHud {
    [self showHudWithTitle:nil andSubtitle:nil animated:YES];
}

- (void) showHudAnimated:(BOOL)animated {
    [self showHudWithTitle:nil andSubtitle:nil animated:animated];
}

- (void) showHudWithTitle:(NSString*)title {
    [self showHudWithTitle:title andSubtitle:nil animated:YES];
}

- (void) showHudWithTitle:(NSString*)title animated:(BOOL)animated {
    [self showHudWithTitle:title andSubtitle:nil animated:animated];
}

- (void) showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle {
    [self showHudWithTitle:title andSubtitle:subtitle animated:YES];
}

- (void) showHudWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle animated:(BOOL)animated {
    // Allocate if required...
    BOOL alreadyInstanitated = YES;
    if(![self hud]) {
        [self setHud:[[MBProgressHUD alloc] initWithView:[self view]]];
        [[self hud] setRemoveFromSuperViewOnHide:YES];
        [[self hud] setMode:MBProgressHUDModeText];
        alreadyInstanitated = NO;
    }
    
    // Customize the HUD...
    [[self hud] setLabelText:(title ? title : @"加载中...")];
    if(subtitle) {
        [[self hud] setDetailsLabelText:subtitle];
    }
    
    // Display the HUD if required...
    if(!alreadyInstanitated) {
        [[self view] addSubview:[self hud]];
        [[self hud] show:animated];
    }
    
}

#pragma mark - Hide Options

- (void) hideHud {
    [self hideHudAnimated:YES];
}

- (void) hideHudAnimated:(BOOL)animated {
    if([self hud]) {
        [[self hud] hide:animated];
        [self setHud:nil];
    }
}


@end

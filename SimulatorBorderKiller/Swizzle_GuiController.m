/*
 * Swizzle_GuiController.m
 *
 * Copyright (c) 2013 Kent Sutherland
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "Swizzle_GuiController.h"
#import "MethodSwizzle.h"
#import "BundleUtilities.h"

@interface NSObject ()
@property(assign) NSInteger deviceWindowType;
+ (id)sharedInstance;
- (id)currentDeviceInfo;
- (void)recreateWindow;
- (void)updateWindowTitle;
- (NSInteger)orientation;
- (NSInteger)desiredDeviceWindowType:(NSInteger)arg;
- (CGSize)frameSizeWithChrome:(BOOL)arg1 scaledForMonitor:(BOOL)arg2;
- (CGPoint)homeOriginForCurrentDeviceDoubled:(BOOL)arg1;
@end

@implementation Swizzle_GuiController

+ (void)load
{
    @autoreleasepool {
        Class guiControllerClass = NSClassFromString(@"GuiController");
        
        [BundleUtilities extendClass:guiControllerClass withMethodsFromClass:self];
        
        MethodSwizzle(guiControllerClass, @selector(updateWindowTitle), @selector(swizzled_updateWindowTitle));
        MethodSwizzle(guiControllerClass, @selector(desiredDeviceWindowType:), @selector(swizzled_desiredDeviceWindowType:));
        MethodSwizzle(guiControllerClass, @selector(frameSizeWithChrome:scaledForMonitor:), @selector(swizzled_frameSizeWithChrome:scaledForMonitor:));
        MethodSwizzle(guiControllerClass, @selector(homeOriginForCurrentDeviceDoubled:), @selector(swizzled_homeOriginForCurrentDeviceDoubled:));
        
        // The initial window maybe have been created before this bundle gets injected, this forces the window to rebuild without the chrome
        if ([[guiControllerClass sharedInstance] valueForKey:@"deviceWindow"]) {
            [[guiControllerClass sharedInstance] recreateWindow];
        }
    }
}

- (void)swizzled_updateWindowTitle
{
    id sharedInstance = [NSClassFromString(@"GuiController") sharedInstance];
    
    [self swizzled_updateWindowTitle];
    
    // currentDeviceInfo is an ISHDeviceInfo instance from SimulatorHost.framework
    NSInteger orientation = [self orientation];
    NSString *orientationString;
    
    if (orientation == 1) {
        orientationString = [NSString stringWithFormat:@"%@ Portrait", [NSString stringWithCharacters:(const unichar[]){0x2191} length:1]];
    } else if (orientation == 2) {
        orientationString = [NSString stringWithFormat:@"%@ Portrait upside down", [NSString stringWithCharacters:(const unichar[]){0x2193} length:1]];
    } else if (orientation == 3) {
        orientationString = [NSString stringWithFormat:@"%@ Landscape right", [NSString stringWithCharacters:(const unichar[]){0x2190} length:1]];
    } else if (orientation == 4) {
        orientationString = [NSString stringWithFormat:@"%@ Landscape left", [NSString stringWithCharacters:(const unichar[]){0x2192} length:1]];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ - %@", orientationString, [[sharedInstance currentDeviceInfo] valueForKey:@"displayName"]];
    
    // The original implementation updates the window's title in an async block, so do the same
    dispatch_async(dispatch_get_main_queue(), ^{
        [[sharedInstance valueForKey:@"deviceWindow"] setTitle:title];
    });
}

- (NSInteger)swizzled_desiredDeviceWindowType:(NSInteger)arg
{
    // Need to still call this, otherwise odd things happen
    NSInteger desiredDeviceWindowType = [self swizzled_desiredDeviceWindowType:arg];
    
    if (desiredDeviceWindowType == 0) {
        // 0 seems to means show the device border
        // other return values are 5, 6, and 7
        // I'm not entirely sure what they correspond to, but this is what I've seen:
        // 5 = iPad 2x at 100%
        // 6 = iPhone 3.5", 4", iPad 1x, iPad 2x at 50%
        // 7 = iPad 2x at 75%
        // Returning 6 always seems to work just fine
        desiredDeviceWindowType = 6;
    }
    
    return desiredDeviceWindowType;
}

- (CGSize)swizzled_frameSizeWithChrome:(BOOL)arg1 scaledForMonitor:(BOOL)arg2
{
    // Always return the size without chrome
    return [self swizzled_frameSizeWithChrome:NO scaledForMonitor:arg2];
}

- (CGPoint)swizzled_homeOriginForCurrentDeviceDoubled:(BOOL)arg1
{
    // Prevents the home button from being clickable
    // Otherwise you can click on where the home button would usually be and it'll still work
    [self swizzled_homeOriginForCurrentDeviceDoubled:arg1];
    
    return CGPointMake(-100, -100);
}

@end

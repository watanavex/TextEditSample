//
//  ViewController.m
//  TextEditSample
//
//  Created by watanabe on 2013/01/30.
//  Copyright (c) 2013年 susan335. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

CGSize originalSize;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keybaordWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    
    originalSize = CGSizeZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(keyboardRect), 0.0);
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [_scrollView convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    else if([_textView isFirstResponder])
    {
        NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect frame = _textView.frame;
        if(CGSizeEqualToSize(originalSize, CGSizeZero))
        {
            originalSize = frame.size;
        }
        
        CGPoint pt = CGPointMake(0, CGRectGetMinY(keyboardRect));
        pt = [_scrollView convertPoint:pt fromView:self.view];
                
        CGSize size = CGSizeZero;
        if( pt.y > _textView.frame.origin.y )
        {
            size = CGSizeMake(_textView.frame.size.width, pt.y - _textView.frame.origin.y);
            frame.size = size;
            _textView.frame = frame;
            
            [UIView commitAnimations];

        }
    }
}

- (void)keybaordWillHide:(NSNotification*)aNotification
{
    if([_textField isFirstResponder])
    {
        [_scrollView setContentOffset:CGPointZero animated:YES];
    }
    else if([_textView isFirstResponder])
    {
        NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect frame = _textView.frame;
        frame.size = originalSize;
        _textView.frame = frame;
        
        originalSize = CGSizeZero;
        
        [UIView commitAnimations];
    }
}

@end

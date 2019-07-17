//
//  WebViewController.m
//  X5
//
//  Created by yebw on 2017/11/15.
//  Copyright © 2017年 mfox. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "Constants.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIWebView *webview;

@end

@implementation WebViewController

+ (WebViewController *)openURL:(NSURL *)url inNavigationController:(UINavigationController *)navigationController {
    WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    vc.url = url;
    vc.hidesBottomBarWhenPushed = YES;
    [navigationController pushViewController:vc animated:YES];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customTitleLabel.text = @"";

    [self.containerView showLoadingView];
    self.webview.hidden = YES;
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.containerView hideAllStateView];

    self.webview.hidden = NO;
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.customTitleLabel.text = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.containerView hideAllStateView];
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    
    //无法识别的scheme，抛给webview，webview也无法识别，此时如果该url不是初始url，不处理
    if (error.code == 101 && [error.domain isEqualToString:@"WebKitErrorDomain"]) {
        NSDictionary *userInfo = error.userInfo;
        if ([userInfo.allKeys containsObject:@"NSErrorFailingURLStringKey"]) {
            NSString *url = userInfo[@"NSErrorFailingURLStringKey"];
            if (![url isEqualToString:self.url.absoluteString]) {
                return;
            }
        }
    }
    //当网页包含 appstore 链接时
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.containerView showFailureViewWithRetryCallback:^{
        [weakSelf.containerView showLoadingView];
        [weakSelf.webview reload];
    }];
}

- (void)dealloc {
    [_webview stopLoading];
    _webview.delegate = nil;
    
    NSLog(@"%s", __func__);
}

@end

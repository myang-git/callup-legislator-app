//
//  WebViewController.m
//  Petition
//
//  Created by Ming Yang on 4/11/14.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

static int AS_BTN_COPY_LINK = 0;

@implementation WebViewController
@synthesize webView;
@synthesize btnReload;
@synthesize btnShare;
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [HUDFactory createAndInstallHUDInView:self.view delegate:self];
    if (self.urlString!=nil) {
        self.btnReload.enabled = NO;
        self.btnShare.enabled = NO;
        [self openURL];
    }
    // Do any additional setup after loading the view.
}

- (void)openURL {
    if (self.urlString==nil || [[NSNull null] isEqual:self.urlString]) {
        NSLog(@"self.urlString is null");
    }
    NSURL* url = [NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    hud.labelText = @"載入頁面中...";
    [hud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
    self.btnReload.enabled = YES;
    self.btnShare.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    hud.labelText = @"無法載入頁面";
    [hud hide:YES];
    self.btnReload.enabled = YES;
    self.btnShare.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnReloadPressed:(id)sender {
    [self openURL];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==AS_BTN_COPY_LINK) {
        [[UIPasteboard generalPasteboard] setString:self.urlString];
    }
}

- (IBAction)btnSharePressed:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"複製連結", nil];
    [actionSheet showInView:self.view];
}

- (void)dealloc {
    hud.delegate = nil;
    [hud release];
    [webView release];
    [btnReload release];
    [urlString release];
    [super dealloc];
}

@end

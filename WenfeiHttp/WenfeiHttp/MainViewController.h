//
//  MainViewController.h
//  WenfeiHttp
//
//  Created by Edaomac on 14-9-23.
//  Copyright (c) 2014年 edao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SVHTTPClient.h"


@interface MainViewController : UIViewController<NSURLConnectionDelegate,UIAlertViewDelegate>{
    
    //联网相关
    NSURLConnection *  connection;
    NSMutableData *_dataRece;
    
    NSURLAuthenticationChallenge *_challenge;
    int requestType;
    
    int leftTag;
    BOOL isInit;
    
    //进度条
    MBProgressHUD *_HUD;
    //http响应码
    NSHTTPURLResponse * httpResponse;
    
    
    
    
}
- (IBAction)httpClick:(UIButton *)sender;
- (IBAction)httpsClick:(UIButton *)sender;

@property(strong,nonatomic) NSMutableURLRequest* request;
@property(strong,nonatomic)NSURL* url,*baseUrl;



@end

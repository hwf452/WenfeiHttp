//
//  MainViewController.m
//  WenfeiHttp
//
//  Created by Edaomac on 14-9-23.
//  Copyright (c) 2014年 edao. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _HUD=[[MBProgressHUD alloc] initWithView:self.view];
    _HUD.dimBackground = NO;
    
    _HUD.labelText=@"数据处理中";
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)httpClick:(UIButton *)sender {
    
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    NSString *url= [NSString stringWithFormat:@"%@",@"http://192.168.8.154:8080/efb/mbclient/userManagement/submitFeedback"];
    
    NSMutableDictionary* dictPost=[NSMutableDictionary dictionary];
    
    
    
    [dictPost setObject:@"白藤建农农产批发有限公司" forKey:@"enterpriseName"];
    [dictPost setObject:@"不错不错很好用" forKey:@"feedback"];
    
    [[SVHTTPClient sharedClient] POST:url parameters:dictPost completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if(urlResponse.statusCode==200){
            if (response) {
                NSError *err = nil;
                NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&err];
                
                
                Boolean  success=[[resultJSON objectForKey:@"result"] boolValue];
                
                if(success){
                    
                   
                    
                    
                    
                }else{
                    
                    
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
                
                
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取消息中心失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            
            
        }else{
            NSString *msg=@"登陆失败，请检查网络!";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
        [_HUD removeFromSuperview];
         NSLog(@"%i",urlResponse.statusCode);
        
    }];

    
    
    
    
    
}

- (IBAction)httpsClick:(UIButton *)sender {
    
    
    [self initData:@"2014-08-01"];
    
    
}




//费用汇总
-(void)initData:(NSString *)date{
    
    _url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,@"efb/mbclient/financialAnalysis/getFinancialActualIndicatorByEnterpriseAndReportMonth"]];
    _dataRece=[[NSMutableData alloc] init];
    
    NSLog(@"%@",[_url absoluteString]);
    
    
    
    [self.view addSubview:_HUD];
    [_HUD show:YES];
    
    
    requestType=1;
    
    [_dataRece resetBytesInRange:NSMakeRange(0, [_dataRece length])];
    
    [_dataRece setLength:0];
    
    
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    [dict setObject:@"1" forKey:@"enterpriseId"];
    [dict setObject:date forKey:@"reportYearMonth"];
    
    NSDictionary *dictt=[NSDictionary dictionaryWithDictionary:dict];
    
    
    //第二个区别点(请求为NSMutableURLRequest)
    NSURLRequest *postRequest =[self HTTPPOSTNormalRequestForURL:_url parameters:dictt];
    
    
    
    [NSURLConnection connectionWithRequest:postRequest delegate:self];
    
    
    
    
}

- (NSURLRequest *)HTTPPOSTNormalRequestForURL:(NSURL *)url parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSString *HTTPBodyString = [self HTTPBodyWithParameters:parameters];
    [URLRequest setHTTPBody:[HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [URLRequest setHTTPMethod:@"POST"];
    return URLRequest;
    
}

-(NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    
    NSLog(@"%@",[parametersArray componentsJoinedByString:@"&"]);
    
    return [parametersArray componentsJoinedByString:@"&"];
}







//#pragma mark - URLConnection delegate
- (BOOL)connection:(NSURLConnection *)conn canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"authenticate method:%@",protectionSpace.authenticationMethod);
    
    
    NSLog(@"mmmmmm");
    
    return [protectionSpace.authenticationMethod isEqualToString:
            NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    _challenge=challenge;
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"服务器证书"
    //                                                         message:@"这个网站有一个服务器证书，点击“接受”，继续访问该网站，如果你不确定，请点击“取消”。"
    //                                                        delegate:self
    //                                               cancelButtonTitle:@"接受"
    //                                               otherButtonTitles:@"取消", nil];
    //
    //    [alertView show];
    
    NSURLCredential *   credential;
    
    NSURLProtectionSpace *  protectionSpace;
    SecTrustRef             trust;
    NSString *              host;
    SecCertificateRef       serverCert;
    assert(_challenge !=nil);
    protectionSpace = [_challenge protectionSpace];
    assert(protectionSpace != nil);
    
    trust = [protectionSpace serverTrust];
    assert(trust != NULL);
    
    credential = [NSURLCredential credentialForTrust:trust];
    assert(credential != nil);
    host = [[_challenge protectionSpace] host];
    if (SecTrustGetCertificateCount(trust) > 0) {
        serverCert = SecTrustGetCertificateAtIndex(trust, 0);
    } else {
        serverCert = NULL;
    }
    [[_challenge sender] useCredential:credential forAuthenticationChallenge:_challenge];
    
    
    
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    
    
    httpResponse = (NSHTTPURLResponse *) response;
    
    NSLog(@"status: %zi", httpResponse.statusCode);
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    
    
    
    
    
    
    NSLog(@"%i",requestType);
    NSLog(@"data:%zi",data.length);
    [_dataRece appendData:data];
    
    
    
    
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"connect error :%@", error);
    
    
    _HUD.labelText=@"网络连接失败";
    
    [_HUD removeFromSuperview];
    
    NSString *msg=@"网络连接失败";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    
    
    if (requestType==1) {
        
        NSString *str=[[NSString alloc] initWithData:_dataRece encoding:NSUTF8StringEncoding];
        
        
        
        NSLog(@"%zi",_dataRece.length);
        
        NSLog(@"费用汇总:--%@",str);
        
        NSLog(@"%i",requestType);
        
        if (httpResponse.statusCode==200) {
            
            if (_dataRece) {
                
                
                
                
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            
            
            
            
        }else{
            NSString *msg=@"网络连接失败";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        [_HUD removeFromSuperview];
    }
}

@end

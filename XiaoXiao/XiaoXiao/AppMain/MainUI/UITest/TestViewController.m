//
//  TestViewController.m
//  WordPressMobile
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "TestViewController.h"
#import "TestCell.h"
#import "XXShareBaseCell.h"

@interface TestViewController ()

@end

@implementation TestViewController
@synthesize testTable,sourceArray;

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
	// Do any additional setup after loading the view.
    
    //sourceArray
    sourceArray = [[NSMutableArray alloc]init];
    
//    NSString *sampleContent = @"76年前的今天[亲亲]，侵华日军攻陷南京，制造了惨绝人寰的南京大屠杀惨案[可怜]。据1946年2月中国南京军事法庭查证：日军集体大屠杀28案，19万人[欢呼]，零散屠杀858案，15万人。长达6个星期的大屠杀，中国军民被枪杀和活埋者达30多万人[高兴]。财产损失不计其数。76年过去了，历史留给南京的创伤并没有随时间而愈合。";
//    sampleContent = [self replaceAllEmojiTextToGifName:sampleContent];
//    
//    NSMutableArray *sampleImages = [NSMutableArray array];
//    [sampleImages addObject:@"http://b.hiphotos.baidu.com/image/w%3D310/sign=e04b5f2679ec54e741ec1c1f89399bfd/9d82d158ccbf6c81417efef0be3eb13533fa4059.jpg"];
//    [sampleImages addObject:@"http://a.hiphotos.baidu.com/image/w%3D310/sign=a1350d4c8b13632715edc432a18ea056/d52a2834349b033beb5f6d4a14ce36d3d439bd4f.jpg"];
////    [sampleImages addObject:@"http://e.hiphotos.baidu.com/image/w%3D310/sign=7f216cbb8644ebf86d71623ee9f8d736/30adcbef76094b36b8ee4e55a2cc7cd98d109d0d.jpg"];
////    [sampleImages addObject:@"http://a.hiphotos.baidu.com/image/w%3D310/sign=07e149b8d833c895a67e9e7ae1127397/8ad4b31c8701a18b8f132c609f2f07082838fe20.jpg"];
////    [sampleImages addObject:@"http://h.hiphotos.baidu.com/image/w%3D310/sign=e4005e2b2fdda3cc0be4be2131e83905/ca1349540923dd54f97860dcd009b3de9c82487f.jpg"];
////    [sampleImages addObject:@"http://h.hiphotos.baidu.com/image/w%3D310/sign=0f9b28a1d52a283443a6300a6bb4c92e/8c1001e93901213fd7cc766055e736d12e2e958a.jpg"];
//    
//    NSString *htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil];
//    
//    //replace css
//    NSString *cssString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"css"] encoding:NSUTF8StringEncoding error:nil];
//    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"!$css$!" withString:cssString];
//    
//    
//    //insert content
//    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"!$content$!" withString:sampleContent];
//    for (int i=0; i<sampleImages.count; i++) {
//        
//        NSString *imageWillReplace = [NSString stringWithFormat:@"!$image%d$!",i];
//        
//        DDLogVerbose(@"image replace %@",imageWillReplace);
//        
//        htmlString = [htmlString stringByReplacingOccurrencesOfString:imageWillReplace withString:[sampleImages objectAtIndex:i]];
//    }
//    
//    
//    //replace image
//    htmlString = [NSString stringWithFormat:htmlString,200];
//    
//    htmlString = @"<html><head><meta name = \"viewport\" content= \"width = device-width\"><meta name = \"viewport\" content= \"width = 320\"><style type = \"text/css\">p{line-height:1.600000;font-size:14px;color:#3a4244;text-align:left;font-weight:normal;font-family:Helvetica;}img.emoji{width:24px;height:24px;}img.thumbs {width: 100px;height: 100px;position:relative;}img.audio{width: 60px;height:30px;position:relative;}</style></head><body><p>美女,一般解释为容貌美丽的女子。营养专家提出的营养学上的美女定义，是从脸蛋比例、体质指数、健康指标和发育程度等方面进行要求，更倾重于一种健康的标准。古代关于美女的形容词和诗词歌赋众多<img class=\"emoji\" src=\"1.png\">，形成了丰富的美学资料［可怜］。</p><table><tr><td><center><a href=\"!$image0Link$!\"><img class=\"thumbs\" src='http://image.baidu.com/i?tn=baiduimage&ipn=r&ct=201326592&cl=2&lm=-1&st=-1&fm=result&fr=&sf=1&fmq=1383635220671_R&ie=utf-8&word=%E7%BE%8E%E5%A5%B3%20%E4%B8%8D%E5%90%8C%E9%A3%8E%E6%A0%BC%20%E6%B8%85%E7%BA%AF%E5%8F%AF%E7%88%B1'/></a></center></td></tr></table></body></html>";
//    DDLogVerbose(@"final html --->%@",htmlString);
//
//    NSData *stringToHtmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
//    NSAttributedString *htmlAttributeString = [[NSAttributedString alloc]initWithHTMLData:stringToHtmlData documentAttributes:nil];
//
    
    
//    for (int j=0; j<10; j++) {
//        
//        [sourceArray addObject:htmlAttributeString];
//        
//    }
    
    
    NSString *commonContent =@"美女,一般解释为容貌美丽的女子。营养专家提出的营养学上的美女定义，是从脸蛋比例、体质指数、健康指标和发育程度等方面进行要求，更倾重于一种健康的标准。古代关于美女的形容词和诗词歌赋众多[亲亲]，形成了丰富的美学资料［可怜］。";
    NSString *audio = @"http://pan.baidu.com/share/link?shareid=434720&uk=3157602687";
    NSString *image0 = @"http://f.hiphotos.baidu.com/image/w%3D230/sign=ffd4882fbc096b63811959533c328733/5882b2b7d0a20cf4c43fb1df74094b36acaf9907.jpg";
    NSString *image1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=9f85cd29b27eca8012053ee7a51b96dd/91ef76c6a7efce1bb082a3c0ad51f3deb48f650a.jpg";
    NSString *image2 = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=79cf7b17d62a283443a6310b6f8dc8ea/adaf2edda3cc7cd994865fd33b01213fb80e9114.jpg";
    NSString *image3 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=44c95f085e6034a829e2bf81ff2b4854/71cf3bc79f3df8dc0cec5998cf11728b461028e2.jpg";
    
    CGFloat styleContent = [XXSharePostStyle sharePostContentWidth];
    
    //image audio
    XXSharePostModel *modelOneImage0 = [[XXSharePostModel alloc]init];
    modelOneImage0.postType = XXSharePostTypeImageAudio1;
    modelOneImage0.postImages = @"";
    modelOneImage0.postContent = @"";
    modelOneImage0.postAudio = audio;
    modelOneImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage0 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage0.attributedContent];
    //    DDLogVerbose(@"post model attributed content :%@",modelOneImage0.attributedContent);
    
    
    
    XXSharePostModel *modelOneImage = [[XXSharePostModel alloc]init];
    modelOneImage.postType = XXSharePostTypeImageAudio1;
    modelOneImage.postImages = image0;
    modelOneImage.postContent = @"";
    modelOneImage.postAudio = audio;
    modelOneImage.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage0.attributedContent];
    
    XXSharePostModel *modelOneImage2 = [[XXSharePostModel alloc]init];
    modelOneImage2.postType = XXSharePostTypeImageAudio2;
    modelOneImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
    modelOneImage2.postContent = @"";
    modelOneImage2.postAudio = audio;
    modelOneImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage2 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage2.attributedContent];
    
    XXSharePostModel *modelOneImage3 = [[XXSharePostModel alloc]init];
    modelOneImage3.postType = XXSharePostTypeImageAudio3;
    modelOneImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
    modelOneImage3.postContent = @"";
    modelOneImage3.postAudio = audio;
    modelOneImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage3 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage3.attributedContent];
    
    XXSharePostModel *modelOneImage4 = [[XXSharePostModel alloc]init];
    modelOneImage4.postType = XXSharePostTypeImageAudio4;
    modelOneImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
    modelOneImage4.postContent = @"";
    modelOneImage4.postAudio = audio;
    modelOneImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage4 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage4.attributedContent];
    
    
    //image text
    XXSharePostModel *modelTwoImage0 = [[XXSharePostModel alloc]init];
    modelTwoImage0.postType = XXSharePostTypeImageText0;
    modelTwoImage0.postImages = @"";
    modelTwoImage0.postContent = commonContent;
    modelTwoImage0.postAudio = @"";
    modelTwoImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage0 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage0.attributedContent];
    
    XXSharePostModel *modelTwoImage1 = [[XXSharePostModel alloc]init];
    modelTwoImage1.postType = XXSharePostTypeImageText1;
    modelTwoImage1.postImages = [NSString stringWithFormat:@"%@",image0];
    modelTwoImage1.postContent = commonContent;
    modelTwoImage1.postAudio = @"";
    modelTwoImage1.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage1 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage1.attributedContent];
    
    XXSharePostModel *modelTwoImage2 = [[XXSharePostModel alloc]init];
    modelTwoImage2.postType = XXSharePostTypeImageText2;
    modelTwoImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
    modelTwoImage2.postContent = commonContent;
    modelTwoImage2.postAudio = @"";
    modelTwoImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage2 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage2.attributedContent];
    
    XXSharePostModel *modelTwoImage3 = [[XXSharePostModel alloc]init];
    modelTwoImage3.postType = XXSharePostTypeImageText3;
    modelTwoImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
    modelTwoImage3.postContent = commonContent;
    modelTwoImage3.postAudio = @"";
    modelTwoImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage3 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage3.attributedContent];
    
    XXSharePostModel *modelTwoImage4 = [[XXSharePostModel alloc]init];
    modelTwoImage4.postType = XXSharePostTypeImageText4;
    modelTwoImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
    modelTwoImage4.postContent = commonContent;
    modelTwoImage4.postAudio = @"";
    modelTwoImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage4 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage4.attributedContent];
    DDLogVerbose(@"self.sourceArray -->%@",self.sourceArray);
    
    testTable = [[UITableView alloc]init];
    testTable.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-44);
    testTable.delegate = self;
    testTable.dataSource = self;
    [self.view addSubview:testTable];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor blueColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(testRefresh) forControlEvents:UIControlEventValueChanged];
    [testTable addSubview:refreshControl];
    
    [testTable reloadData];
    
}
- (void)testRefresh
{
   dispatch_async(dispatch_get_current_queue(), ^{
      
       
       
   });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sourceArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    TestCell *cell = (TestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[TestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setContentHtmlAttributedString:[sourceArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TestCell heightWithContentHtmlAttributedString:[sourceArray objectAtIndex:indexPath.row] forTable:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSString*)gifNameByFaceName:(NSString *)faceName
{
    NSDictionary *gifDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xx_emoji_text" ofType:@"plist"]];
    
    NSString *gifName = [gifDict objectForKey:faceName];
    
    if (gifName == nil) {
        
        gifName = @"000";//未知得默认一下
    }
    
    return gifName;
}

//将表情文字替换成表情图片名字
- (NSString *)replaceAllEmojiTextToGifName:(NSString*)text
{
    if (!text) {
        return nil;
    }
    
    NSMutableString *resultString = [NSMutableString string];
    
    NSArray *arrayByLeftTag = [text componentsSeparatedByString:@"["];
    
    if (arrayByLeftTag.count > 1) {
        
        
        for (int i=0;i<arrayByLeftTag.count;i++) {
            
            NSString *string = [arrayByLeftTag objectAtIndex:i];
            
            if (i!=0) {
                
                NSRange rightTagRange = [string rangeOfString:@"]"];
                
                if (rightTagRange.location != NSNotFound) {
                    
                    NSArray *leftRangArray = [string componentsSeparatedByString:@"]"];
                                        
                    if (leftRangArray.count > 1) {
                        
                        NSString *emojiString = [leftRangArray objectAtIndex:0];
                                                
                        NSString *gifName = [self gifNameByFaceName:emojiString];
                                                
                        if (i>0) {
                            
                            [resultString appendFormat:@"<img class=\"emoji\" src=\"%@\">",gifName];
                            
                            if ([leftRangArray objectAtIndex:1]!=nil||![[leftRangArray objectAtIndex:1] isEqualToString:@""]) {
                                [resultString appendString:[leftRangArray objectAtIndex:1]];
                            }
                            
                        }else {
                            
                            [resultString appendFormat:@"img class=\"emoji\" src=\"%@\">",gifName];
                            
                            if ([leftRangArray objectAtIndex:1]!=nil||![[leftRangArray objectAtIndex:1] isEqualToString:@""]) {
                                [resultString appendString:@"<"];
                            }
                        }
                        
                    }
                    
                }else {
                    
                    [resultString appendFormat:@"%@",string];
                    
                }
                
            }else{
                [resultString appendFormat:@"%@",string];
            }
            
        }
        
    }else {
        
        [resultString appendString:text];
    }
    
    return resultString;
}

@end

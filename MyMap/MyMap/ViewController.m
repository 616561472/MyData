//
//  ViewController.m
//  MyMap
//
//  Created by lanou3g on 15/10/12.
//  Copyright (c) 2015年 张明洋. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
@interface ViewController ()<MKMapViewDelegate>
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *manger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:_mapView];
    self.manger = [[CLLocationManager alloc]init];
    //设置地图样式
    self.mapView.mapType = MKMapTypeStandard;
    
    //向设备请求授权
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        //向设备申请，程序使用中时，使用定位功能
        [self.manger requestWhenInUseAuthorization];
    }
    
    //设置地图的中心  第一次显示的中心
    CLLocationCoordinate2D locate = CLLocationCoordinate2DMake(40, 116);
    [self.mapView setCenterCoordinate:locate  animated:YES];
    
    //设置地图的显示范围
    [self.mapView setRegion:MKCoordinateRegionMake(locate,MKCoordinateSpanMake(10, 10))];
    
    //跟踪用户，打开用户位置
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //是否允许地图旋转
    self.mapView.rotateEnabled = NO;
    
    self.mapView.delegate = self;
    
}
//定位成功的代理方法
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"获取用户的当前位置完成");
}
//定位失败的代理方法
-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败");
}
//屏幕区域开始发生变化
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"屏幕区域将要发生变化");
}
//屏幕区域变化结束
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"屏幕区域变化结束");
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    MyAnnotation *ann = [[MyAnnotation alloc]init];
    ann.coordinate = CLLocationCoordinate2DMake(40, 116);
    ann.title = @"哥在此";
    ann.subtitle = @"开 ！！";

    ann.icon = [UIImage imageNamed:@"2.png"];
    [self.mapView addAnnotation:ann];
    //self.mapView addAnnotations:<#(NSArray *)#>//插一堆大头针
    
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MyAnnotation class]])
    {
        return nil;
    }
    static NSString *identifier = @"identifier";
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: identifier];
    }
    
    // 设置大头针的属性
    pinAnnotationView.annotation = annotation;
    pinAnnotationView.image = ((MyAnnotation *)annotation).icon;
    
    // 设置可以显示冒泡上的左右图片
    pinAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11.png"]];
    pinAnnotationView.rightCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"22.png"]];
    
    // 从天而降(动画，只有用系统大头针样式才起作用)
    // pinAnnotationView.animatesDrop = YES;
    
    //气泡偏移量
    pinAnnotationView.calloutOffset = CGPointMake(0, 0);
    // 设置可以显示冒泡
    pinAnnotationView.canShowCallout = YES;
    
    return pinAnnotationView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

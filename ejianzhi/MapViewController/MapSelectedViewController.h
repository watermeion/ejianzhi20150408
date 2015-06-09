//
//  MapSelectedViewController.h
//  ejianzhi
//
//  Created by Mac on 6/8/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMapView.h"
#import "MLMapManager.h"
#import "MapJobViewModal.h"
#import "POIDataModel.h"
@protocol SelectPOIDataResultsDelegate <NSObject>

-(void)sendResults:(POIDataModel*) poiData;

@end

@interface MapSelectedViewController : UIViewController<showDetailDelegate>

@property (weak,nonatomic) MLMapManager *mapManager;

@property (strong,nonatomic)MLMapView *mapView;

@property (strong,nonatomic)MapJobViewModal *mapViewModel;


@property (strong,nonatomic)POIDataModel *poiData;

@property (weak,nonatomic)id<SelectPOIDataResultsDelegate> resultsDelegate;

@end

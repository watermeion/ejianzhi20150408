//
//  MLSelectJobTypeVC.m
//  jobSearch
//
//  Created by RAY on 15/2/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLSelectJobTypeVC.h"
#import "MLCell4.h"

@interface MLSelectJobTypeVC ()
{
    const NSArray *typeArray;
}
@end

@implementation MLSelectJobTypeVC

static  MLSelectJobTypeVC *thisVC=nil;

+ (MLSelectJobTypeVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLSelectJobTypeVC alloc]init];
    }
    return thisVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.fromEnterprise) {
        typeArray=[[NSArray alloc]initWithObjects:@"全部",@"模特/礼仪",@"促销/导购",@"销售",@"传单派发",@"安保",@"钟点工",@"法律事务",@"服务员",@"婚庆",@"配送/快递",@"化妆",@"护工/保姆",@"演出",@"问卷调查",@"志愿者",@"网络营销",@"导游",@"游戏代练",@"家教",@"软件/网站开发",@"会计",@"平面设计/制作",@"翻译",@"装修",@"影视制作",@"搬家",@"其他", nil];
        
        UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelecting)];
        
        self.navigationItem.rightBarButtonItem = finishItem;
        
    }else{
        if (self.type==11) {
            typeArray=[[NSArray alloc]initWithObjects:@"10人以下",@"50人以下",@"200人以下",@"200人以上", nil];
        }else if (self.type==10)
            typeArray=[[NSArray alloc]initWithObjects:@"国有企业",@"私营企业",@"中外合资企业",@"个体户",@"外资企业",@"事业单位",@"集体企业",@"股份制公司",@"其他", nil];
        else if (self.type==9)
            typeArray=[[NSArray alloc]initWithObjects:@"金融",@"汽车",@"IT",@"教育",@"能源",@"医药",@"消费品",@"互联网",@"通讯",@"制造",@"广告",@"其他", nil];
    }

    self.selectedTypeName=[[NSMutableArray alloc]init];
    
}

- (void)finishSelecting{
    [self.selectDelegate finishSelect:self.selectedTypeName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [typeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell4";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell4" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell4 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=[typeArray objectAtIndex:[indexPath row]];
    
    if ([self.selectedTypeName containsObject:[typeArray objectAtIndex:[indexPath row]]]) {
        cell.selectedImageView.hidden=NO;
        cell.selecting=YES;
    }else
    {
        cell.selectedImageView.hidden=YES;
        cell.selecting=NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.fromEnterprise) {
        [self.selectDelegate finishSingleSelect:[typeArray objectAtIndex:[indexPath row]] type:self.type];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    MLCell4 *cell=(MLCell4 *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.selecting) {
        
        if ([indexPath row]==0) {
            
            for (NSIndexPath* idpth in [tableView indexPathsForVisibleRows]){
               MLCell4 *tempcell=(MLCell4 *)[tableView cellForRowAtIndexPath:idpth];
                tempcell.selectedImageView.hidden=YES;
                tempcell.selecting=NO;
            }
            [self.selectedTypeName removeAllObjects];
        }
        else{
            cell.selecting=NO;
            cell.selectedImageView.hidden=YES;

            if ([self.selectedTypeName containsObject:[typeArray objectAtIndex:[indexPath row]]]) {
 
                [self.selectedTypeName removeObject:[typeArray objectAtIndex:[indexPath row]]];
                
            }

        }
    }else{
        if ([indexPath row]==0) {
            
            for (NSIndexPath* idpth in [tableView indexPathsForVisibleRows]){
                MLCell4 *tempcell=(MLCell4 *)[tableView cellForRowAtIndexPath:idpth];
                tempcell.selectedImageView.hidden=NO;
                tempcell.selecting=YES;
            }
            
            [self.selectedTypeName removeAllObjects];
            
            for (NSInteger i=1; i<[typeArray count]; i++) {
                [self.selectedTypeName addObject:[typeArray objectAtIndex:i]];
            }
        }
        else{
            cell.selecting=YES;
            cell.selectedImageView.hidden=NO;
            [self.selectedTypeName addObject:[typeArray objectAtIndex:[indexPath row]]];
        }
    }
    }
    [self deselect];
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end

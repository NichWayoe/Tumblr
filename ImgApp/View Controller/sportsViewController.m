//
//  sportsViewController.m
//  ImgApp
//
//  Created by Nicholas Wayoe on 6/27/20.
//  Copyright © 2020 Nicholas Wayoe. All rights reserved.
//

#import "sportsViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface sportsViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray* photos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *tappedCell;

@end

@implementation sportsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getPhotos];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPhotos) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];}

    -(void)getPhotos{
    NSURL *url = [NSURL URLWithString:@"https://api.unsplash.com/search/photos?client_id=Ec9eafeTzXptIlIZB23tNG9S5hAnvLhnisczHUYOTF4&page=1,5&query=football&ordered_latest&orientation=landscape&per_page=100"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if(dataDictionary[@"results"] != NULL)
                    self.photos = dataDictionary[@"results"];
                [self.tableView reloadData];
            }
         [self.refreshControl endRefreshing];
        }];
    [task resume];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    NSDictionary *photo = self.photos[indexPath.row];
   
    if (photo) {
        NSString *image =photo[@"urls"][@"regular"];
        NSURL *url = [NSURL URLWithString:image];
        
        cell.sportView.image = nil;
        [cell.sportView setImageWithURL:url];
        image = photo[@"user"][@"profile_image"][@"medium"];
        url = [NSURL URLWithString:image];
        
        [cell.profileImage setImageWithURL:url];
        cell.nameLabel.text= photo[@"user"][@"name"];
        cell.usernameLabel.text= photo[@"user"][@"username"];
        cell.portfolioLabel.text= photo[@"alt_description"];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tappedCell == NULL || self.tappedCell != indexPath)
        self.tappedCell = indexPath;
    else
        self.tappedCell = NULL;
    [UIView animateWithDuration:0.5 animations:^{
    [tableView beginUpdates];
        [tableView endUpdates];}];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == self.tappedCell)
        return 400;
    else
        return 238;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

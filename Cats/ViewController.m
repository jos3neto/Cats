//
//  ViewController.m
//  Cats
//
//  Created by Jose on 23/1/18.
//  Copyright © 2018 Jose. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "CustomCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property NSDictionary* photoDic;
@property NSMutableArray* photoArray;
@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    NSURL* url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=3cece1a974a69c3dcb6e908887eb87a9&tags=cat&sort=interestingness-desc"];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error)
    {
        /*if (response)
        {
            NSLog(@"Server response: %@", response);
        }*/
        
        if (error)
        {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
            
        NSError* convertError = nil;
        _photoDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&convertError];
        
        if (convertError)
        {
            NSLog(@"JSON Error: %@", convertError);
            return;
        }
        
        NSArray* metaDataArray = _photoDic[@"photos"][@"photo"];
        _photoArray = [NSMutableArray new];
        
        for (int i=0; i < metaDataArray.count; i++)
        {
            Photo* photo = [Photo new];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",metaDataArray[i][@"farm"],metaDataArray[i][@"server"],metaDataArray[i][@"id"],metaDataArray[i][@"secret"]]];
            [_photoArray addObject:photo];
            //NSLog(@"%@",((Photo*)_photoArray[i]).url);
        }
        
        //Next block necessary to update properties(_photoArray) between background queue and main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [_collectionView reloadData];
        } ];
        /*for (NSDictionary* dic in metaDataArray)
        {
            Photo* photo = [Photo new];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",dic[@"farm"],dic[@"server"],dic[@"id"],dic[@"secret"]]];
            
            [_photoArray addObject:photo];
        }*/
    } ];
    
    [task resume];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor groupTableViewBackgroundColor];;
    CustomCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo* photo = _photoArray[indexPath.item];
    //cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.imageView.image = photo.image;
    return cell;
}

#pragma mark - Flow Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = (self.collectionView.frame.size.width) * 0.45;
    return CGSizeMake(picDimension, picDimension);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 10);
}

@end

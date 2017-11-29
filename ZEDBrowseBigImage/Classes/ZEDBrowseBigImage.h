//
//  ZEDBrowseBigImage.h
//  FBSnapshotTestCase
//
//  Created by 超李 on 2017/11/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZEDBrowseBigImage : NSObject

+ (instancetype)shareBrowseImageHelper;

/**
 *  浏览大图
 *
 *  @param currentImageView 图片所在的imageView
 *  @param portrait 大图url,如果为空，大图为currentImageView.image
 */
- (void)browseImageWithImageView:(UIImageView *)currentImageView portrait:(NSString *)portrait;

@end

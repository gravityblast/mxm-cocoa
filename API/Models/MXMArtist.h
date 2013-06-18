#import <Foundation/Foundation.h>
#import "MXMRequest.h"

@protocol MXMArtistPictureSmallProtocol

-(void)artistPictureSmallDidLoad:(NSData*)data;
-(void)artistPictureSmallLoaderError;

@end

@interface MXMArtist : NSObject <MXMRequestProtocol> {
	NSString *artistId;
	NSString *name;
	NSString *pictureSmallUrl;
	NSString *biography;

	NSData *pictureSmallData;
	MXMRequest *pictureSmallRequest;
	BOOL loadingPictureSmall;
	BOOL pictureSmallLoaded;
	id delegate;

}

@property (nonatomic, copy) NSString *artistId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureSmallUrl;
@property (nonatomic, copy) NSString *biography;
@property (nonatomic, retain) NSData *pictureSmallData;
@property (nonatomic, retain) MXMRequest *pictureSmallRequest;
@property (nonatomic, retain) id delegate;

+(id) artistWithArtistId:(NSString*)_artistId;
-(id) initWithArtistId:(NSString*)_artistId;

-(void) loadPictureSmall;
-(void) cancelPictureSmallLoader;

@end

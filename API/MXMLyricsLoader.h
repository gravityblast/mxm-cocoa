#import <Foundation/Foundation.h>
#import "MXMRequest.h"
#import "GDataXMLNode.h"
#import "MXMLyrics.h"

@protocol MXMLyricsLoaderProtocol

-(void) mXmLyricsLoaderDidFinish:(MXMLyrics*)lyrics;
-(void) mXmLyricsLoaderError:(NSError *)error;

@end

@interface MXMLyricsLoader : NSObject <MXMRequestProtocol> {
	MXMRequest *request;
	id delegate;
}

@property (nonatomic, retain) MXMRequest *request;
@property (nonatomic, retain) id delegate;

+(id)loaderWithTrackId:(NSString*)_trackId;
-(id)initWithTrackId:(NSString*)_trackId;
- (void)start;
-(void)parseXMLDocument:(GDataXMLDocument*)document;
-(void)handleError:(NSError *)error;
-(void)cancel;
@end

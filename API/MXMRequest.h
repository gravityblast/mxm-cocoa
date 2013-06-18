#import <Foundation/Foundation.h>
#import "mXmConfig.h"

#define MXM_API_URL @"http://api.musixmatch.com/ws/1.1"

@protocol MXMRequestProtocol

-(void) mXmRequestDidFinish:(NSData*)data;
-(void) mXmRequestError:(NSError *)error;

@end


@interface MXMRequest : NSObject {
	NSURLRequest *request;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	id delegate;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) id delegate;

+(id)requestWithAction:(NSString*)action params:(NSDictionary*)params;
-(id)initWithAction:(NSString*)action params:(NSDictionary*)params;
-(void)start;
+(id)requestWithUrl:(NSString*)url;
-(id)initWithUrl:(NSString*)url;
-(NSString*)urlForAction:(NSString*)action params:(NSDictionary*)params;
-(void)cancel;
-(NSString *)urlencode:(NSString *)url;
@end

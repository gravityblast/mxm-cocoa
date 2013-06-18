#import <Foundation/Foundation.h>


@interface MXMLyrics : NSObject {
	NSString *body;
	NSString *copyRight;
}

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *copyRight;

+(id) lyricsWithBody:(NSString*)_body copyRight:(NSString*)_copyRight;
-(id) initWithBody:(NSString*)_body copyRight:(NSString*)_copyRight;

@end

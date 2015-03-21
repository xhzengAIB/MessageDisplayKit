//
//  AVFile.h
//  AVOS Cloud
//

#import <Foundation/Foundation.h>
#import "AVConstants.h"

/*!
 A file of binary data stored on the AVOS Cloud servers. This can be a image, video, or anything else
 that an application needs to reference in a non-relational way.
 */
@interface AVFile : NSObject

/** @name Creating a AVFile */

/*!
 Creates a file with given data. A name will be assigned to it by the server.
 @param data The contents of the new AVFile.
 @return A AVFile.
 */
+ (id)fileWithData:(NSData *)data;

/*!
 Creates a file with given data and name.
 @param name The name of the new AVFile.
 @param data The contents of the new AVFile.
 @return A AVFile.
 */
+ (id)fileWithName:(NSString *)name data:(NSData *)data;


/*!
 Creates a file with given url.
 @warning only for getting image thumbnail with a known QiNiu file url
 @param url The url of file.
 @return an AVFile.
 */
+ (id)fileWithURL:(NSString *)url;

/*!
 Creates a file with the contents of another file.
 @param name The name of the new AVFile
 @param path The path to the file that will be uploaded to AVOS Cloud
 */
+ (id)fileWithName:(NSString *)name 
    contentsAtPath:(NSString *)path;

/*!
The name of the file.
 */
@property (readonly) NSString *name;

/*!
 The id of the file.
 */
@property (readwrite, copy) NSString * objectId;


/*!
 The url of the file.
 */
@property (readonly) NSString *url;

/*!
 The Qiniu bucket of the file.
 */
@property (readonly) NSString *bucket;

/** @name Storing Data with AVOS Cloud */

/*!
 Whether the file has been uploaded for the first time.
 */
@property (readonly) BOOL isDirty;

/*!
 File metadata, caller is able to store additional values here.
 */
@property (readwrite, strong) NSMutableDictionary * metadata AVDeprecated("2.6.1以后请使用metaData");
/*!
 File metadata, caller is able to store additional values here.
 */
@property (readwrite, strong) NSMutableDictionary * metaData;

/*!
 Saves the file.
 @return whether the save succeeded.
 */
- (BOOL)save;

/*!
 Saves the file and sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return whether the save succeeded.
 */
- (BOOL)save:(NSError **)error;

/*!
 Saves the file asynchronously.
 @return whether the save succeeded.
 */
- (void)saveInBackground;

/*!
 Saves the file asynchronously and executes the given block.
 @param block The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)saveInBackgroundWithBlock:(AVBooleanResultBlock)block;

/*!
 Saves the file asynchronously and executes the given resultBlock. Executes the progressBlock periodically with the percent
 progress. progressBlock will get called with 100 before resultBlock is called.
 @param block The block should have the following argument signature: (BOOL succeeded, NSError *error)
 @param progressBlock The block should have the following argument signature: (int percentDone)
 */
- (void)saveInBackgroundWithBlock:(AVBooleanResultBlock)block
                    progressBlock:(AVProgressBlock)progressBlock;

/*!
 Saves the file asynchronously and calls the given callback.
 @param target The object to call selector on.
 @param selector The selector to call. It should have the following signature: (void)callbackWithResult:(NSNumber *)result error:(NSError *)error. error will be nil on success and set if there was an error. [result boolValue] will tell you whether the call succeeded or not.
 */
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;

/** @name Getting Data from AVOS Cloud */

/*!
 Whether the data is available in memory or needs to be downloaded.
 */
@property (readonly) BOOL isDataAvailable;

/*!
 Gets the data from cache if available or fetches its contents from the AVOS Cloud
 servers.
 @return The data. Returns nil if there was an error in fetching.
 */
- (NSData *)getData;

/*!
 This method is like getData but avoids ever holding the entire AVFile's
 contents in memory at once. This can help applications with many large AVFiles
 avoid memory warnings.
 @return A stream containing the data. Returns nil if there was an error in 
 fetching.
 */
- (NSInputStream *)getDataStream;

/*!
 Gets the data from cache if available or fetches its contents from the AVOS Cloud
 servers. Sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return The data. Returns nil if there was an error in fetching.
 */
- (NSData *)getData:(NSError **)error;

/*!
 This method is like getData: but avoids ever holding the entire AVFile's
 contents in memory at once. This can help applications with many large AVFiles
 avoid memory warnings. Sets an error if it occurs.
 @param error Pointer to an NSError that will be set if necessary.
 @return A stream containing the data. Returns nil if there was an error in 
 fetching.
 */
- (NSInputStream *)getDataStream:(NSError **)error;

/*!
 Asynchronously gets the data from cache if available or fetches its contents 
 from the AVOS Cloud servers. Executes the given block.
 @param block The block should have the following argument signature: (NSData *result, NSError *error)
 */
- (void)getDataInBackgroundWithBlock:(AVDataResultBlock)block;

/*!
 This method is like getDataInBackgroundWithBlock: but avoids ever holding the 
 entire AVFile's contents in memory at once. This can help applications with
 many large AVFiles avoid memory warnings.
 @param block The block should have the following argument signature: (NSInputStream *result, NSError *error)
 */
- (void)getDataStreamInBackgroundWithBlock:(AVDataStreamResultBlock)block;

/*!
 Asynchronously gets the data from cache if available or fetches its contents 
 from the AVOS Cloud servers. Executes the resultBlock upon
 completion or error. Executes the progressBlock periodically with the percent progress. progressBlock will get called with 100 before resultBlock is called.
 @param resultBlock The block should have the following argument signature: (NSData *result, NSError *error)
 @param progressBlock The block should have the following argument signature: (int percentDone)
 */
- (void)getDataInBackgroundWithBlock:(AVDataResultBlock)resultBlock
                       progressBlock:(AVProgressBlock)progressBlock;

/*!
 This method is like getDataInBackgroundWithBlock:progressBlock: but avoids ever
 holding the entire AVFile's contents in memory at once. This can help 
 applications with many large AVFiles avoid memory warnings.
 @param resultBlock The block should have the following argument signature: (NSInputStream *result, NSError *error)
 @param progressBlock The block should have the following argument signature: (int percentDone)
 */
- (void)getDataStreamInBackgroundWithBlock:(AVDataStreamResultBlock)resultBlock
                             progressBlock:(AVProgressBlock)progressBlock;

/*!
 Asynchronously gets the data from cache if available or fetches its contents 
 from the AVOS Cloud servers.
 @param target The object to call selector on.
 @param selector The selector to call. It should have the following signature: (void)callbackWithResult:(NSData *)result error:(NSError *)error. error will be nil on success and set if there was an error.
 */
- (void)getDataInBackgroundWithTarget:(id)target selector:(SEL)selector;

/** @name Interrupting a Transfer */

/*!
 Cancels the current request (whether upload or download of file data).
 */
- (void)cancel;


/*!
 Gets a AVFile asynchronously and calls the given block with the result.
 
 @param objectId The objectId associated with file object. 
 @param block The block to execute. The block should have the following argument signature: (AVFile *file, NSError *error)
 */
+ (void)getFileWithObjectId:(NSString *)objectId
                  withBlock:(AVFileResultBlock)block;

/*!
 Gets a thumbnail asynchronously and calls the given block with the result.
 
 @param scaleToFit Scale the thumbnail and keep aspect ratio.
 @param width The desired width.
 @param height The desired height.
 @param block The block to execute. The block should have the following argument signature: (UIImage *image, NSError *error)
 */
- (void)getThumbnail:(BOOL)scaleToFit
               width:(int)width
              height:(int)height
           withBlock:(AVImageResultBlock)block;

/*!
 Sets a owner id to metadata.
 
 @param ownerId The owner objectId.
 */
-(void)setOwnerId:(NSString *)ownerId;

/*!
 Gets owner id from metadata.

 */
-(NSString *)ownerId;


/*!
 Gets file size in bytes.
 */
-(NSUInteger)size;

/*!
 Gets file path extension from url, name or local file path.
 */
-(NSString *)pathExtension;

/*!
 Remove file in background.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error)
 */
- (void)deleteInBackgroundWithBlock:(AVBooleanResultBlock)block;

/*!
 Remove file in background.
 */
- (void)deleteInBackground;


/** @name Cache management */

/*!
 Clear file cache.
 */
- (void)clearCachedFile;

/**
 *  clear All Cached AVFiles
 *
 *  @return clear success or not
 */
+ (BOOL)clearAllCachedFiles;

/**
 *  clear All Cached AVFiles by days ago
 *
 *  @param numberOfDays number Of Days
 *
 *  @return clear success or not
 */
+ (BOOL)clearCacheMoreThanDays:(NSInteger)numberOfDays;


@end

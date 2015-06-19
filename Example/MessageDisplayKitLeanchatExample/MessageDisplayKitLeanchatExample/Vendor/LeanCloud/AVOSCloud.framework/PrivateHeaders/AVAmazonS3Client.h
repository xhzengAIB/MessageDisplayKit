//
// AVAmazonS3Client.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AVHTTPClient.h"

/**
 AVAmazonS3Client` is an `AVHTTPClient` subclass for interacting with the Amazon S3 webservice API (http://aws.amazon.com/s3/).
 */
@interface AVAmazonS3Client : AVHTTPClient

@property (readwrite, nonatomic, copy) NSString *accessKey;
@property (readwrite, nonatomic, copy) NSString *secret;

/**
 The base URL for the HTTP client.
 
 @discussion By default, the `baseURL` of `AVAmazonS3Client` is `kAVAmazonS3BaseURLString`, or if a `bucket` is set, `kAVAmazonS3BaseURLString` with the bucket as a subdomain. If `baseURL` is set directly, it will override the default `baseURL` and disregard any `bucket` property.
 */
@property (nonatomic, strong) NSURL *baseURL;

/**
 The S3 bucket for the client.
 
 @see `AVAmazonS3Client -baseURL`
 */
@property (nonatomic, copy) NSString *bucket;

/**
 Initializes and returns a newly allocated Amazon S3 client with specified credentials.

 This is the designated initializer.
 
 @param accessKey The AWS access key.
 @param secret The AWS secret.
 */
- (id)initWithAccessKeyID:(NSString *)accessKey
                   secret:(NSString *)secret;

/**
 Creates and enqueues a request operation to the client's operation queue.
 
 @param method The HTTP method for the request.
 @param path The path to be appended to the HTTP client's base URL and used as the request URL.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)enqueueS3RequestOperationWithMethod:(NSString *)method
                                       path:(NSString *)path
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

///-------------------------
/// @name Service Operations
///-------------------------

/**
 Returns a list of all buckets owned by the authenticated request sender.
 
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)getServiceWithSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;


///------------------------
/// @name Bucket Operations
///------------------------

/**
 Lists information about the objects in a bucket for a user that has read access to the bucket.
 
 @param bucket The S3 bucket to get.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)getBucket:(NSString *)bucket
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;

/**
 Creates a new bucket belonging to the account of the authenticated request sender. Optionally, you can specify a EU (Ireland) or US-West (N. California) location constraint.
 
 @param bucket The S3 bucket to create.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)putBucket:(NSString *)bucket
       parameters:(NSDictionary *)parameters
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure;

/**
 Deletes the specified bucket. All objects in the bucket must be deleted before the bucket itself can be deleted.
 
 @param bucket The S3 bucket to be delete.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)deleteBucket:(NSString *)bucket
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

///----------------------------------------------
/// @name Object Operations
///----------------------------------------------

/**
 Retrieves information about an object for a user with read access without fetching the object.
 
 @param path The object path.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)headObjectWithPath:(NSString *)path
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 Gets an object for a user that has read access to the object.
 
 @param path The object path.
 @param progress A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes three arguments: the number of bytes read since the last time the download progress block was called, the total bytes read, and the total bytes expected to be read during the request, as initially determined by the expected content size of the `NSHTTPURLResponse` object. This block may be called multiple times, and will execute on the main thread.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)getObjectWithPath:(NSString *)path
                 progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
                  success:(void (^)(id responseObject, NSData *responseData))success
                  failure:(void (^)(NSError *error))failure;

/**
 Gets an object for a user that has read access to the object.
 
 @param path The object path.
 @param outputStream The `NSOutputStream` object receiving data from the request.
 @param progress A block object to be called when an undetermined number of bytes have been downloaded from the server. This block has no return value and takes three arguments: the number of bytes read since the last time the download progress block was called, the total bytes read, and the total bytes expected to be read during the request, as initially determined by the expected content size of the `NSHTTPURLResponse` object. This block may be called multiple times, and will execute on the main thread.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)getObjectWithPath:(NSString *)path
             outputStream:(NSOutputStream *)outputStream
                 progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 Adds an object to a bucket using forms.
 
 @param path The path to the local file.
 @param destinationPath The destination path for the remote file.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param progress A block object to be called when an undetermined number of bytes have been uploaded to the server. This block has no return value and takes three arguments: the number of bytes written since the last time the upload progress block was called, the total bytes written, and the total bytes expected to be written during the request, as initially determined by the length of the HTTP body. This block may be called multiple times, and will execute on the main thread.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)postObjectWithFile:(NSString *)path
           destinationPath:(NSString *)destinationPath
                parameters:(NSDictionary *)parameters
                  progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

/**
 Adds an object to a bucket for a user that has write access to the bucket. A success response indicates the object was successfully stored; if the object already exists, it will be overwritten.
 
 @param path The path to the local file.
 @param destinationPath The destination path for the remote file.
 @param parameters The parameters to be encoded and set in the request HTTP body.
 @param progress A block object to be called when an undetermined number of bytes have been uploaded to the server. This block has no return value and takes three arguments: the number of bytes written since the last time the upload progress block was called, the total bytes written, and the total bytes expected to be written during the request, as initially determined by the length of the HTTP body. This block may be called multiple times, and will execute on the main thread.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)putObjectWithFile:(NSString *)path
          destinationPath:(NSString *)destinationPath
               parameters:(NSDictionary *)parameters
                 progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 Deletes the specified object. Once deleted, there is no method to restore or undelete an object.
 
 @param path The path for the remote file to be deleted.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes a single argument: the response object from the server.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a single argument: the `NSError` object describing error that occurred.
 */
- (void)deleteObjectWithPath:(NSString *)path
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

@end

///----------------
/// @name Constants
///----------------

/**
 `kAVAmazonS3BaseURLString`: http://s3.amazonaws.com
 */
extern NSString * const kAVAmazonS3BaseURLString;

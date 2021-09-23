#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PaymentPass, NSObject)
RCT_EXTERN_METHOD(
                  canAddPaymentPass: (NSString *) paymentRefrenceId
                  resolve: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

RCT_EXTERN_METHOD(
                  addPaymentPass: (NSString *) cardHolderName
                  lastFour: (NSString *) lastFour
                  paymentReferenceId: (NSString *) paymentReferenceId
                  errorCallback: (RCTResponseSenderBlock) errorCallback
                  successCallback: (RCTResponseSenderBlock)successCallback
                  )

RCT_EXTERN_METHOD(
                  finalizeAddCard: (NSData *) encryptedPassData
                  activationData: (NSData *) encryptedPassData
                  ephemeralPublicKey: (NSData *) encryptedPassData
                  resolve: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
@end

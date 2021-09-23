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
                  resolve: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )

@end

declare type PaymentPassType = {
    canAddPaymentPass: (paymentRefrenceId: string) => Promise<void>;
    addPaymentPass: (cardHolderName: string, lastFour: string, paymentReferenceId: string) => Promise<void>;
};
declare const _default: PaymentPassType;
export default _default;

export declare enum AddPaymentPassStatus {
    CAN_ADD = "CAN_ADD",
    ALREADY_ADDED = "ALREADY_ADDED",
    BLOCKED = "BLOCKED"
}
export interface DigitalWalletProvisionRequestParams {
    certificates: string[];
    nonce: string;
    nonceSignature: string;
    appVersion: string;
}
declare type PaymentPassType = {
    canAddPaymentPass: (paymentRefrenceId: string) => Promise<AddPaymentPassStatus>;
    addPaymentPass: (cardHolderName: string, lastFour: string, paymentReferenceId: string, errorCallback: () => void, successCallback: (params: DigitalWalletProvisionRequestParams) => void) => Promise<void>;
    finalizeAddCard: (encryptedPassData: string, activationData: string, ephemeralPublicKey: string) => Promise<void>;
};
declare const _default: PaymentPassType;
export default _default;

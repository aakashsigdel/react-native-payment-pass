export declare enum AddPaymentPassStatus {
    CAN_ADD = "CAN_ADD",
    ALREADY_ADDED = "ALREADY_ADDED",
    BLOCKED = "BLOCKED"
}
export interface DigitalWalletProvisionRequestParams {
    device_type: string;
    certificates: string[];
    nonce: string;
    nonce_signature: string;
    app_version: string;
}
declare type CanAddPaymentPass = (paymentRefrenceId: string) => Promise<AddPaymentPassStatus>;
declare type AddPaymentPass = (cardHolderName: string, lastFour: string, paymentReferenceId: string, successCallback: (params: DigitalWalletProvisionRequestParams) => void, errorCallback?: (error: string) => void) => void;
declare type FinalizeAddCard = (encryptedPassData: string, activationData: string, ephemeralPublicKey: string, successCallback: () => void, errorCallback?: (error: string) => void) => void;
declare type RemoveSuspendedCard = (paymentReferenceId: string) => Promise<void>;
declare type PaymentPassType = {
    canAddPaymentPass: CanAddPaymentPass;
    addPaymentPass: AddPaymentPass;
    finalizeAddCard: FinalizeAddCard;
    removeSuspendedCard: RemoveSuspendedCard;
};
declare const _default: PaymentPassType;
export default _default;

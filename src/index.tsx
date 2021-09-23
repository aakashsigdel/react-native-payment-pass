import { NativeModules } from 'react-native';

export enum AddPaymentPassStatus {
  CAN_ADD = 'CAN_ADD',
  ALREADY_ADDED = 'ALREADY_ADDED',
  BLOCKED = 'BLOCKED',
}

export interface DigitalWalletProvisionRequestParams {
  certificates: string[];
  nonce: string;
  nonceSignature: string;
  appVersion: string;
}

type PaymentPassType = {
  canAddPaymentPass: (
    paymentRefrenceId: string
  ) => Promise<AddPaymentPassStatus>;
  addPaymentPass: (
    cardHolderName: string,
    lastFour: string,
    paymentReferenceId: string,
    errorCallback: () => void,
    successCallback: (params: DigitalWalletProvisionRequestParams) => void
  ) => Promise<void>;
};

const { PaymentPass } = NativeModules;

export default PaymentPass as PaymentPassType;

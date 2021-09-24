import { NativeModules } from 'react-native';

export enum AddPaymentPassStatus {
  CAN_ADD = 'CAN_ADD',
  ALREADY_ADDED = 'ALREADY_ADDED',
  BLOCKED = 'BLOCKED',
}

export interface DigitalWalletProvisionRequestParams {
  device_type: string;
  certificates: string[];
  nonce: string;
  nonce_signature: string;
  app_version: string;
}

type CanAddPaymentPass = (
  paymentRefrenceId: string
) => Promise<AddPaymentPassStatus>;

type AddPaymentPass = (
  cardHolderName: string,
  lastFour: string,
  paymentReferenceId: string,
  errorCallback: () => void,
  successCallback: (params: DigitalWalletProvisionRequestParams) => void
) => Promise<void>;

type FinalizeAddCard = (
  encryptedPassData: string,
  activationData: string,
  ephemeralPublicKey: string
) => Promise<void>;

type RemoveSuspendedCard = (paymentReferenceId: string) => Promise<void>;

type PaymentPassType = {
  canAddPaymentPass: CanAddPaymentPass;
  addPaymentPass: AddPaymentPass;
  finalizeAddCard: FinalizeAddCard;
  removeSuspendedCard: RemoveSuspendedCard;
};

const { PaymentPass } = NativeModules;

export default PaymentPass as PaymentPassType;

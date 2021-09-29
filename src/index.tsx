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
  successCallback: (params: DigitalWalletProvisionRequestParams) => void,
  errorCallback?: (error: string) => void
) => void;

type FinalizeAddCard = (
  encryptedPassData: string,
  activationData: string,
  ephemeralPublicKey: string,
  successCallback: () => void,
  errorCallback?: (error: string) => void
) => void;

type RemoveSuspendedCard = (paymentReferenceId: string) => Promise<void>;

type PaymentPassType = {
  canAddPaymentPass: CanAddPaymentPass;
  addPaymentPass: AddPaymentPass;
  finalizeAddCard: FinalizeAddCard;
  removeSuspendedCard: RemoveSuspendedCard;
};

const { PaymentPass: PaymentPassModule } = NativeModules;

function noop(): void {}

const addPaymentPass: AddPaymentPass = (
  cardHolderName,
  lastFour,
  paymentReferenceId,
  successCallback,
  errorCallback
) => {
  PaymentPassModule.addPaymentPass(
    cardHolderName,
    lastFour,
    paymentReferenceId,
    successCallback,
    errorCallback ? errorCallback : noop
  );
};

const finalizeAddCard: FinalizeAddCard = (
  encryptedPassData,
  activationData,
  ephemeralPublicKey,
  successCallback,
  errorCallback
) => {
  PaymentPassModule.finalizeAddCard(
    encryptedPassData,
    activationData,
    ephemeralPublicKey,
    successCallback,
    errorCallback ? errorCallback : noop
  );
};

const PaymentPass = { ...PaymentPassModule, addPaymentPass, finalizeAddCard };

export default PaymentPass as PaymentPassType;

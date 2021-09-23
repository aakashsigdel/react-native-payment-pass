import { NativeModules } from 'react-native';

type PaymentPassType = {
  canAddPaymentPass: (paymentRefrenceId: string) => Promise<void>;
  addPaymentPass: (
    cardHolderName: string,
    lastFour: string,
    paymentReferenceId: string
  ) => Promise<void>;
};

const { PaymentPass } = NativeModules;

export default PaymentPass as PaymentPassType;

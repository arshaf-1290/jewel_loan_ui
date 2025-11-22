export interface LoanReceipt {
  id: number;
  loanId: number;
  loanNo: string | null;
  receiptNo: string;
  receiptDate: string;
  amountReceived: number;
  paymentMode: string;
  referenceNo?: string | null;
  notes?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateLoanReceiptPayload {
  loanId: number;
  receiptNo: string;
  receiptDate: string;
  amountReceived: number;
  paymentMode: string;
  referenceNo?: string;
  notes?: string;
}


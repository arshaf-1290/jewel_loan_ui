export interface Loan {
  id: number;
  loanDate: string;
  customerId: number;
  customerName: string | null;
  loanNo: string;
  principalAmount: number;
  ornamentDescription: string;
  grossWeight: number;
  netWeight: number;
  interestRate: number;
  tenureMonths: number;
  status: 'Active' | 'Closed' | 'Overdue';
  notes?: string | null;
  createdAt: string;
  updatedAt: string;
  items?: LoanItem[];
}

export interface LoanItem {
  id: number;
  loanId: number;
  description: string;
  grossWeight: number;
  netWeight: number;
  purity: string;
  valuation: number;
}

export interface CreateLoanPayload {
  loanDate: string;
  customerId: number;
  loanNo: string;
  principalAmount: number;
  ornamentDescription: string;
  grossWeight: number;
  netWeight: number;
  interestRate: number;
  tenureMonths: number;
  status: 'Active' | 'Closed' | 'Overdue';
  notes?: string;
  items: Array<{
    description: string;
    grossWeight: number;
    netWeight: number;
    purity: string;
    valuation: number;
  }>;
}


export interface LedgerEntry {
  id: number;
  entryDate: string;
  ledgerHead: string;
  referenceType: string;
  referenceId: number | null;
  particulars: string;
  debit: number;
  credit: number;
  balance: number;
  createdAt: string;
}

export interface LedgerFilter {
  head?: string;
  fromDate?: string;
  toDate?: string;
}


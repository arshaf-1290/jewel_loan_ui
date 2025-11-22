export interface ExpenseEntry {
  id: number;
  expenseDate: string;
  expenseType: string;
  amount: number;
  notes?: string | null;
  attachmentUrl?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface CreateExpensePayload {
  expenseDate: string;
  expenseType: string;
  amount: number;
  notes?: string;
  attachmentUrl?: string;
}


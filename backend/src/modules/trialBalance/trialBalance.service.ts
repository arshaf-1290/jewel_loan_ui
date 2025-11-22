import type { RowDataPacket } from 'mysql2';

import { query } from '../../config/database.js';

export const latestTrialBalance = async () => {
  const [rows] = await query<RowDataPacket[]>(
    `SELECT *
     FROM trial_balance_snapshots
     ORDER BY snapshot_date DESC
     LIMIT 1`
  );
  if (!rows.length) {
    return { snapshotDate: null, entries: [] };
  }

  const snapshot = rows[0];
  const [entries] = await query<RowDataPacket[]>(
    `SELECT *
     FROM trial_balance_entries
     WHERE snapshot_id = :snapshotId
     ORDER BY ledger_head`,
    { snapshotId: snapshot.id }
  );
  return {
    snapshotDate: snapshot.snapshot_date,
    entries: entries.map((row) => ({
      ledgerHead: row.ledger_head,
      debit: Number(row.debit ?? 0),
      credit: Number(row.credit ?? 0),
    })),
  };
};


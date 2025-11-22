import mysql from 'mysql2/promise';

import { env } from './env.js';

export const pool = mysql.createPool({
  host: env.mysql.host,
  port: env.mysql.port,
  user: env.mysql.user,
  password: env.mysql.password,
  database: env.mysql.database,
  connectionLimit: env.mysql.connectionLimit,
  namedPlaceholders: true,
  timezone: '+00:00',
});

export const withTransaction = async <T>(handler: (connection: mysql.PoolConnection) => Promise<T>) => {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();
    const result = await handler(connection);
    await connection.commit();
    return result;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
};

export const query = async <T = mysql.RowDataPacket[] | mysql.RowDataPacket[][] | mysql.OkPacket | mysql.OkPacket[]>(
  sql: string,
  params: Record<string, unknown> | unknown[] = {}
): Promise<[T, mysql.FieldPacket[]]> => pool.execute(sql, params as never);


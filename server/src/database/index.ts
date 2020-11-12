import mysql, { Connection, MysqlError, QueryOptions } from 'mysql';

interface ExtendedConnection extends Connection {
    asyncQuery(query: string, ...params: (string | number | boolean)[]): Promise<any>
    asyncBeginTransaction(options?: QueryOptions, callback?: (err: MysqlError) => void): Promise<MysqlError>;
    asyncCommit(options?: QueryOptions, callback?: (err: MysqlError) => void): Promise<MysqlError>;
    asyncRollback(options?: QueryOptions, callback?: (err: MysqlError) => void): Promise<MysqlError>;
}

const connection: ExtendedConnection = mysql.createConnection({
    host: process.env.DATABASE_HOST || 'localhost',
    port: parseInt(process.env.DATABASE_PORT ? process.env.DATABASE_PORT : '3306'),
    database: process.env.DATABASE_NAME || 'bd-ple',
    user: process.env.DATABASE_USER || 'root',
    password: process.env.DATABASE_PASS || ''
}) as ExtendedConnection;
connection.connect();
connection.asyncQuery = (query: string, ...params: (string | number | boolean | undefined)[]) => {
    return new Promise((resolve, reject) => {
        try {
            return connection.query(query, params, (error, result, _) => error ? reject(error) : resolve(result));
        } catch (error) {
            return reject(error);
        }
    });
}
connection.asyncBeginTransaction = (options?: QueryOptions, callback?: (err: MysqlError) => void) => {
    return new Promise((resolve, reject) => {
        try {
            return connection.beginTransaction(options, (error) => resolve(error));
        } catch (error) {
            return reject(error);
        }
    });
}
connection.asyncCommit = (options?: QueryOptions, callback?: (err: MysqlError) => void) => {
    return new Promise((resolve, reject) => {
        try {
            return connection.commit(options, (error) => resolve(error));
        } catch (error) {
            return reject(error);
        }
    });
}
connection.asyncRollback = (options?: QueryOptions, callback?: (err: MysqlError) => void) => {
    return new Promise((resolve, reject) => {
        try {
            return connection.rollback(options, (error) => resolve(error));
        } catch (error) {
            return reject(error);
        }
    });
}

export default connection;
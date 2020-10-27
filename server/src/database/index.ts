import mysql, { Connection } from 'mysql';

interface ExtendedConnection extends Connection {
    asyncQuery(query: string, ...params: (string | number | boolean)[]): Promise<any[]>
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

export default connection;
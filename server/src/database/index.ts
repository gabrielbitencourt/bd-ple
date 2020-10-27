import mysql, { Connection, FieldInfo } from 'mysql';

interface ExtendedConnection extends Connection {
    asyncQuery(query: string, ...params: (string | number | boolean)[]): Promise<{ results: any[], fields?: FieldInfo[] }>
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
        const nParams = query.split('?').length - 1;
        if (nParams != params.length) {
            return reject("Número de parâmetros da query é diferente do que o esperado.");
        }
        try {
            let consolidatedQuery = query;
            for (const param of params) {
                let value;
                if (param == undefined) {
                    value = 'null'
                }
                else {
                    value = param.toString();
                    if (typeof param == "string") {
                        value = '"' + value + '"';
                    }
                }
                consolidatedQuery = consolidatedQuery.replace('?', value);
            }
            return connection.query(consolidatedQuery, (error, result, fields) => error ? reject(error) : resolve({ results: result, fields }));
        } catch (error) {
            return reject(error);
        }
    });
}

export default connection;
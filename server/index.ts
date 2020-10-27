import express from 'express';
import path from 'path';
import { json } from 'body-parser';

import routes from './src/routes';

import dotenv from 'dotenv';
dotenv.config();

const app = express();
app.use(json());
app.use('/api/v1', routes);

app.use(express.static(path.join(__dirname, '../../client/dist/client')))
app.get('*', (_req, res) => {
    return res.status(200).sendFile(path.join(__dirname, '../../client/dist/client/index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`App is listening in ${PORT}`);
});
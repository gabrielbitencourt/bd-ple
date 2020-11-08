import express from 'express';
import path from 'path';
import { json } from 'body-parser';
import cookie from 'cookie-parser';
import cors from 'cors';
import logger from 'morgan';

// import configurations from .env to process.env variable
import dotenv from 'dotenv';
dotenv.config();

// use passport strategy to authenticate requests with JWT token
// on secure, encrypted and server-only cookie
import passport from 'passport';
import { JwtCookieStrategy } from './src/config/passport';
passport.use(new JwtCookieStrategy());

import routes from './src/routes';

const app = express();

// logger middleware for development environment
if (process.env.DEVELOPMENT == "true") {
    app.use(logger('dev'));
}

// parse json body and cookies 
app.use(json());
app.use(cookie(process.env.COOKIE_SECRET || 'n0ts4f3sEcRE7'));

// allow cross origin requests (TODO: not necessary for production)
app.use(cors({
    credentials: true,
    origin: 'http://localhost:4200'
}));

// initialize passport middleware
app.use(passport.initialize());


// return success for every cors preflight request
app.options('*', (_, res) => {
    res.status(200);
    return res.send();
});

// api routes versioned
app.use('/api/v1', routes);

// serve static files
app.use(express.static(path.join(__dirname, '../../client/dist/client')))

// every get request that doesn't match an api route will fallback
// to index.html which may redirect to 404 page on client side application
app.get('*', (_req, res) => {
    return res.status(200).sendFile(path.join(__dirname, '../../client/dist/client/index.html'));
});

// start server on port 3000 by default
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`App is listening in ${PORT}`);
});
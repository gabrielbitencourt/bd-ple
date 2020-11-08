import express from 'express';
import passport from 'passport';
import jwt from 'jsonwebtoken';
import connection from '../database';

export class JwtCookieStrategy implements passport.Strategy {
    name = 'jwt-cookie';
    async authenticate(this: passport.StrategyCreated<this>, req: express.Request, options?: any): Promise<any> {
        try {
            const token = req.signedCookies.jwt;
            // console.log(token);
            if (token) {
                const decoded = jwt.verify(token, process.env.JWT_SECRET || 'n0ts4f3sEcRE7');
                // console.log(decoded);
                if (decoded) {
                    const user = (await connection.asyncQuery("SELECT * FROM tb_User WHERE login = ?;", (decoded as any).sub))[0];
                    if (user) return this.success(user)
                }
            }
            return this.fail();
        }
        catch (error) {
            return this.fail(undefined, 500);
        }
    }
}
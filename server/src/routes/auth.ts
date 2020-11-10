import { Router } from 'express';
import connection from '../database';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import passport from 'passport';
import { validator } from 'indicative';
const validations = validator.validations;

const router = Router();
router.post('/login', async (req, res) => {
    const body = req.body;
    try {
        await validator.validateAll(body, {
            login: [
                validations.required()
            ],
            password: [
                validations.required()
            ]
        });
    }
    catch (error) {
        res.status(422);
        return res.json({
            error: true,
            data: error
        });
    }

    try {
        const results = await connection.asyncQuery(`
            SELECT login, password FROM tb_User WHERE login = ?;
        `, body.login);
        if (!results || !results.length) {
            res.status(404);
            return res.json({
                error: true
            });
        } 
        
        const user = results[0];
        if (bcrypt.compareSync(body.password, user.password)) {
            const token = jwt.sign({}, process.env.JWT_SECRET || 'n0ts4f3sEcRE7', {
                expiresIn: '7 days',
                subject: user.login,
                audience: 'web',
                issuer: 'node'
            });
            res.cookie('jwt', token, {
                signed: true,
                httpOnly: true,
                secure: process.env.development === "true",
                sameSite: process.env.development === "true"
            });
            res.status(200);
            return res.json({
                error: false
            });
        }
        res.status(401);
        return res.json({
            error: true
        });
    }
    catch (error) {
        res.status(500);
        return res.json({
            error: true,
            data: error
        });
    }
});
router.post('/register', async (req, res) => {
    const body = req.body;
    try {
        await validator.validateAll(body, {
            login: [
                validations.required(),
                validations.alphaNumeric()
            ],
            password: [
                validations.required(),
                validations.min([8]),
                validations.confirmed()
            ],
            firstName: [
                validations.required(),
                validations.max([100])
            ],
            lastName: [
                validations.required(),
                validations.max([100])
            ],
            eMail: [
                validations.email()
            ],
            foneNumber: [
                validations.number()
            ]
        });
    }
    catch (error) {
        res.status(422);
        return res.json({
            error: true,
            data: error
        });
    }

    try {
        connection.asyncQuery(`
            INSERT INTO tb_User
            (login, firstName, lastName, regionalCouncilCode, password, eMail, foneNumber)
            VALUES (?,?,?,?,?,?,?)
        `, body.login, body.firstName, body.lastName, body.regionalCouncilCode, bcrypt.hashSync(body.password, 12), body.eMail, body.foneNumber);
        res.status(200);
        return res.json({
            error: false
        });
    }
    catch (error) {
        res.status(500);
        return res.json({
            error: true,
            data: error
        });
    }
});
router.get('/refresh', passport.authenticate('jwt-cookie', { session: false }), (req, res) => {
    res.status(200);
    return res.json({
        error: false,
        data: req.user
    });
});
export default router;
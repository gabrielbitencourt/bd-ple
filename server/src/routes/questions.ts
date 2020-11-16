import { Router } from 'express';
import connection from '../database';

const router = Router();
router.get('/', async (req, res) => {
    try {
        const result = await connection.asyncQuery("SELECT * FROM tb_questions;");
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    }
    catch (error) {
        res.status(500);
        console.error(error);
        return res.json({
            error: false,
            message: error
        });
    }
});

export default router;
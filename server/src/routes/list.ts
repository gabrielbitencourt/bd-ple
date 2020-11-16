import { Router } from 'express';
import connection from '../database';

const router = Router();
router.get('/', async (req, res) => {
    try {
        const result = await connection.asyncQuery("SELECT listOfValuesID, description FROM tb_listofvalues;", req.params.listID);
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        return res.json({
            error: true,
            data: error
        });
    }
});

router.get('/:listID', async (req, res) => {
    try {
        const result = await connection.asyncQuery("SELECT listOfValuesID, description FROM tb_listofvalues WHERE listTypeID = ?", req.params.listID);
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        return res.json({
            error: true,
            data: error
        });
    }
});
export default router;
import { Router } from 'express';
import connection from '../database';

const router = Router();
router.get('/:questionnaireID', async (req, res) => {
    try {
        const result = await connection.asyncQuery(`
            SELECT * FROM tb_CRFForms crf WHERE crf.questionnaireID = ?;`, req.params.questionnaireID);
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
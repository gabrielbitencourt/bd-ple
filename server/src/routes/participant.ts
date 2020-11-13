import { Router } from 'express';
import { participant } from '../models/participant';

const router = Router();
router.get('/:id?', async (req, res) => {
    try {
        let result;
        if (req.params.id) {
            result = await participant.getById(req.params.id);
        }
        else {
            result = await participant.getAll();
        }
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        console.log(req.params.id);
        res.status(500);
        console.error(error);
        return res.json({
            error: true,
            data: error
        });
    }
});
export default router;
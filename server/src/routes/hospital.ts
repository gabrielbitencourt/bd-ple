import { Router } from 'express';
import { hospital } from '../models/hospital';

const router = Router();
router.get('/:id?', async (req, res) => {
    try {
        let result;
        if (req.params.id) {
            result = await hospital.getByID(req.params.id);
        }
        else {
            result = await hospital.getAll();
        }
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        console.error(error);
        return res.json({
            error: true,
            data: error
        });
    }
});
export default router;
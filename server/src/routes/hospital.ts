import { Router } from 'express';
import { hospital } from '../models/hospital';

const router = Router();
router.get('/', async (req, res) => {
    try {
        const result = await hospital.getAll();
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
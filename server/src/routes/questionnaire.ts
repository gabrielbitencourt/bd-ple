import { Router } from 'express';
import { questionnaire } from '../models/questionnaire';
import { validator } from 'indicative';

const router = Router();
router.get('/', async (req, res) => {
    const result = await questionnaire.getAll();
    res.status(200);
    return res.json({
        error: false,
        data: result
    });
});

router.get('/:id', async (req, res) => {
    try {
        const result = await questionnaire.getById(req.params.id);
        res.status(200);
            return res.json({
                error: false,
                data: result
            });
    }
    catch (error) {
        res.status(404);
        console.error(error);
        return res.json({
            error: false,
            message: error.message
        });
    }
});

router.post('/', async (req, res) => {
    const body = req.body;
    try {
        await validator.validateAll(body, questionnaire.validations.insertValidation);
    } catch (error) {
        res.status(422);
        res.json({
            error: true,
            data: error
        });
    }

    try {
        await questionnaire.create(body);
        res.status(200);
        res.json({
            error: false
        });
    } catch (error) {
        res.status(502);
        console.error(error);
        return res.json({
            error: false,
            message: error.message
        });
    }
});

export default router;
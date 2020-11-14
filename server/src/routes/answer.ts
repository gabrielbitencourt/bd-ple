import { Router } from 'express';
import connection from '../database';
import { validator } from 'indicative';
const validations = validator.validations;

const router = Router();
router.post('/', async (req, res) => {
    const body: any[] = req.body;
    try {
        await validator.validateAll({b: body}, {
            'b.*.formRecordID': [
                validations.required(),
                validations.number()
            ],
            'b.*.crfFormsID': [
                validations.required(),
                validations.number()
            ],
            'b.*.questionID': [
                validations.required(),
                validations.number()
            ],
            'b.*.listOfValuesID': [
                validations.requiredWithoutAny(['answer']),
                validations.number()
            ],
            'b.*.answer': [
                validations.requiredWithoutAny(['listOfValuesID']),
            ]
        });
    } catch (error) {
        console.log(error);
        res.status(422);
        return res.json({
            error: true,
            data: error
        });
    }

    try {
        const result = await connection.asyncQuery(`
            INSERT INTO tb_questiongroupformrecord (formRecordID, crfFormsID, questionID, listOfValuesID, answer)
            VALUES ${body.map(_ => '(?, ?, ?, ?, ?)').join(', ')};
        `, ...body.reduce((prev, i) => {
            prev.push(...[i.formRecordID, i.crfFormsID, i.questionID, i.listOfValuesID, i.answer]);
            return prev;
        }, []));
        if (result.insertId) {
            res.status(200);
            return res.json({
                error: false,
                data: result.insertId
            });
        }
        res.status(500);
        return res.json({
            error: true
        });
    } catch (error) {
        console.log(error);
        res.status(500);
        return res.json({
            error: true,
            data: error
        });
    }
});
router.put('/multiple', async (req, res) => {
    const body: { questionGroupFormRecordID: number, listOfValuesID?: number, answer: any }[] = req.body;
    try {
        await validator.validateAll({ b: body }, {
            'b.*.questionGroupFormRecordID': [
                validations.required(),
                validations.number()
            ],
            'b.*.listOfValuesID': [
                validations.requiredWithoutAny(['answer']),
                validations.number()
            ],
            'b.*.answer': [
                validations.requiredWithoutAny(['listOfValuesID']),
            ]
        });
    } catch (error) {
        res.status(422);
        return res.json({
            error: true,
            data: error
        });
    }

    try {
        for (const toUpdate of body) {
            const fields = Object.keys(toUpdate).filter(f => f === 'answer' || f === 'listOfValuesID');
            const setString = fields.map(k => `${k} = ?`).join(', ');
            const params = fields.map(k => {
                return (toUpdate as any)[k];
            });
            const query = `
                UPDATE tb_questiongroupformrecord
                SET ${setString}
                WHERE questionGroupFormRecordID = ${toUpdate.questionGroupFormRecordID};
            `
            await connection.asyncQuery(query, ...params);
        }
        res.status(200);
        return res.json({
            error: false
        });
    } catch (error) {
        console.log(error);
        res.status(500);
        return res.json({
            error: false,
            data: error
        });
    }
});
router.put('/:id', async (req, res) => {
    const toUpdate = req.body;
    try {
        await validator.validateAll(toUpdate, {
            questionGroupFormRecordID: [
                validations.required(),
                validations.number()
            ],
            listOfValuesID: [
                validations.requiredWithoutAny(['answer']),
                validations.number()
            ],
            answer: [
                validations.requiredWithoutAny(['listOfValuesID']),
            ]
        });
    } catch (error) {
        res.status(422);
        return res.json({
            error: true,
            data: error
        });
    }

    try {
        const fields = Object.keys(toUpdate).filter(f => f === 'answer' || f === 'listOfValuesID');
        const setString = fields.map(k => `${k} = ?`).join(', ');
        const params = fields.map(k => {
            return (toUpdate as any)[k];
        });
        const query = `
                UPDATE tb_questiongroupformrecord
                SET ${setString}
                WHERE questionGroupFormRecordID = ${toUpdate.questionGroupFormRecordID};
            `
        await connection.asyncQuery(query, ...params);
        res.status(200);
        return res.json({
            error: false
        });
    } catch (error) {
        console.log(error);
        res.status(500);
        return res.json({
            error: false,
            data: error
        });
    }
});
export default router;
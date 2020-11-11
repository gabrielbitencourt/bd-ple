import { Router } from 'express';
import { formRecord } from '../models/form-record';
import { validator } from 'indicative';
import connection from '../database';

const router = Router();
router.get('/:questionnaireID/groups', async (req, res) => {
    const query = `
        SELECT
            p.participantID,
            p.medicalRecord numeroPaciente,
            h.hospitalUnitID,
            h.hospitalUnitName hospital
        FROM tb_FormRecord fr
        LEFT JOIN tb_HospitalUnit h ON fr.hospitalUnitID = h.hospitalUnitID
        LEFT JOIN tb_Participant p ON fr.participantID = p.participantID
        LEFT JOIN tb_questiongroupformrecord qgfr ON qgfr.formRecordID = fr.formRecordID
        LEFT JOIN tb_ListOfValues lv ON qgfr.listOfValuesID = lv.listOfValuesID
        LEFT JOIN tb_ListType lt ON lv.listTypeID = lt.listTypeID
        LEFT JOIN tb_Questions q ON qgfr.questionID = q.questionID
        LEFT JOIN tb_Questions qs ON q.subordinateTo = qs.questionID
        LEFT JOIN tb_QuestionType qt ON q.questionTypeID = qt.questionTypeID
        LEFT JOIN tb_QuestionGroup qg ON q.questionGroupID = qg.questionGroupID
        WHERE fr.questionnaireID = ?
        GROUP BY participantID, numeroPaciente, hospital, hospitalUnitID;`;
    
    try {
        const result = await connection.asyncQuery(query, req.params.questionnaireID);
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        return res.json({
            error: false,
            message: error
        });
    }
});
router.get('/:questionnaireID/:participantID/:hospitalID', async (req, res) => {
    const query = `
        SELECT
            fr.formRecordID,
            fr.dtRegistroForm dataAplicacao,

            qgfr.answer respostaLivre,

            lv.description respostaLista,
            lt.description nomeLista,

            q.questionID,
            q.description pergunta,

            qt.questionTypeID,
            qt.description tipoPergunta,

            qg.questionGroupID,
            qg.description grupo,

            qs.questionID questaoPai
        FROM tb_FormRecord fr
        LEFT JOIN tb_HospitalUnit h ON fr.hospitalUnitID = h.hospitalUnitID
        LEFT JOIN tb_Participant p ON fr.participantID = p.participantID
        LEFT JOIN tb_questiongroupformrecord qgfr ON qgfr.formRecordID = fr.formRecordID
        LEFT JOIN tb_ListOfValues lv ON qgfr.listOfValuesID = lv.listOfValuesID
        LEFT JOIN tb_ListType lt ON lv.listTypeID = lt.listTypeID
        LEFT JOIN tb_Questions q ON qgfr.questionID = q.questionID
        LEFT JOIN tb_Questions qs ON q.subordinateTo = qs.questionID
        LEFT JOIN tb_QuestionType qt ON q.questionTypeID = qt.questionTypeID
        LEFT JOIN tb_QuestionGroup qg ON q.questionGroupID = qg.questionGroupID
        WHERE
            fr.questionnaireID = ?
        AND
            h.hospitalUnitID = ?
        AND
            p.participantID = ?;`;

    try {
        const result = await connection.asyncQuery(query, req.params.questionnaireID, req.params.hospitalID, req.params.participantID);
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        return res.json({
            error: false,
            data: error
        });
    }

});

router.post('/', async (req, res) => {
    const body = req.body;
    try {
        await validator.validateAll(body, formRecord.validations.insertValidation);
    } catch (error) {
        res.status(422);
        res.json({
            error: true,
            data: error
        });
    }

    try {
        await formRecord.create(body);
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

router.put('/:id', async (req, res) => {
    const body = req.body;
    try {
        await validator.validateAll(body, formRecord.validations.updateValidation);
    } catch (error) {
        res.status(422);
        res.json({
            error: true,
            data: error
        });
    }

    try {
        await formRecord.update(req.params.id, body);
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

router.delete('/:id', async (req, res) => {
    try {
        await formRecord.delete(req.params.id);
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
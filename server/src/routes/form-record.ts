import { Router } from 'express';
import { validator } from 'indicative';
import connection from '../database';

const router = Router();
router.get('/:questionnaireID/groups', async (req, res) => {
    const query = `
        SELECT
            p.participantID,
            p.medicalRecord,
            h.hospitalUnitID,
            h.hospitalUnitName
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
        GROUP BY participantID, medicalRecord, hospitalUnitName, hospitalUnitID;`;

    try {
        const result = await connection.asyncQuery(query, req.params.questionnaireID);
        res.status(200);
        return res.json({
            error: false,
            data: result
        });
    } catch (error) {
        res.status(500);
        console.log(error);
        return res.json({
            error: false,
            data: error
        });
    }
});
router.get('/:questionnaireID/participant/:participantID/hospital/:hospitalUnitID', async (req, res) => {
    const query = `
        SELECT
            fr.formRecordID,
            fr.dtRegistroForm,
            crf.description crfDescription,

            qgfr.answer,

            lv.listOfValuesID listValueID,
            lv.description listValueDescription,
            q.listTypeID listTypeID,
            lt.description listTypeDescription,

            q.questionID,
            q.description questionDescription,

            qt.questionTypeID,
            qt.description questionTypeDescription,

            qg.questionGroupID,
            qg.description questionGroupDescription,

            qs.questionID questaoPaiID
        FROM tb_FormRecord fr
        LEFT JOIN tb_CRFForms crf ON fr.crfFormsID = crf.crfFormsID
        LEFT JOIN tb_HospitalUnit h ON fr.hospitalUnitID = h.hospitalUnitID
        LEFT JOIN tb_Participant p ON fr.participantID = p.participantID
        LEFT JOIN tb_questiongroupformrecord qgfr ON qgfr.formRecordID = fr.formRecordID
        LEFT JOIN tb_QuestionGroupForm qgf ON crf.crfFormsID = qgf.crfFormsID
        LEFT JOIN tb_Questions q ON qgf.questionID = q.questionID
        LEFT JOIN tb_Questions qs ON q.subordinateTo = qs.questionID
        LEFT JOIN tb_QuestionType qt ON q.questionTypeID = qt.questionTypeID
        LEFT JOIN tb_QuestionGroup qg ON q.questionGroupID = qg.questionGroupID
        LEFT JOIN tb_ListOfValues lv ON qgfr.listOfValuesID = lv.listOfValuesID
        LEFT JOIN tb_ListType lt ON q.listTypeID = lt.listTypeID
        WHERE
            fr.questionnaireID = ?
        AND
            h.hospitalUnitID = ?
        AND
            p.participantID = ?
        ORDER BY qgf.questionOrder ASC;`;

    try {
        const result = await connection.asyncQuery(query, req.params.questionnaireID, req.params.hospitalUnitID, req.params.participantID);
        res.status(200);
        return res.json({
            error: false,
            data: result
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

router.post('/:questionnaireID/crf/:crfFormsID/participant/:participantID/hospital/:hospitalUnitID', async (req, res) => {
    const params = req.params;
    const err = await connection.asyncBeginTransaction();
    if (err) {
        await connection.asyncRollback();
        res.status(500);
        console.error(err);
        return res.json({
            error: false,
            data: err
        });
    }
    try {
        await connection.asyncQuery(`
                INSERT INTO
                    tb_AssessmentQuestionnaire (participantID, hospitalUnitID, questionnaireID)
                VALUES (?, ?, ?);`, params.participantID, params.hospitalUnitID, params.questionnaireID);

        const result = await connection.asyncQuery(`
                INSERT INTO
                    tb_FormRecord (participantID, hospitalUnitID, questionnaireID, crfFormsID, dtRegistroForm)
                VALUES (?, ?, ?, ?, NOW());`, params.participantID, params.hospitalUnitID, params.questionnaireID, params.crfFormsID);

        if (result.insertId) {
            connection.asyncCommit();
            res.status(200);
            return res.json({
                error: false,
                data: {
                    formRecordID: result.insertId
                }
            });
        }
        await connection.asyncRollback();
        throw new Error("Não foi inserido registro na tabela tb_FormRecord.");

    } catch (error) {
        await connection.asyncRollback();

        res.status(500);
        console.error(error);
        return res.json({
            error: false,
            data: error
        });
    }
});

router.put('/:id', async (req, res) => {
    const body = req.body;
    try {
        // await validator.validateAll(body, formRecord.validations.updateValidation);
    } catch (error) {
        res.status(422);
        res.json({
            error: true,
            data: error
        });
    }

    try {
        // TO-DO
        res.status(200);
        res.json({
            error: false
        });
    } catch (error) {
        res.status(500);
        console.error(error);
        return res.json({
            error: false,
            data: error
        });
    }
});
router.delete('/:id', async (req, res) => {
    try {
        // TO-DO
        res.status(200);
        res.json({
            error: false
        });
    } catch (error) {
        res.status(500);
        console.error(error);
        return res.json({
            error: false,
            data: error
        });
    }
});

export default router;
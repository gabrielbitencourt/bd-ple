import { Router } from 'express';
import connection from '../database';

const router = Router();
router.get('/questionnaire/:questionnaireID', async (req, res) => {
    const query = `
        SELECT
            p.participantID,
            p.medicalRecord,
            h.hospitalUnitID,
            h.hospitalUnitName
        FROM tb_assessmentquestionnaire asq
        LEFT JOIN tb_HospitalUnit h ON asq.hospitalUnitID = h.hospitalUnitID
        LEFT JOIN tb_Participant p ON asq.participantID = p.participantID
        WHERE asq.questionnaireID = ?;`;

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
router.get('/questionnaire/:questionnaireID/hospital/:hospitalUnitID/participant/:participantID', async (req, res) => {
    const query = `
        SELECT
            fr.formRecordID,
            crf.description,
            fr.dtRegistroForm,
            fr.crfFormsID
        FROM tb_FormRecord fr
        LEFT JOIN tb_CRFForms crf ON fr.crfFormsID = crf.crfFormsID
        WHERE
            fr.questionnaireID = ?
        AND
            fr.hospitalUnitID = ?
        AND
            fr.participantID = ?;`;
    try {
        const result = await connection.asyncQuery(query, req.params.questionnaireID, req.params.hospitalUnitID, req.params.hospitalUnitID);
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
router.get('/:formRecordID', async (req, res) => {
    const query = `
        SELECT
            fr.formRecordID,
            fr.dtRegistroForm,
            crf.crfFormsID,
            crf.description crfDescription,

            qgfr.questionGroupFormRecordID,
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
            (
                SELECT
                    COUNT(DISTINCT qs.questionID)
                FROM tb_Questions qs
                LEFT JOIN tb_QuestionGroupForm qsgf ON qs.questionID = qsgf.questionID
                LEFT JOIN tb_CRFForms crfs ON qsgf.crfFormsID = crfs.crfFormsID
                WHERE
                    qs.subordinateTo = q.questionID
                AND
                    crfs.crfFormsID = crf.crfFormsID
            ) subordinateCount
        FROM tb_FormRecord fr
        LEFT JOIN tb_CRFForms crf ON fr.crfFormsID = crf.crfFormsID
        LEFT JOIN tb_QuestionGroupForm qgf ON crf.crfFormsID = qgf.crfFormsID
        LEFT JOIN tb_Questions q ON qgf.questionID = q.questionID
        LEFT JOIN tb_QuestionType qt ON q.questionTypeID = qt.questionTypeID
        LEFT JOIN tb_QuestionGroup qg ON q.questionGroupID = qg.questionGroupID
        LEFT JOIN tb_ListType lt ON q.listTypeID = lt.listTypeID
        LEFT JOIN tb_questiongroupformrecord qgfr ON qgfr.questionID = q.questionID
        LEFT JOIN tb_ListOfValues lv ON qgfr.listOfValuesID = lv.listOfValuesID
        WHERE
            fr.formRecordID = ?
        AND
            q.subordinateTo IS NULL
        ORDER BY qgf.questionOrder ASC;`;

    try {
        const result = await connection.asyncQuery(query, req.params.formRecordID);
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
router.get('/:formRecordID/subordinate/:questionID', async (req, res) => {
    const query = `
        SELECT
            fr.formRecordID,
            fr.dtRegistroForm,
            crf.crfFormsID,
            crf.description crfDescription,

            qgfr.questionGroupFormRecordID,
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
            qg.description questionGroupDescription

        FROM tb_FormRecord fr
        LEFT JOIN tb_CRFForms crf ON fr.crfFormsID = crf.crfFormsID
        LEFT JOIN tb_QuestionGroupForm qgf ON crf.crfFormsID = qgf.crfFormsID
        LEFT JOIN tb_Questions q ON qgf.questionID = q.questionID
        LEFT JOIN tb_QuestionType qt ON q.questionTypeID = qt.questionTypeID
        LEFT JOIN tb_QuestionGroup qg ON q.questionGroupID = qg.questionGroupID
        LEFT JOIN tb_ListType lt ON q.listTypeID = lt.listTypeID
        LEFT JOIN tb_questiongroupformrecord qgfr ON qgfr.questionID = q.questionID
        LEFT JOIN tb_ListOfValues lv ON qgfr.listOfValuesID = lv.listOfValuesID
        WHERE
            fr.formRecordID = ?
        AND
            q.subordinateTo = ?
        ORDER BY qgf.questionOrder ASC;`;

    try {
        const result = await connection.asyncQuery(query, req.params.formRecordID, req.params.questionID);
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
router.get('/:formRecordID/history', async (req, res) => {
    try {
        const results = await connection.asyncQuery(`
            SELECT
                log,
                changedOn,
                operation
            FROM tb_notificationrecord
            WHERE log LIKE '%\"formRecordID\": ?%'
            ORDER BY changedOn DESC;`, parseInt(req.params.formRecordID));
        res.status(200);
        return res.json({
            error: false,
            data: results.map((r: any) => {
                r.log = JSON.parse(r.log);
                return r;
            })
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
router.get('/:formRecordID/details', async (req, res) => {
    try {
        const results = await connection.asyncQuery(`
            SELECT *
            FROM tb_formrecord fr
            LEFT JOIN tb_hospitalunit h ON fr.hospitalunitid = h.hospitalunitid
            LEFT JOIN tb_participant p ON fr.participantid = p.participantid
            LEFT JOIN tb_questionnaire q ON fr.questionnaireid = q.questionnaireid
            WHERE formRecordID = ?;`, parseInt(req.params.formRecordID));
        res.status(200);
        return res.json({
            error: false,
            data: results && results.length ? results[0] : undefined
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
        const assesments = await connection.asyncQuery(`
            SELECT a.participantID, a.hospitalUnitID, a.questionnaireID
            FROM tb_AssessmentQuestionnaire a
            WHERE
                a.participantID = ?
            AND
                a.hospitalUnitID = ?
            AND
                a.questionnaireID = ?;`, params.participantID, params.hospitalUnitID, params.questionnaireID);

        if (!assesments || !assesments.length) {
            await connection.asyncQuery(`
                INSERT INTO
                    tb_AssessmentQuestionnaire (participantID, hospitalUnitID, questionnaireID)
                VALUES (?, ?, ?);`, params.participantID, params.hospitalUnitID, params.questionnaireID);
        }

        const result = await connection.asyncQuery(`
                INSERT INTO
                    tb_FormRecord (participantID, hospitalUnitID, questionnaireID, crfFormsID, dtRegistroForm)
                VALUES (?, ?, ?, ?, NOW());`, params.participantID, params.hospitalUnitID, params.questionnaireID, params.crfFormsID);

        if (result.insertId) {
            connection.asyncCommit();
            const formRecord = await connection.asyncQuery(`
                SELECT
                    fr.formRecordID,
                    crf.description,
                    fr.dtRegistroForm,
                    fr.crfFormsID
                FROM tb_FormRecord fr
                LEFT JOIN tb_CRFForms crf ON fr.crfFormsID = crf.crfFormsID
                WHERE
                    fr.formRecordID = ?;`, result.insertId);
            res.status(200);
            return res.json({
                error: false,
                data: formRecord[0]
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
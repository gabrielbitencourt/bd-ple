import { Router } from 'express';
import passport from 'passport';
import authRoutes from './auth';
import questionnaireRoutes from './questionnaire';
import formRecordRoutes from './form-record';
import participantRoutes from './participant';
import hospitalRoutes from './hospital';
import crfRoutes from './crf';

const router = Router();
router.use('/auth', authRoutes);
router.use('/questionnaire', passport.authenticate('jwt-cookie', { session: false }), questionnaireRoutes);
router.use('/form-records', passport.authenticate('jwt-cookie', { session: false }), formRecordRoutes);
router.use('/participant', passport.authenticate('jwt-cookie', { session: false }), participantRoutes);
router.use('/hospital', passport.authenticate('jwt-cookie', { session: false }), hospitalRoutes);
router.use('/crf', passport.authenticate('jwt-cookie', { session: false }), crfRoutes);
export default router;
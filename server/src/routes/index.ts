import { Router } from 'express';
import passport from 'passport';
import authRoutes from './auth';
import questionnaireRoutes from './questionnaire';
import formRecordRoutes from './form-record';

const router = Router();
router.use('/auth', authRoutes);
router.use('/questionnaire', passport.authenticate('jwt-cookie', { session: false }), questionnaireRoutes);
router.use('/form-records', passport.authenticate('jwt-cookie', { session: false }), formRecordRoutes);
export default router;
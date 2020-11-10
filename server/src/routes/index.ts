import { Router } from 'express';
import passport from 'passport';
import authRoutes from './auth';
import questionnaireRoutes from './questionnaire';

const router = Router();
router.use('/auth', authRoutes);
router.use('/questionnaire', passport.authenticate('jwt-cookie', { session: false }), questionnaireRoutes);
export default router;
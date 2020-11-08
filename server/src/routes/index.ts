import { Router } from 'express';
import passport from 'passport';
import authRoutes from './auth';

const router = Router();
router.use('/auth', authRoutes);
// router.use('/others', passport.authenticate('jwt-cookie', { session: false }));
export default router;
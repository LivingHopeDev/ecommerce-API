import { Router } from "express";
import authRoutes from "./auth";
import productRoute from "./product";
const rootRouter: Router = Router();

rootRouter.use("/auth", authRoutes);
rootRouter.use("/products", productRoute);

export default rootRouter;

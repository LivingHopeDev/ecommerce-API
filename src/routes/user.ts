import { Router } from "express";
import {
  addAddress,
  deleteAddress,
  listddress,
  updateAddress,
} from "../controllers/user";
import { authMiddleware } from "../middlewares/auth";
// import { adminMiddleware } from "../middlewares/admin";
import { errorHandler } from "../error-handler";
const userRoutes: Router = Router();
userRoutes.post("/", [authMiddleware], errorHandler(addAddress));
userRoutes.get("/", [authMiddleware], errorHandler(listddress));
userRoutes.delete("/:id", [authMiddleware], errorHandler(deleteAddress));
userRoutes.put("/", [authMiddleware], errorHandler(updateAddress));

export default userRoutes;

import { Router } from "express";
import {
  addAddress,
  deleteAddress,
  listaddress,
  updateAddress,
  listUsers,
  ChangeUserRole,
  getUserById,
} from "../controllers/user";
import { authMiddleware } from "../middlewares/auth";
// import { adminMiddleware } from "../middlewares/admin";
import { errorHandler } from "../error-handler";
import adminMiddleware from "../middlewares/admin";
const userRoutes: Router = Router();
userRoutes.post("/address", [authMiddleware], errorHandler(addAddress));
userRoutes.get("/address", [authMiddleware], errorHandler(listaddress));
userRoutes.delete(
  "/address/:id",
  [authMiddleware],
  errorHandler(deleteAddress)
);
userRoutes.put("/address", [authMiddleware], errorHandler(updateAddress));
userRoutes.put(
  "/:id/role",
  [authMiddleware, adminMiddleware],
  errorHandler(ChangeUserRole)
);
userRoutes.get("/", [authMiddleware, adminMiddleware], errorHandler(listUsers));
userRoutes.get(
  "/:id",
  [authMiddleware, adminMiddleware],
  errorHandler(getUserById)
);

export default userRoutes;

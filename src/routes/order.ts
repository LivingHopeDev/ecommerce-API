import { Router } from "express";
import {
  createOrder,
  listOrders,
  getOrderById,
  cancelOrder,
  changeStatus,
  listUserOrders,
  listAllOrders,
} from "../controllers/order";
import { authMiddleware } from "../middlewares/auth";
import adminMiddleware from "../middlewares/admin";
import { errorHandler } from "../error-handler";
const orderRoute: Router = Router();
orderRoute.post("/", [authMiddleware], errorHandler(createOrder));
orderRoute.get("/", [authMiddleware], errorHandler(listOrders));
orderRoute.get(
  "/all",
  [authMiddleware, adminMiddleware],
  errorHandler(listAllOrders)
);
orderRoute.put("/:id/cancel", [authMiddleware], errorHandler(cancelOrder));
orderRoute.get(
  "/users/:id",
  [authMiddleware, adminMiddleware],
  errorHandler(listUserOrders)
);
orderRoute.put(
  "/:id/status",
  [authMiddleware, adminMiddleware],
  errorHandler(changeStatus)
);
orderRoute.get("/:id", [authMiddleware], errorHandler(getOrderById));

export default orderRoute;

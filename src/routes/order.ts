import { Router } from "express";
import {
  createOrder,
  listOrders,
  getOrderById,
  cancelOrder,
} from "../controllers/order";
import { authMiddleware } from "../middlewares/auth";
// import { adminMiddleware } from "../middlewares/admin";
import { errorHandler } from "../error-handler";
const orderRoute: Router = Router();
orderRoute.post("/", [authMiddleware], errorHandler(createOrder));
orderRoute.get("/", [authMiddleware], errorHandler(listOrders));
orderRoute.get("/:id", [authMiddleware], errorHandler(getOrderById));
orderRoute.put("/:id/cancel", [authMiddleware], errorHandler(cancelOrder));

export default orderRoute;

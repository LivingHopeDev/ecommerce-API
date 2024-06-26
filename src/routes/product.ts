import { Router } from "express";
import {
  createProduct,
  updateProduct,
  listProducts,
  deleteProduct,
  getProductById,
  searchProduct,
} from "../controllers/product";
import { errorHandler } from "../error-handler";
import { authMiddleware } from "../middlewares/auth";
import adminMiddleware from "../middlewares/admin";
const productRoutes: Router = Router();
productRoutes.post(
  "/",
  [authMiddleware, adminMiddleware],
  errorHandler(createProduct)
);
productRoutes.get(
  "/search",
  [authMiddleware, adminMiddleware],
  errorHandler(searchProduct)
);
productRoutes.put(
  "/:id",
  [authMiddleware, adminMiddleware],
  errorHandler(updateProduct)
);
productRoutes.get(
  "/",
  [authMiddleware, adminMiddleware],
  errorHandler(listProducts)
);
productRoutes.delete(
  "/:id",
  [authMiddleware, adminMiddleware],
  errorHandler(deleteProduct)
);
productRoutes.get(
  "/:id",
  [authMiddleware, adminMiddleware],
  errorHandler(getProductById)
);
export default productRoutes;

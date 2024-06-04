import express, { Express, Response, Request } from "express";
import { PORT } from "./secrets";
import rootRouter from "./routes";
import { PrismaClient } from "@prisma/client";
import { errorMiddleware } from "./middlewares/error";
const app: Express = express();
app.use(express.json());
app.use("/api", rootRouter);

export const prismaClient = new PrismaClient({
  log: ["query"],
});
app.use(errorMiddleware);
app.listen(PORT, () => {
  console.log("Server running on port 3001");
});
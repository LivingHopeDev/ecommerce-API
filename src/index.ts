import express, { Express, Response, Request } from "express";
import { PORT } from "./secrets";
import rootRouter from "./routes";
import { PrismaClient } from "@prisma/client";
import { errorMiddleware } from "./middlewares/error";
const app: Express = express();
app.use(express.json());
app.use("/api", rootRouter);
app.get("/", (req, res) => {
  res.send("Hello from entry file");
});

export const prismaClient = new PrismaClient({
  log: ["query"],
}).$extends({
  result: {
    address: {
      formattedAddress: {
        needs: {
          lineOne: true,
          lineTwo: true,
          city: true,
          country: true,
          pincode: true,
        },
        compute: (addr) => {
          return `${addr.lineOne}, ${addr.lineTwo},${addr.city}, ${addr.country} - ${addr.pincode}`;
        },
      },
    },
  },
});
app.use(errorMiddleware);
// app.listen(PORT, () => {
//   console.log("Server running on port 3001");
// });

export default app;

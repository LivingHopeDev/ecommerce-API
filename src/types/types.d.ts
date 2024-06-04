import { User } from "@prisma/client";
import { Request } from "express";
// declare module "express-serve-static-core" {
//   export interface Request {
//     user: User; // (?) Optional property to avoid type errors if user isn't always present
//   }
// }

export interface CustomRequest extends Request {
  user?: User;
}

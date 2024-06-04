import { NextFunction, Request, Response } from "express";
import { UnauthorizedException } from "../exceptions/unauthorized";
import { ErrorCode } from "../exceptions/root";
import { CustomRequest } from "../types/types";

const adminMiddleware = async (
  req: CustomRequest,
  res: Response,
  next: NextFunction
) => {
  const user = req.user;
  if (user?.role === "ADMIN") {
    next();
  } else {
    next(new UnauthorizedException("Unauthorized", ErrorCode.UNATHORIZED));
  }
};

export default adminMiddleware;

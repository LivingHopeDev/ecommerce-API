import { NextFunction, Request, Response } from "express";
import { UnauthorizedException } from "../exceptions/unauthorized";
import { ErrorCode } from "../exceptions/root";
import * as jwt from "jsonwebtoken";
import { JWT_SCERET } from "../secrets";
import { prismaClient } from "..";
import { CustomRequest } from "../types/types";
export const authMiddleware = async (
  req: CustomRequest,
  res: Response,
  next: NextFunction
) => {
  const token = req.headers.authorization!;
  if (!token) {
    next(
      new UnauthorizedException("Unauthenticated", ErrorCode.UNAUTHENTICATED)
    );
  }
  try {
    const payload = jwt.verify(token, JWT_SCERET) as any;
    const user = await prismaClient.user.findFirst({
      where: { id: payload.userId },
    });
    if (!user) {
      return next(
        new UnauthorizedException("Unauthenticated", ErrorCode.UNAUTHENTICATED)
      );
    }
    req.user = user;
    next();
  } catch (error) {
    return next(
      new UnauthorizedException("Unauthenticated", ErrorCode.UNAUTHENTICATED)
    );
  }
};

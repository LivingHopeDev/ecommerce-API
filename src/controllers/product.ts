import { Request, Response } from "express";
import { prismaClient } from "..";
import { productSchema } from "../schema/product";

export const createProduct = async (req: Request, res: Response) => {
  productSchema.parse(req.body);

  let product = await prismaClient.product.create({
    data: {
      ...req.body,
      tags: req.body.tags.join(","),
    },
  });
  res.status(201).json(product);
};

import { Request, Response } from "express";
import { ChangeQuantitySchema, CreateCartSchema } from "../schema/cart";
import { NotFoundException } from "../exceptions/notFound";
import { ErrorCode } from "../exceptions/root";
import { CartItem, Product } from "@prisma/client";
import { prismaClient } from "..";
import { CustomRequest } from "../types/types";

export const addItemToCart = async (req: CustomRequest, res: Response) => {
  const validatedData = CreateCartSchema.parse(req.body);
  let product: Product;
  try {
    product = await prismaClient.product.findFirstOrThrow({
      where: {
        id: validatedData.productId,
      },
    });
  } catch (error) {
    throw new NotFoundException(
      "Product not found",
      ErrorCode.PRODUCT_NOT_FOUND
    );
  }
  let itemInCart;
  itemInCart = await prismaClient.cartItem.findFirst({
    where: {
      productId: product.id,
      userId: req.user?.id,
    },
  });
  if (itemInCart) {
    itemInCart.quantity += validatedData.quantity;
    itemInCart = await prismaClient.cartItem.update({
      where: {
        id: itemInCart.id,
      },
      data: {
        quantity: itemInCart.quantity,
      },
    });
  } else {
    itemInCart = await prismaClient.cartItem.create({
      data: <any>{
        userId: req.user?.id,
        productId: product.id,
        quantity: validatedData.quantity,
      },
    });
  }
  res.status(200).json(itemInCart);
};

export const deleteItemFromCart = async (req: CustomRequest, res: Response) => {
  try {
    //ensure the user is deleting his own cart item
    const itemInCart = await prismaClient.cartItem.findFirst({
      where: {
        id: +req.params.id,
        userId: req.user?.id,
      },
    });
    if (!itemInCart) {
      return res.json({ success: false, message: "Item not found!" });
    }
    await prismaClient.cartItem.delete({
      where: {
        id: +req.params.id,
      },
    });
    res.json({ success: true, message: "Item deleted" });
  } catch (error) {
    throw new NotFoundException(
      "Product not found",
      ErrorCode.PRODUCT_NOT_FOUND
    );
  }
};
export const changeQuantity = async (req: CustomRequest, res: Response) => {
  const validatedData = ChangeQuantitySchema.parse(req.body);
  try {
    const itemInCart = await prismaClient.cartItem.findFirst({
      where: {
        id: +req.params.id,
        userId: req.user?.id,
      },
    });
    if (!itemInCart) {
      return res.json({ success: false, message: "Item not found!" });
    }
    const updatedCart = await prismaClient.cartItem.update({
      where: {
        id: +req.params.id,
      },
      data: {
        quantity: validatedData.quantity,
      },
    });
    res.json(updatedCart);
  } catch (error) {
    throw new NotFoundException(
      "Product not found",
      ErrorCode.PRODUCT_NOT_FOUND
    );
  }
};
export const getCart = async (req: CustomRequest, res: Response) => {
  const listItems = await prismaClient.cartItem.findMany({
    where: {
      userId: req.user?.id,
    },
    include: {
      product: true,
    },
  });
  if (listItems.length === 0) {
    return res.json({ message: "Cart is empty:Shop now!", data: listItems });
  }
  res.json(listItems);
};

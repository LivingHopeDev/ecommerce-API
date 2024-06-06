import { Request, Response } from "express";
import { prismaClient } from "..";
import { CustomRequest } from "../types/types";

export const createOrder = async (req: CustomRequest, res: Response) => {
  return await prismaClient.$transaction(async (tx) => {
    const cartItems = await tx.cartItem.findMany({
      where: {
        userId: req.user?.id,
      },
      include: {
        product: true,
      },
    });
    if (cartItems.length === 0) {
      return res.json({ message: "Cart is empty", data: cartItems });
    }
    const price = cartItems.reduce((total, current) => {
      return total + current.quantity * +current.product.price;
    }, 0);
    const address = await tx.address.findFirst({
      where: {
        id: req.user?.defaultShippingAddressId as number,
      },
    });
    const order = await tx.order.create({
      data: {
        userId: req.user?.id!,
        netAmount: price,
        address: address?.formattedAddress as string,
        products: {
          create: cartItems.map((item) => {
            return {
              productId: item.productId,
              quantity: item.quantity,
            };
          }),
        },
      },
    });
    const orderEvent = await tx.orderEvent.create({
      data: {
        orderId: order.id,
      },
    });
    await tx.cartItem.deleteMany({
      where: {
        userId: req.user?.id,
      },
    });
    return res.json(order);
  });
};
export const cancelOrder = async (req: Request, res: Response) => {};
export const listOrders = async (req: Request, res: Response) => {};
export const getOrderById = async (req: Request, res: Response) => {};

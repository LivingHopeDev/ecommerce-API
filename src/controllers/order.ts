import { Request, Response } from "express";
import { prismaClient } from "..";
import { CustomRequest } from "../types/types";
import { NotFoundException } from "../exceptions/notFound";
import { ErrorCode } from "../exceptions/root";
import { json } from "stream/consumers";

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
    cartItems.map((item) => {
      console.log(item.quantity, item.productId);
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
export const cancelOrder = async (req: CustomRequest, res: Response) => {
  return await prismaClient.$transaction(async (tx) => {
    try {
      const order = await tx.order.update({
        where: {
          id: +req.params.id,
        },
        data: {
          status: "CANCELLED",
        },
      });
      if (order.userId !== req.user?.id) {
        return res.json({ message: "Unauthorized: This is not your order" });
      }
      await tx.orderEvent.create({
        data: {
          orderId: order.id,
          status: "CANCELLED",
        },
      });
      res.json(order);
    } catch (error) {
      throw new NotFoundException("Order not found", ErrorCode.ORDER_NOT_FOUND);
    }
  });
};
export const listOrders = async (req: CustomRequest, res: Response) => {
  const orders = await prismaClient.order.findMany({
    where: {
      userId: req.user?.id,
    },
  });
  res.json(orders);
};
export const getOrderById = async (req: CustomRequest, res: Response) => {
  try {
    const order = await prismaClient.order.findFirstOrThrow({
      where: {
        id: +req.params.id,
      },
      include: {
        products: true,
        events: true,
      },
    });
    res.json(order);
  } catch (error) {
    throw new NotFoundException("Order not found", ErrorCode.ORDER_NOT_FOUND);
  }
};

export const listAllOrders = async (req: Request, res: Response) => {
  // THE ORDER STATUS CAN BE PROVIDED FOR FILTERING
  const orders = await prismaClient.order.findMany({
    skip: Number(req.query.skip) || 0,
    take: 10,
  });
  res.json(orders);
};
export const changeStatus = async (req: Request, res: Response) => {
  return await prismaClient.$transaction(async (tx) => {
    const order = await tx.order.update({
      where: {
        id: +req.params.id,
      },
      data: {
        status: req.body.status,
      },
    });
    if (!order) {
      throw new NotFoundException("Order not found", ErrorCode.ORDER_NOT_FOUND);
    }
    await tx.orderEvent.create({
      data: {
        orderId: order.id,
        status: req.body.status,
      },
    });
    res.json(order);
  });
};
export const listUserOrders = async (req: Request, res: Response) => {
  const orders = await prismaClient.order.findMany({
    where: {
      userId: +req.params.id,
    },
    skip: Number(req.query.skip) || 0,
    take: 10,
  });
  res.json(orders);
};

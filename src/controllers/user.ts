import { Request, Response } from "express";
import { AddressSchema, UpdateUserSchema } from "../schema/users";
import { Address, User } from "@prisma/client";
import { prismaClient } from "..";
import { CustomRequest } from "../types/types";
import { NotFoundException } from "../exceptions/notFound";
import { ErrorCode } from "../exceptions/root";
import { BadRequestsException } from "../exceptions/badRequest";
export const addAddress = async (req: CustomRequest, res: Response) => {
  let user: User;
  AddressSchema.parse(req.body);
  user = await prismaClient.user.findFirstOrThrow({
    where: { id: req.body.userId },
  });
  const address = await prismaClient.address.create({
    data: {
      ...req.body,
      userId: req.user?.id,
    },
  });
  res.status(200).json(address);
};
export const deleteAddress = async (req: Request, res: Response) => {
  try {
    await prismaClient.address.delete({
      where: {
        id: +req.params.id,
      },
    });
    res.status(200).json({ message: "Address deleted" });
  } catch (error) {
    throw new NotFoundException(
      "Addres not found",
      ErrorCode.ADDRESS_NOT_FOUND
    );
  }
};
export const listddress = async (req: CustomRequest, res: Response) => {
  const addresses = await prismaClient.address.findMany({
    where: {
      userId: req.user?.id,
    },
  });
  res.status(200).json(addresses);
};

export const updateAddress = async (req: CustomRequest, res: Response) => {
  const validatedData = UpdateUserSchema.parse(req.body);
  let billingAddress: Address;
  let shippingAddress: Address;
  if (validatedData.defaultBillingAddressId) {
    try {
      billingAddress = await prismaClient.address.findFirstOrThrow({
        where: {
          id: validatedData.defaultBillingAddressId,
        },
      });
      console.log("address", billingAddress);
      console.log("user id", req.user?.id);
    } catch (error) {
      throw new NotFoundException(
        "Address not found",
        ErrorCode.ADDRESS_NOT_FOUND
      );
    }
    if (billingAddress.userId !== req.user?.id) {
      throw new BadRequestsException(
        "Address doesn't belong to you",
        ErrorCode.ADDRESS_DOES_NOT_BELONG,
        null
      );
    }
  }

  if (validatedData.defaultShippingAddressId) {
    try {
      shippingAddress = await prismaClient.address.findFirstOrThrow({
        where: {
          id: validatedData.defaultShippingAddressId,
        },
      });
    } catch (error) {
      throw new NotFoundException(
        "Address not found",
        ErrorCode.ADDRESS_NOT_FOUND
      );
    }
    if (shippingAddress.userId !== req.user?.id) {
      throw new BadRequestsException(
        "Address doesn't belong to you",
        ErrorCode.ADDRESS_DOES_NOT_BELONG,
        null
      );
    }
  }
  const updatedAddress = await prismaClient.user.update({
    where: {
      id: req.user?.id,
    },
    data: validatedData,
  });

  res.status(200).json({ message: "Address updated", data: updatedAddress });
};
